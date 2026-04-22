import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project/resources/auth/auth_resources.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/screens/home/components/parking_alert.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("📩 BACKGROUND MESSAGE RECEIVED");
}

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // Request permission
    await _messaging.requestPermission();

    // Get token
    String? token = await _messaging.getToken();
    print("🔥 FCM Token: $token");

    if (token != null) {
      await _sendTokenToBackend(token);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 FOREGROUND MESSAGE RECEIVED");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");

      handleNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📲 USER CLICKED NOTIFICATION");

      handleNotification(message);
    });

    RemoteMessage? initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      print("🚀 App opened from terminated state");

      handleNotification(initialMessage);
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      print("🔄 FCM Token refreshed: $newToken");
      await _sendTokenToBackend(newToken);
    });
  }

  void handleNotification(RemoteMessage message) {
    final type = message.data['type'];
    final plateNumber = message.data['plateNumber'];

    // 🔥 ONLY show dialog for enforcement case
    if (type == "CONFIRM_PARKING") {
      // Prevent multiple dialogs
      if (Get.isDialogOpen == true) return;

      Future.delayed(Duration.zero, () {
        Get.dialog(
          ParkingAlertDialog(plateNumber: plateNumber),
          barrierDismissible: false,
        );
      });

      return;
    }

    String msg = "";

    if (type == "PAID") {
      msg =
          "Terima kasih 😊 No plate $plateNumber telah membuat bayaran parking.";
    } else if (type == "AUTO_PAID") {
      msg = "Bayaran dibuat secara automatik untuk $plateNumber.";
    } else if (type == "NO_WALLET") {
      msg = "Tiada wallet. Sila tambah kaedah pembayaran.";
    } else if (type == "AUTO_OFF") {
      msg = "Sila aktifkan auto deduct.";
    } else if (type == "SETUP_REQUIRED") {
      msg = "Sila lengkapkan setup pembayaran.";
    } else {
      msg = "Notifikasi diterima.";
    }

    Get.to(() => NotificationPage(message: msg));
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

      print("✅ FCM token sent to backend");
    } catch (e) {
      print("❌ Failed to send FCM token: $e");
    }
  }

  Future<String?> getTokenOnly() async {
    await _messaging.requestPermission();
    return await _messaging.getToken();
  }

  Future<void> sendTokenAfterLogin() async {
    String? token = await _messaging.getToken();

    if (token != null) {
      await _sendTokenToBackend(token);
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      await _sendTokenToBackend(newToken);
    });
  }
}

class NotificationPage extends StatelessWidget {
  final String message;

  const NotificationPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification")),
      body: Center(
        child: Text(message),
      ),
    );
  }
}
