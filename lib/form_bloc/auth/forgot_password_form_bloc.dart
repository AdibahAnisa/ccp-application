import 'dart:async';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/app/helpers/validators.dart';

class ForgotPasswordFormBloc extends FormBloc<String, String> {
  final email = TextFieldBloc(
    validators: [
      InputValidator.emailChar,
      InputValidator.required,
    ],
  );

  ForgotPasswordFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        email,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      await SharedPreferencesHelper.setEmailResetPassword(
          email: email.value.toLowerCase());

      emitSuccess();
    } catch (e) {
      e.toString();
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
    addFieldBlocs(
      fieldBlocs: [
        otp,
        password,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      emitSuccess();
    } catch (e) {
      e.toString();
    }
  }
}
