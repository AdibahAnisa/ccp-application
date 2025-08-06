import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';

class SignUpFormBloc extends FormBloc<String, String> {
  final SignUpModel model = SignUpModel();
  final PlateNumberModel plateNumberModel = PlateNumberModel();

  final firstName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final lastName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final email = TextFieldBloc(
    validators: [
      InputValidator.required,
      InputValidator.emailChar,
    ],
  );

  final idNumber = TextFieldBloc();

  final phoneNumber = TextFieldBloc(
    validators: [
      InputValidator.required,
      InputValidator.phoneNo,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      InputValidator.required,
      InputValidator.passwordChar,
    ],
  );

  final confirmPassword = TextFieldBloc();

  final address1 = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final address2 = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final address3 = TextFieldBloc(
    initialValue: '',
  );

  final postcode = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final city = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final carPlateNumber = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final states = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  SignUpFormBloc() {
    // Add a validator for confirmPassword that compares it with password
    confirmPassword.addValidators([
      InputValidator.required,
      (value) {
        if (value != password.value) {
          return 'Passwords do not match';
        }
        return null;
      }
    ]);

    addFieldBlocs(
      step: 0,
      fieldBlocs: [
        firstName,
        lastName,
        email,
        idNumber,
        phoneNumber,
        password,
        confirmPassword,
      ],
    );

    addFieldBlocs(
      step: 1,
      fieldBlocs: [
        address1,
        address2,
        address3,
        postcode,
        city,
        states,
        carPlateNumber,
      ],
    );

    // Listen to changes in the password field and revalidate confirmPassword
    password.onValueChanges(
      onData: (previous, current) async* {
        confirmPassword.updateValue(confirmPassword.value);
      },
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    emitSuccess(successResponse: 'Success Created Account');
  }
}
