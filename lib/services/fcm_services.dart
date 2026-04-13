import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:project/resources/auth/auth_resources.dart';

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // 1. Request permission
    await _messaging.requestPermission();

    // 2. Get token
    String? token = await _messaging.getToken();

    if (token != null) {
      await _sendTokenToBackend(token);
    }

    // 3. Listen for refresh (VERY IMPORTANT)
    _messaging.onTokenRefresh.listen((newToken) async {
      await _sendTokenToBackend(newToken);
    });
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      await AuthResources.saveFcmToken(
        prefix: '/auth/save-fcm-token',
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
