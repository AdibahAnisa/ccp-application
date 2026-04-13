import 'package:flutter/material.dart';
import 'package:project/models/models.dart';
import 'package:project/screens/home/profile/components/edit_about_me.dart';
import 'package:project/widget/primary_button.dart';
import 'package:project/constant.dart';
import 'package:project/src/localization/app_localizations.dart';

class AboutMeScreen extends StatefulWidget {
  late UserModel userModel;
  AboutMeScreen({super.key, required this.userModel});

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  UserModel? userModel;
  UserModel get user => userModel!;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
  }

  String displayValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }
    return value;
  }

  String buildAddress(UserModel user) {
    final address = [
      user.address1,
      user.address2,
      user.address3,
      user.postcode,
      user.city,
      user.state,
    ].whereType<String>().where((e) => e.trim().isNotEmpty).join(', ');

    return address.isEmpty ? '-' : address;
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
          AppLocalizations.of(context)!.aboutMe,
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
                    label: AppLocalizations.of(context)!.name,
                    value: '${user.firstName} ${user.secondName}',
                  ),
                  ProfileInfoRow(
                    label: AppLocalizations.of(context)!.idNumber,
                    value: user.idNumber ?? '-',
                  ),
                  ProfileInfoRow(
                    label: AppLocalizations.of(context)!.phoneNumber,
                    value: displayValue(user.phoneNumber),
                  ),
                  ProfileInfoRow(
                    label: AppLocalizations.of(context)!.email,
                    value: displayValue(user.email),
                  ),
                  ProfileInfoRow(
                    label: AppLocalizations.of(context)!.address,
                    value: buildAddress(user),
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
                label: Text(
                  AppLocalizations.of(context)!.edit,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  final updatedUser = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditAboutMe(userModel: user),
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
