import 'package:flutter/material.dart';
import 'package:project/models/models.dart';
import 'package:project/screens/home/profile/components/edit_email_password.dart';
import 'package:project/widget/primary_button.dart';
import 'package:project/constant.dart';
import 'package:project/src/localization/app_localizations.dart';

class EmailPasswordScreen extends StatefulWidget {
  late UserModel userModel;
  EmailPasswordScreen({super.key, required this.userModel});

  @override
  State<EmailPasswordScreen> createState() => _EmailPasswordScreenState();
}

class _EmailPasswordScreenState extends State<EmailPasswordScreen> {
  late UserModel userModel;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
  }

  String displayValue(String? value, {bool mask = false}) {
    if (value == null || value.trim().isEmpty) return '-';
    if (mask) return '*' * value.length;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context, userModel);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.emailPassword,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ProfileInfoRow(
                    label: AppLocalizations.of(context)!.email,
                    value: displayValue(userModel.email),
                  ),
                  ProfileInfoRow(
                    label: AppLocalizations.of(context)!.password,
                    value: '******',
                    isLast: true,
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// EDIT BUTTON
            PrimaryButton(
                borderRadius: 10,
                buttonWidth: 1,
                color: kPrimaryColor,
                label: const Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  final updatedUser = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditEmailPassword(userModel: userModel),
                    ),
                  );

                  if (updatedUser != null) {
                    setState(() {
                      userModel = updatedUser;
                    });
                  }
                }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '$label:',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 12),
        ]
      ],
    );
  }
}
