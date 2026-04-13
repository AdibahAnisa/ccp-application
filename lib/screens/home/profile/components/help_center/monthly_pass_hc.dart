import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/help_center/monthly_pass_form_bloc.dart';
import 'package:project/src/localization/app_localizations.dart';

class MonthlyPassHelpScreen extends StatelessWidget {
  const MonthlyPassHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MonthlyPassFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<MonthlyPassFormBloc>();

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              title: Text(AppLocalizations.of(context)!.monthlyPass),
            ),
            body: FormBlocListener<MonthlyPassFormBloc, String, String>(
              onSubmitting: (context, state) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
              },
              onSuccess: (context, state) {
                Navigator.pop(context); // close loading

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.successResponse!)),
                );

                Navigator.pop(context); // go back
              },
              onFailure: (context, state) {
                Navigator.pop(context); // close loading

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.failureResponse!)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.commonIssues,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// Dropdown Issue
                    DropdownFieldBlocBuilder<String>(
                      selectFieldBloc: formBloc.issue,
                      showEmptyItem: true,
                      decoration: InputDecoration(
                        hintText: 'Please select an issue',
                        hintStyle:
                            TextStyle(color: Colors.grey[600], fontSize: 14),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      itemBuilder: (context, value) =>
                          FieldItem(child: Text(value)),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      AppLocalizations.of(context)!.typeYourMessage,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// Description
                    TextFieldBlocBuilder(
                      textFieldBloc: formBloc.description,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.describeIssue,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const Spacer(),

                    /// Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: formBloc.submit,
                        child: Text(
                          AppLocalizations.of(context)!.submit,
                          style: const TextStyle(fontSize: 16, color: kWhite),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
