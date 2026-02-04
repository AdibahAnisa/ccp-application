import 'dart:async';
import 'dart:convert';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/resources/resources.dart';

class ForgotPasswordFormBloc extends FormBloc<String, String> {
  final email = TextFieldBloc(
    validators: [
      InputValidator.emailChar,
      InputValidator.required,
    ],
  );

  ForgotPasswordFormBloc() {
    addFieldBlocs(fieldBlocs: [email]);
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      // Save email locally
      await SharedPreferencesHelper.setEmailResetPassword(
          email: email.value.toLowerCase());

      // Call backend API
      final response = await AuthResources.forgotPassword(
        prefix: '/forgot-password',
        body: jsonEncode({"email": email.value.toLowerCase()}),
      );

      if (response['error'] != null) {
        emitFailure(failureResponse: response['error'].toString());
      } else {
        emitSuccess(successResponse: response['message']);
      }
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }
}

class ResetPasswordFormBloc extends FormBloc<String, String> {
  final otp = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  ResetPasswordFormBloc() {
    addFieldBlocs(fieldBlocs: [otp, password]);
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      // Retrieve saved email
      final email = await SharedPreferencesHelper.getEmailResetPasswords();

      // Call backend API to reset password
      final response = await AuthResources.resetPassword(
        prefix: '/forgot-password/reset',
        body: jsonEncode({
          "email": email,
          "otp": otp.value.toString(),
          "newPassword": password.value.toString(),
        }),
      );

      if (response['error'] != null) {
        emitFailure(failureResponse: response['error'].toString());
      } else {
        emitSuccess(successResponse: response['message']);
      }
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }
}
