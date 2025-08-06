// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/widget/custom_dialog.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final UserModel userModel;
  String lastUpdated = '';
  late Map<String, dynamic> details;
  Location locationController = Location();
  late final List<PromotionMonthlyPassModel> promotionMonthlyPassModel;
  List<NotificationModel> notificationList = []; // List to store models

  DateTime? currentTime;

  @override
  void initState() {
    super.initState();
    getCurrentTime();
    analyzeLocation();
    getLocation();
    userModel = UserModel();

    promotionMonthlyPassModel =
        List<PromotionMonthlyPassModel>.empty(growable: true);
  }

  Future<void> getCurrentTime() async {
    currentTime = await NTP.now();
  }

  Future<void> getLocation() async {
    PermissionStatus permissionGranted;

    permissionGranted = await locationController.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      await CustomDialog.show(
        context,
        icon: Icons.location_on,
        dialogType: 2,
        description:
            'This app needs access to your location to function. Do you want to enable it?',
        // btnOkText: 'Continue',
        // btnOkOnPress: () async {
        //   permissionGranted = await locationController.requestPermission();
        //   await permission.Permission.notification.request();
        //   await permission.Permission.ignoreBatteryOptimizations.request();
        //   if (permissionGranted != PermissionStatus.granted) {
        //     return;
        //   } else {
        //     Navigator.pop(context);

        //     // await _checkBatteryOptimization();
        //   }
        // },
        btnOkText: AppLocalizations.of(context)!.yes,
        btnOkOnPress: () async {
          permissionGranted = await locationController.requestPermission();
          await permission.Permission.notification.request();
          await permission.Permission.ignoreBatteryOptimizations.request();
          if (permissionGranted != PermissionStatus.granted) {
            return;
          } else {
            Navigator.pop(context);

            // await _checkBatteryOptimization();
          }
        },
        btnCancelText: AppLocalizations.of(context)!.no,
        btnCancelOnPress: () => Navigator.pop(context),
      );
    }
  }

  Future<void> analyzeLocation() async {
    details = await SharedPreferencesHelper.getLocationDetails();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyToken);
    await SharedPreferencesHelper.saveBiometric(biometric: false);
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoute.loginScreen, (context) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        CustomDialog.show(
          context,
          title: AppLocalizations.of(context)!.exitApp,
          description: AppLocalizations.of(context)!.exitAppDesc,
          btnOkText: AppLocalizations.of(context)!.exit,
          btnCancelText: AppLocalizations.of(context)!.cancel,
          btnOkOnPress: () {
            exit(0);
          },
          btnCancelOnPress: () => Navigator.pop(context),
        );
        return Future.value(false);
      },
      child: const Scaffold(body: LoadingDialog()),
    );
  }
}
