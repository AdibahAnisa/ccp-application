import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';

class ReloadFormBloc extends FormBloc<String, String> {
  final UserModel model;
  final Map<String, dynamic> details;
  final other = TextFieldBloc();

  final token = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final amount = TextFieldBloc(
    validators: [
      InputValidator.amount,
    ],
  );

  final paymentMethod = SelectFieldBloc(
    initialValue: 'QR',
    items: ['QR', 'FPX'],
    validators: [
      InputValidator.required,
    ],
  );

  ReloadFormBloc({
    required this.model,
    required this.details,
  }) {
    addFieldBlocs(
      fieldBlocs: [
        other,
        token,
        amount,
        paymentMethod,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    emitSuccess();
  }
}
