import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // INITIALIZE NOTIFICATION
  Future<void> initNotification() async {
    if (_isInitialized) return; //prevent re-initialization

    //prepare initialization settings for Android
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/city_car_park');

    //initialize settings for iOS
    const initSettingIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // init setting
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initSettingIOS,
    );

    // initialize plugin
    await notificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // NOTIFICATION DETAILS
  NotificationDetails getNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'city_car_park',
        'City Car Park',
        channelDescription:
            'City Car Park, Your Parking App.',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // SHOW NOTIFICATION
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(),
    );
  }
}
