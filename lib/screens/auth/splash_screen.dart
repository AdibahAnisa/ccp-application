import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:project/app/helpers/biometric_helper.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/app/helpers/global_method.dart';
import 'package:project/resources/auth/auth_resources.dart';
import 'package:project/models/offences_rule/offence_data_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final BiometricHelper biometricHelper = BiometricHelper();

  bool _isLoading = false;
  bool _isInit = false;
  late bool biometricStatus;

  OffenceDataModel? offenceData;

  @override
  void initState() {
    super.initState();
    biometricStatus = false;
    getBiometric();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initialize();
  }

  Future<void> getBiometric() async {
    biometricStatus = await SharedPreferencesHelper.getBiometric();
  }

  Future<void> _initialize() async {
    if (_isInit) return;

    await Future.delayed(const Duration(milliseconds: 1500));

    final token = await AuthResources.getToken();

    // Token exists, try biometric
    if (token != null) {
      final isAvailable = await biometricHelper.isBiometricAvailable();

      if (isAvailable) {
        setState(() => _isLoading = true);

        final isAuthenticated = await biometricHelper.authenticateUser();

        if (isAuthenticated) {
          // Fetch offence data before going home
          offenceData = await fetchOffenceAreasList();
          Navigator.pushReplacementNamed(
            context,
            AppRoute.homeScreen,
            arguments: {'offenceData': offenceData},
          );
        } else {
          // Biometric failed, go to login
          Navigator.pushReplacementNamed(
            context,
            AppRoute.loginScreen,
            arguments: {'isBiometric': biometricStatus},
          );
        }

        setState(() => _isLoading = false);
      } else {
        // Biometric not available, go home
        offenceData = await fetchOffenceAreasList();
        Navigator.pushReplacementNamed(
          context,
          AppRoute.homeScreen,
          arguments: {'offenceData': offenceData},
        );
      }
    } else {
      // No token, go to login
      Navigator.pushReplacementNamed(context, AppRoute.loginScreen);
    }

    _isInit = true;
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
                      backgroundColor: Colors.transparent,
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
