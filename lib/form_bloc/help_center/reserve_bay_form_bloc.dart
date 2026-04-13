import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/src/localization/app_localizations.dart';

class ReserveBayFormBloc extends FormBloc<String, String> {
  /// Dropdown Issue
  final SelectFieldBloc<String, dynamic> issue =
      SelectFieldBloc<String, dynamic>(
    items: const [
      "Bay occupied by unauthorized vehicle",
      "Reservation not showing in system",
      "Unable to find reserved bay",
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

  ReserveBayFormBloc() {
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
        successResponse: "Terminal issue submitted successfully",
      );
    } catch (e) {
      emitFailure(
        failureResponse: "Submission failed. Please try again.",
      );
    }
  }
}
