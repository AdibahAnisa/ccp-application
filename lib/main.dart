import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/app/app.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:project/services/fcm_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:project/controllers/active_parking_controller.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 Background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // FIRST RUN LOGIC
  final isFirstRun = await SharedPreferencesHelper.getDefaultSetting();

  if (isFirstRun) {
    await SharedPreferencesHelper.saveLocationDetail();
    await SharedPreferencesHelper.setDefaultSetting(false);
  }

  Get.put(ActiveParkingController());

  runApp(const CityCarPark(
    defaultLanguage: 'en',
  ));
}
