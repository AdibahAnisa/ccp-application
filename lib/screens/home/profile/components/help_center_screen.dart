import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/screens/home/profile/components/help_center/app_hc.dart';
import 'package:project/screens/home/profile/components/help_center/compound_hc.dart';
import 'package:project/screens/home/profile/components/help_center/monthly_pass_hc.dart';
import 'package:project/screens/home/profile/components/help_center/reserve_bay_hc.dart';
import 'package:project/screens/home/profile/components/help_center/terminal_hc.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';

class HelpCentreScreen extends StatelessWidget {
  final List<PBTModel> pbtModel;

  const HelpCentreScreen({super.key, required this.pbtModel});

  @override
  Widget build(BuildContext context) {
    final items = [
      "Terminal",
      AppLocalizations.of(context)!.compound,
      AppLocalizations.of(context)!.reserveBays,
      AppLocalizations.of(context)!.monthlyPass,
      "App",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.helpCenter),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TerminalHelpScreen(),
                    ),
                  );
                  break;

                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CompoundHelpScreen(),
                    ),
                  );
                  break;

                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReserveBayHelpScreen(),
                    ),
                  );
                  break;

                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MonthlyPassHelpScreen(),
                    ),
                  );
                  break;

                case 4:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppHelpScreen(),
                    ),
                  );
                  break;
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.help_outline, color: kPrimaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      items[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
