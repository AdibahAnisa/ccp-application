import 'dart:async';
import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';

class HelpDeskFormBloc extends FormBloc<String, String> {
  final List<String> item;
  final List<PBTModel> pbtModel;

  final SelectFieldBloc<String, dynamic> section;
  final SelectFieldBloc<String?, dynamic> pbt;
  final TextFieldBloc description = TextFieldBloc(
    validators: [InputValidator.required],
  );

  HelpDeskFormBloc({
    required this.item,
    required this.pbtModel,
  })  : section = SelectFieldBloc<String, dynamic>(
          validators: [InputValidator.required],
          items: item,
        ),
        pbt = SelectFieldBloc<String?, dynamic>(
          validators: [InputValidator.required],
          items: pbtModel.map((pbt) => pbt.id).toList(),
        ) {
    addFieldBlocs(fieldBlocs: [section, pbt, description]);
  }

  @override
  FutureOr<void> onSubmitting() async {
    // Optional delay for UI feedback
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final response = await AuthResources.helpDesk(
        prefix: '/helpdesk/create-helpdesk',
        body: jsonEncode({
          "pbtId": pbt.value,
          "description": "${section.value} - ${description.value}",
        }),
      );

      if (response['error'] != null) {
        emitFailure(failureResponse: response['error'].toString());
      } else {
        emitSuccess(successResponse: "Successfully Sent.");
      }
    } catch (e) {
      emitFailure(failureResponse: "An error occurred: ${e.toString()}");
    }
  }
}
