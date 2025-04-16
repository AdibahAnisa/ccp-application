// ignore_for_file: deprecated_member_use

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:project/app/helpers/biometric_helper.dart';
import 'package:project/app/helpers/global_method.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final BiometricHelper biometricHelper = BiometricHelper();
  int activeStepper = 1;
  bool _isLoading = true;

  bool _isInit = false;
  late bool biometricStatus;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  List<OffenceAreasModel> offenceAreasList = []; // List to store models

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initialize();
  }

  @override
  void initState() {
    super.initState();
    // Initialize the biometric status
    biometricStatus = false;
    getBiometric();
  }

  void _initialize() async {
    if (_isInit) return;

    await Future.delayed(const Duration(milliseconds: 1500));

    final token = await AuthResources.getToken();

    if (token != null) {
      final isAvailable = await biometricHelper.isBiometricAvailable();

      if (isAvailable) {
        setState(
            () => _isLoading = true); // Only load if biometric is available

        final isAuthenticated = await biometricHelper.authenticateUser();

        if (isAuthenticated) {
          await fetchOffenceAreasList();
          Navigator.pushReplacementNamed(context, AppRoute.homeScreen);
        } else {
          Navigator.pushReplacementNamed(context, AppRoute.loginScreen,
              arguments: {
                'isBiometric': biometricStatus,
              });
        }

        setState(
            () => _isLoading = false); // End loading after biometric handled
      } else {
        await fetchOffenceAreasList();
        Navigator.pushReplacementNamed(context, AppRoute.homeScreen);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoute.loginScreen);
    }

    _isInit = true;
  }

  Future<void> getBiometric() async {
    biometricStatus = await SharedPreferencesHelper.getBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: kWhite,
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(logo),
          ),
          if (_isLoading && biometricStatus)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Card(
                  child: Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(12.0),
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballRotateChase,
                      colors: [
                        kPrimaryColor,
                        kPrimaryColor.withOpacity(0.5),
                        kWhite
                      ],
                      backgroundColor: Colors.transparent, // transparent now
                      pathBackgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
