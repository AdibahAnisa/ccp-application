import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/validators.dart';

class StoreVehicleFormBloc extends FormBloc<String, String> {
  final plateNumber = TextFieldBloc(validators: [
    InputValidator.required,
  ]);

  StoreVehicleFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        plateNumber,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      emitSuccess(successResponse: 'Plate Number Successfully Added');
    } catch (e) {
      emitFailure(
          failureResponse: 'Failed to add plate number: ${e.toString()}');
    }
  }
}
