import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
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
      // If user is logged in, then we can ask for biometric
      final isAvailable = await biometricHelper.isBiometricAvailable();

      if (isAvailable) {
        final isAuthenticated = await biometricHelper.authenticateUser();
        if (isAuthenticated) {
          await fetchOffenceAreasList();
          Navigator.pushReplacementNamed(context, AppRoute.homeScreen);
        } else {
          Navigator.pushReplacementNamed(context, AppRoute.loginScreen, arguments: {
            'isBiometric': biometricStatus,
          });
        }
      } else {
        await fetchOffenceAreasList();
        Navigator.pushReplacementNamed(context, AppRoute.homeScreen);
      }
    } else {
      // No user token found, go to login/signup screen
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
      body: Container(
        decoration: const BoxDecoration(
          color: kWhite,
        ),
        height: double.infinity,
        width: double.infinity,
        child: Image.asset(logo),
      ),
    );
  }
}
