import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';

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

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    try {
      emitSuccess(successResponse: "Successfully Login");
      await SharedPreferencesHelper.saveBiometric(biometric: true);
    } catch (e) {
      e.toString();
    }
  }
}
