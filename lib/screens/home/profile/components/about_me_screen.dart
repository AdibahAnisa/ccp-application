import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/primary_button.dart';

Future<void> displayAboutMe(BuildContext context, UserModel userModel) {
  Widget buildRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          label,
          style: textStyleNormal(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: textStyleNormal(fontSize: 15),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    isScrollControlled:
        true, // Makes the bottom sheet take full height if needed
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Divider(color: kGrey, thickness: 3),
                  ),
                  Text(
                    AppLocalizations.of(context)!.aboutMe,
                    style: textStyleNormal(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kBlack,
                    ),
                  ),
                  buildRow(
                      AppLocalizations.of(context)!.name, userModel.firstName),
                  if (userModel.idNumber?.isNotEmpty ?? false)
                    buildRow(AppLocalizations.of(context)!.idNumber,
                        userModel.idNumber),
                  buildRow(AppLocalizations.of(context)!.phoneNumber,
                      userModel.phoneNumber),
                  buildRow(
                      AppLocalizations.of(context)!.email, userModel.email),
                  buildRow(
                    AppLocalizations.of(context)!.address,
                    "${userModel.address1 ?? ''} ${userModel.address2 ?? ''} ${userModel.address3 ?? ''}"
                        .trim(),
                  ),
                  if (userModel.postcode != null ||
                      userModel.city != null ||
                      userModel.state != null)
                    buildRow(
                      '',
                      "${userModel.postcode ?? ''} ${userModel.city ?? ''} ${userModel.state ?? ''}"
                          .trim(),
                    ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    color: kRed,
                    label: Text(
                      AppLocalizations.of(context)!.close,
                      style: textStyleNormal(
                          color: kWhite, fontWeight: FontWeight.bold),
                    ),
                    borderRadius: 20.0,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
