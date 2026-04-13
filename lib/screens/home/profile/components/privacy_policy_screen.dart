import 'package:flutter/material.dart';
import 'package:project/models/models.dart';
import 'package:project/widget/primary_button.dart';
import 'package:project/constant.dart';
import 'package:project/src/localization/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final bool isFromSignup;

  const PrivacyPolicyScreen({
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
          AppLocalizations.of(context)!.privacyPolicy,
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
                AppLocalizations.of(context)!.introduction_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.introduction_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.categories_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.categories_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.identification_label,
                AppLocalizations.of(context)!.identification_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.transaction_label,
                AppLocalizations.of(context)!.transaction_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.digital_label,
                AppLocalizations.of(context)!.digital_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.feedback_label,
                AppLocalizations.of(context)!.feedback_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.marketing_label,
                AppLocalizations.of(context)!.marketing_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.third_party_label,
                AppLocalizations.of(context)!.third_party_desc,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.purposes_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.purposes_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.account_service_label,
                AppLocalizations.of(context)!.account_service_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.service_label,
                AppLocalizations.of(context)!.service_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.regulatory_label,
                AppLocalizations.of(context)!.regulatory_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.communication_label,
                AppLocalizations.of(context)!.communication_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.personalisation_label,
                AppLocalizations.of(context)!.personalisation_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.research_label,
                AppLocalizations.of(context)!.research_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.marketing_outreach_label,
                AppLocalizations.of(context)!.marketing_outreach_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.data_management_label,
                AppLocalizations.of(context)!.data_management_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.legal_disclosure_label,
                AppLocalizations.of(context)!.legal_disclosure_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.general_business_label,
                AppLocalizations.of(context)!.general_business_desc,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.sources_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.sources_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.sources_account),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.sources_events),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.sources_purchase),
              const SizedBox(height: 5),
              buildBullet2(
                  AppLocalizations.of(context)!.sources_communications),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.sources_feedback),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.sources_third_party,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.data_subject_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.data_subject_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.right_access_label,
                AppLocalizations.of(context)!.right_access_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.right_correction_label,
                AppLocalizations.of(context)!.right_correction_right,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.right_restriction_label,
                AppLocalizations.of(context)!.right_restriction_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.right_withdrawal_label,
                AppLocalizations.of(context)!.right_withdrawal_desc,
              ),
              const SizedBox(height: 8),
              buildBullet(
                AppLocalizations.of(context)!.right_deletion_label,
                AppLocalizations.of(context)!.right_deletion_desc,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.data_requests_contact,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.disclosure_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.disclosure_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.disclosure_companies),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.disclosure_advisers),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.disclosure_banks),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.disclosure_successors),
              const SizedBox(height: 5),
              buildBullet2(AppLocalizations.of(context)!.disclosure_government),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.disclosure_confidential,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.data_subjects_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.data_subjects_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.security_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.security_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.retention_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.retention_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.amendments_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.amendments_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.language_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.language_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.external_websites_label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.external_websites_desc,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
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
