import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/auth/auth_resources.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final LoginModel model = LoginModel();

  final email = TextFieldBloc(
    validators: [
      InputValidator.required,
      InputValidator.emailChar,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final rememberMe = BooleanFieldBloc(
    initialValue: false,
  );

  LoginFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        email,
        password,
        rememberMe,
      ],
    );
  }

  Future<String?> getFcmToken() async {
    final messaging = FirebaseMessaging.instance;

    return await messaging.getToken();
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    try {
      // Set model values
      model.email = email.value;
      model.password = password.value;

      // Call login API
      final response = await AuthResources.login(
        prefix: '/auth/signin',
        body: jsonEncode({
          'email': email.value,
          'password': password.value,
        }),
      );

      print("===== LOGIN RESPONSE =====");
      print(response);

      if (response['error'] != null) {
        emitFailure(failureResponse: response['error'].toString());
      } else {
        // Save token and biometric preference
        print(AuthResources.login);
        print(response);
        if (response['token'] != null) {
          await SharedPreferencesHelper.saveToken(response['token']);
        }
        await SharedPreferencesHelper.saveBiometric(biometric: true);

        await FirebaseMessaging.instance.requestPermission();

        String? fcmToken = await FirebaseMessaging.instance.getToken();
        final jwt = await SharedPreferencesHelper.getToken();

        if (fcmToken == null) {
          await Future.delayed(const Duration(seconds: 2));
          fcmToken = await FirebaseMessaging.instance.getToken();
        }

        print("🔥 FCM TOKEN: $fcmToken");

        if (fcmToken != null) {
          await AuthResources.saveFcmToken(
            prefix: '/auth/save-fcm-token',
            headers: {
              'Authorization': 'Bearer $jwt',
            },
            body: {
              'fcmToken': fcmToken,
            },
          );
        }

        emitSuccess(successResponse: "Successfully Login");
      }
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }
}
