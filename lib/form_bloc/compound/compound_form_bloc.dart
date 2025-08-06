import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';

class CompoundFormBloc extends FormBloc<String, String> {
  final UserModel model;
  final Map<String, dynamic> details;

  final amount = TextFieldBloc(
    validators: [
      InputValidator.amount,
    ],
  );

  final paymentMethod = SelectFieldBloc(
    items: ['QR', 'FPX'],
    validators: [
      InputValidator.required,
    ],
  );

  CompoundFormBloc({
    required this.model,
    required this.details,
  }) {
    addFieldBlocs(
      fieldBlocs: [
        amount,
        paymentMethod,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    emitSuccess();
  }
}
