// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool isDropDownLanguage;

  @override
  void initState() {
    super.initState();
    isDropDownLanguage = false;
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;

    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          toolbarHeight: 100,
          foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
          backgroundColor: Color(details['color'] ?? 0xFFFFFFFF),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.settings,
            style: textStyleNormal(
              fontSize: 26,
              color: details['color'] == 4294961979 ? kBlack : kWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const LoadingDialog());
  }
}
