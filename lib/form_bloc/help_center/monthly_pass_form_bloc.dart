import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class MonthlyPassFormBloc extends FormBloc<String, String> {
  /// Dropdown Issue
  final SelectFieldBloc<String, dynamic> issue =
      SelectFieldBloc<String, dynamic>(
    items: const [
      "Pass not recognized",
      "Billing issues",
      "Unable to renew pass",
      "Others",
    ],
    validators: [
      FieldBlocValidators.required,
    ],
  );

  /// Description Field
  final TextFieldBloc description = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  MonthlyPassFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        issue,
        description,
      ],
    );
  }

  @override
  Future<void> onSubmitting() async {
    try {
      final selectedIssue = issue.value;
      final desc = description.value;

      /// Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      /// TODO: Replace with real API call
      print("Issue: $selectedIssue");
      print("Description: $desc");

      emitSuccess(
        successResponse: "Monthly pass issue submitted successfully",
      );
    } catch (e) {
      emitFailure(
        failureResponse: "Submission failed. Please try again.",
      );
    }
  }
}
