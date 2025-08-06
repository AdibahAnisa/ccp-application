import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    Map<String, dynamic> details = arguments?['locationDetail'] ?? {};

    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          toolbarHeight: 100,
          foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
          backgroundColor: Color(details['color'] ?? 0xFFFFFFFF),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.transactionHistory,
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
