import 'package:flutter/material.dart';
import 'package:project/models/models.dart';
import 'package:project/widget/primary_button.dart';
import 'package:project/constant.dart';
import 'package:project/src/localization/app_localizations.dart';

class TermsAndConditionScreen extends StatelessWidget {
  final bool isFromSignup;

  const TermsAndConditionScreen({
    super.key,
    this.isFromSignup = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.termAndConditions,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.definitions_title,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.definitions_intro,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.account_label,
                AppLocalizations.of(context)!.account_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.activation_label,
                AppLocalizations.of(context)!.activation_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.agreement_label,
                AppLocalizations.of(context)!.agreement_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.compound_label,
                AppLocalizations.of(context)!.compound_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.customer_label,
                AppLocalizations.of(context)!.customer_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.device_label,
                AppLocalizations.of(context)!.device_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.ccp_label,
                AppLocalizations.of(context)!.ccp_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.ccp_system_label,
                AppLocalizations.of(context)!.ccp_system_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.financier_label,
                AppLocalizations.of(context)!.financier_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.information_label,
                AppLocalizations.of(context)!.information_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.mobile_telephone_label,
                AppLocalizations.of(context)!.mobile_telephone_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.monthly_passes_label,
                AppLocalizations.of(context)!.monthly_passes_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.parking_charges_label,
                AppLocalizations.of(context)!.parking_charges_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.token_label,
                AppLocalizations.of(context)!.token_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.user_label,
                AppLocalizations.of(context)!.user_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.service_label,
                AppLocalizations.of(context)!.service_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.taxes_label,
                AppLocalizations.of(context)!.taxes_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.value_added_services_label,
                AppLocalizations.of(context)!.value_added_services_desc,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.period_agreement_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.period_agreement_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.account_security_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.account_security_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.account_register_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.account_register_1,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.account_register_2,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.additional_provisions_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.additional_provisions_1),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.additional_provisions_2),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.additional_provisions_3),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.additional_provisions_4),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.additional_provisions_5),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.customer_responsibilities_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.customer_shall,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.customer_responsibilities_1),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.customer_responsibilities_2),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.customer_responsibilities_3),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.customer_responsibilities_4),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.customer_responsibilities_5),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.customer_responsibilities_6),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.ccp_rights_liabilities_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.ccp_rights_liabilities_1,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.ccp_rights_liabilities_1a),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.ccp_rights_liabilities_1b),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.ccp_rights_liabilities_1c),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.ccp_rights_liabilities_1d),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.ccp_rights_liabilities_2,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.ccp_rights_liabilities_2a),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.ccp_rights_liabilities_2b),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.ccp_rights_liabilities_2c),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.ccp_rights_liabilities_3,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.force_majeure_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.force_majeure_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.waiver_misc_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.waiver_misc_1),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.waiver_misc_2),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.waiver_misc_3),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.waiver_misc_4),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.waiver_misc_5),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.waiver_misc_6),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.data_protection_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.data_protection_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.disclaimer_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.disclaimer_1),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.disclaimer_2),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.disclaimer_3),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.disclaimer_4),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.disclaimer_5),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildBullet(String title, String description) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "• ",
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "$title ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: description),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildBullet2(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "• ",
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ),
      ],
    ),
  );
}
