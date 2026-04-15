import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project/resources/auth/auth_resources.dart';
import 'package:project/app/helpers/shared_preferences.dart';

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("📩 BACKGROUND MESSAGE RECEIVED");
  }

  Future<void> init() async {
    // Request permission
    await _messaging.requestPermission();

    // Get token
    String? token = await _messaging.getToken();

    if (token != null) {
      await _sendTokenToBackend(token);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 FOREGROUND MESSAGE RECEIVED");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📲 USER CLICKED NOTIFICATION");
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for refresh
    _messaging.onTokenRefresh.listen((newToken) async {
      await _sendTokenToBackend(newToken);
    });
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
