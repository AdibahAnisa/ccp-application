import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/screens/screens.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';

class TransportInfoScreen extends StatefulWidget {
  const TransportInfoScreen({super.key});

  @override
  State<TransportInfoScreen> createState() => _TransportInfoScreenState();
}

class _TransportInfoScreenState extends State<TransportInfoScreen> {
  late bool showMeter;

  @override
  void initState() {
    super.initState();
    showMeter = true;
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: showMeter ? Color(details['color']) : kWhite,
        onPressed: () {
          setState(() {
            showMeter = !showMeter; // Toggle showMeter
          });
        },
        child: Image.asset(
          METER_ICON,
          height: 45,
        ),
      ),
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.transportInfo,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: TransportInfoBody(
        details: details,
        showMeter: showMeter, // Pass the updated showMeter value here
      ),
    );
  }
}
