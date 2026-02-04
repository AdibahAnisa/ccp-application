import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ActiveParkingController extends GetxController {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Timer? _pollingTimer;
  Timer? _countdownTimer;

  bool autoDeductEnabled = false;
  double tokenBalance = 0.0;

  String? activePlate;
  String? authToken;
  DateTime? parkingStartTime;
  bool isPaid = false;
  bool isCompounded = false;
  double selectedParkingFee = 0.0;

  static const int paymentWindowSeconds = 300; // 5 minutes

  @override
  void onReady() {
    super.onReady();
    _initNotifications();
    _loadUserState();
    _startPollingLpr();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadUserState() async {
    final prefs = await SharedPreferences.getInstance();
    autoDeductEnabled = prefs.getBool('auto_deduct') ?? false;
    tokenBalance = prefs.getDouble('token_balance') ?? 0.0;
    authToken = prefs.getString('auth_token');
  }

  // ===== NOTIFICATION INITIALIZATION =====
  Future<void> _initNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        final plate = response.payload;
        if (plate != null) _onNotificationTapped(plate);
      },
    );
  }

  // ===== LPR POLLING =====
  void _startPollingLpr() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchLprEvent();
    });
  }

  Future<void> _fetchLprEvent() async {
    if (authToken == null) return;

    try {
      final response = await http.get(
        Uri.parse(
          'http://lpr.vista-summerose.com:5002/api/plates?start=2025-08-01&end=2025-08-06',
        ),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        debugPrint('HTTP Error ${response.statusCode}: ${response.body}');
        return;
      }

      final data = jsonDecode(response.body);
      final lprData = data['data'];

      if (lprData is List && lprData.isNotEmpty) {
        for (var eventItem in lprData) {
          final plate = eventItem['plate'] as String?;
          final event = eventItem['event'] as String?;
          if (plate != null && event != null) {
            _handleLprEvent(plate, event);
          }
        }
      } else if (lprData is Map<String, dynamic>) {
        final plate = lprData['plate'] as String?;
        final event = lprData['event'] as String?;
        if (plate != null && event != null) {
          _handleLprEvent(plate, event);
        }
      }
    } catch (e) {
      debugPrint('Error fetching LPR event: $e');
    }
  }

  // ===== HANDLE LPR EVENT =====
  void _handleLprEvent(String plate, String event) {
    // ENTRY
    if (event == 'ENTRY' && plate != activePlate) {
      activePlate = plate;
      isPaid = false;
      isCompounded = false;
      parkingStartTime = DateTime.now();

      _startCountdownTimer();
      _showParkingNotification(plate);
    }

    // EXIT
    if (event == 'EXIT' && plate == activePlate && !isPaid) {
      _autoCompound(reason: 'Exit without payment');
    }
  }

  // ===== COUNTDOWN TIMER =====
  void _startCountdownTimer() {
    final start = parkingStartTime;
    if (start == null) return;

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final elapsed = DateTime.now().difference(start).inSeconds;
      final remaining = paymentWindowSeconds - elapsed;

      if (remaining <= 0 && !isPaid) {
        _countdownTimer?.cancel();
        _autoCompound(reason: 'Payment timeout');
      }
    });
  }

  // ===== SHOW NOTIFICATION =====
  Future<void> _showParkingNotification(String plate) async {
    const androidDetails = AndroidNotificationDetails(
      'parking_channel',
      'Parking Notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    await _notificationsPlugin.show(
      0,
      'Parking Detected',
      'Please pay within 5 minutes.',
      const NotificationDetails(android: androidDetails),
      payload: plate,
    );
  }

  // ===== NOTIFICATION TAP =====
  void _onNotificationTapped(String plate) {
    Get.toNamed(
      '/parking-payment',
      arguments: {
        'plate': plate,
        'onConfirm': handleConfirmParking,
      },
    );
  }

  // ===== CONFIRM PAYMENT =====
  Future<void> handleConfirmParking(double parkingFee) async {
    if (isPaid || isCompounded) {
      Get.snackbar('Not Allowed', 'Parking already processed');
      return;
    }

    selectedParkingFee = parkingFee;

    if (!autoDeductEnabled) {
      _showEnableAutoDeductDialog();
      return;
    }

    if (tokenBalance < parkingFee) {
      _showTopUpDialog();
      return;
    }

    _autoDeductToken();
  }

  // ===== AUTO DEDUCT =====
  Future<void> _autoDeductToken() async {
    tokenBalance -= selectedParkingFee;
    isPaid = true;

    _countdownTimer?.cancel();

    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('token_balance', tokenBalance);

    Get.snackbar('Success', 'Parking fee deducted');
  }

  // ===== AUTO COMPOUND =====
  void _autoCompound({required String reason}) {
    if (isCompounded) return;

    isCompounded = true;
    _countdownTimer?.cancel();

    debugPrint('AUTO COMPOUND: $reason');

    _notificationsPlugin.show(
      1,
      'Parking Compounded',
      reason,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'compound_channel',
          'Compound',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  // ===== ENABLE AUTO DEDUCT =====
  void _showEnableAutoDeductDialog() {
    Get.defaultDialog(
      title: 'Enable Auto Deduct',
      middleText: 'Please enable auto deduct to continue',
      confirm: ElevatedButton(
        onPressed: () async {
          autoDeductEnabled = true;
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('auto_deduct', true);
          Get.back();
          handleConfirmParking(selectedParkingFee);
        },
        child: const Text('Enable'),
      ),
    );
  }

  // ===== TOP UP =====
  void _showTopUpDialog() {
    Get.defaultDialog(
      title: 'Insufficient Token',
      middleText: 'Please top up your token',
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          Get.toNamed('/topup');
        },
        child: const Text('Top Up'),
      ),
    );
  }
}
