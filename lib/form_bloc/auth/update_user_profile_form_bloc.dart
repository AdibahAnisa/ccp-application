import 'dart:async';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/validators.dart';

class UpdateUserProfileFormBloc extends FormBloc<String, String> {
  final email = TextFieldBloc(
    validators: [
      InputValidator.emailChar,
      InputValidator.required,
    ],
  );

  UpdateUserProfileFormBloc() {
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
      emitSuccess();
    } catch (e) {
      e.toString();
    }
  }
}
