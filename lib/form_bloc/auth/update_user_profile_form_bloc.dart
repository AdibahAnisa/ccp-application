import 'dart:async';
import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/resources/resources.dart';

class UpdateUserProfileFormBloc extends FormBloc<String, String> {
  // Field with validators
  final email = TextFieldBloc(
    validators: [
      InputValidator.required,
      InputValidator.emailChar,
    ],
  );

  // Constructor: register field blocs
  UpdateUserProfileFormBloc() {
    addFieldBlocs(fieldBlocs: [email]);
  }

  @override
  FutureOr<void> onSubmitting() async {
    // Simulate loading
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      // Call API to update profile
      final response = await AuthResources.editProfile(
        prefix: '/auth/update',
        body: jsonEncode({'email': email.value}),
      );

      // Handle API response
      if (response['error'] != null) {
        emitFailure(failureResponse: response['error'].toString());
      } else {
        emitSuccess(successResponse: response['message']);
      }
    } catch (e) {
      // Handle unexpected errors
      emitFailure(failureResponse: 'Something went wrong: $e');
    }
  }
}
