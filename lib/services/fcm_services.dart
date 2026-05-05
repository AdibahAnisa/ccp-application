import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project/resources/auth/auth_resources.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/screens/home/components/parking_alert.dart';
import 'package:project/app/helpers/notification_storage.dart';
import 'package:project/controllers/active_parking_controller.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/models/models.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("📩 BACKGROUND MESSAGE RECEIVED");
}

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Inject these from outside if you need the insufficient balance dialog
  /// to open ReloadScreen with full data.
  final Future<UserModel?> Function()? getUserModel;
  final Future<Map<String, dynamic>?> Function()? getDetails;

  FCMService({
    this.getUserModel,
    this.getDetails,
  });

  Future<void> init() async {
    await _messaging.requestPermission();

    final token = await _messaging.getToken();
    debugPrint("🔥 FCM Token: $token");

    if (token != null) {
      await _sendTokenToBackend(token);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 FOREGROUND MESSAGE RECEIVED");
      debugPrint("Title: ${message.notification?.title}");
      debugPrint("Body: ${message.notification?.body}");
      handleNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("📲 USER CLICKED NOTIFICATION");
      handleNotification(message);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint("🚀 App opened from terminated state");
      handleNotification(initialMessage);
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      debugPrint("🔄 FCM Token refreshed: $newToken");
      await _sendTokenToBackend(newToken);
    });
  }

  Future<void> handleNotification(RemoteMessage message) async {
    final data = message.data;

    final type = data['type']?.toString();
    final plateNumber = data['plateNumber']?.toString() ?? "";
    final requiredAmount =
        double.tryParse(data['requiredAmount']?.toString() ?? "0") ?? 0;

    await NotificationStorage.saveNotification({
      "title": message.notification?.title ?? "Parking Notification",
      "description":
          message.notification?.body ?? "Plate $plateNumber detected",
      "plateNumber": plateNumber,
      "type": type,
      "time": DateTime.now().toIso8601String(),
    });

    debugPrint("📩 Notification type: $type");
    debugPrint("🚗 Plate: $plateNumber");
    debugPrint("💰 Required amount: $requiredAmount");

    if (Get.isDialogOpen == true) {
      Get.back();
    }

    final parkingTypes = [
      "READY_TO_DEDUCT",
      "NO_WALLET",
      "AUTO_OFF",
      "NO_WALLET_AND_AUTO_OFF",
    ];

    if (parkingTypes.contains(type)) {
      final userModel = getUserModel != null ? await getUserModel!() : null;
      final details = getDetails != null ? await getDetails!() : null;

      Future.delayed(Duration.zero, () {
        Get.dialog(
          ParkingAlertDialog(
            plateNumber: plateNumber,
            userModel: userModel,
            details: details,
          ),
          barrierDismissible: false,
        );
      });
      return;
    }

    if (type == "PAID") {
      Get.toNamed(AppRoute.notificationScreen);
      return;
    }

    if (type == "AUTO_PAID") {
      final startTime = data["startTime"];
      final endTime = data["endTime"];

      if (startTime != null && endTime != null) {
        final activeParkingController = Get.find<ActiveParkingController>();

        activeParkingController.startActiveParking(
          plateNumber: plateNumber,
          parkingStartTime: DateTime.parse(startTime),
          parkingEndTime: DateTime.parse(endTime),
        );
      }

      return;
    }

    Get.toNamed(AppRoute.notificationScreen);
  }

  Future<void> _sendTokenToBackend(String token) async {
    final jwt = await SharedPreferencesHelper.getToken();

    try {
      await AuthResources.saveFcmToken(
        prefix: '/auth/save-fcm-token',
        headers: {
          'Authorization': 'Bearer $jwt',
        },
        body: {
          'fcmToken': token,
        },
      );

      debugPrint("✅ FCM token sent to backend");
    } catch (e) {
      debugPrint("❌ Failed to send FCM token: $e");
    }
  }

  Future<String?> getTokenOnly() async {
    await _messaging.requestPermission();
    return _messaging.getToken();
  }

  Future<void> sendTokenAfterLogin() async {
    final token = await _messaging.getToken();

    if (token != null) {
      await _sendTokenToBackend(token);
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      await _sendTokenToBackend(newToken);
    });
  }
}
