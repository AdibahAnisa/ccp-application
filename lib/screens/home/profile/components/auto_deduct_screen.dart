import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/src/localization/app_localizations.dart';

class AutoDeductScreen extends StatefulWidget {
  const AutoDeductScreen({Key? key}) : super(key: key);

  @override
  State<AutoDeductScreen> createState() => _AutoDeductScreenState();
}

class _AutoDeductScreenState extends State<AutoDeductScreen> {
  bool isAutoDeductEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadAutoDeductStatus();
  }

  Future<void> _loadAutoDeductStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isAutoDeductEnabled = prefs.getBool('auto_deduct_enabled') ?? false;
    });
  }

  Future<void> _setAutoDeduct(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_deduct_enabled', value);
    setState(() {
      isAutoDeductEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Auto-Deduct",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: const Text(
                "Auto-Deduct",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              value: isAutoDeductEnabled,
              activeColor: const Color.fromARGB(255, 34, 74, 151),
              onChanged: (value) {
                if (value) {
                  _confirmEnableAutoDeduct();
                } else {
                  _disableAutoDeduct();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.autoDeductDescription,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 85, 85, 85),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    AppLocalizations.of(context)!.howItWorks,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 85, 85),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bulletText(
                          AppLocalizations.of(context)!.howItWorksPoint1),
                      const SizedBox(height: 6),
                      bulletText(
                          AppLocalizations.of(context)!.howItWorksPoint2),
                      const SizedBox(height: 6),
                      bulletText(
                          AppLocalizations.of(context)!.howItWorksPoint3),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    AppLocalizations.of(context)!.keepBalanceTopped,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 85, 85, 85),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmEnableAutoDeduct() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Enable Auto-Deduct",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Auto-deduct will automatically deduct parking fees. You will receive a confirmation notification before each deduction.",
          style: TextStyle(height: 1.5),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cancel Button
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1946AB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Color(0xFF1946AB)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Enable Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _setAutoDeduct(true);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1946AB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Enable",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _disableAutoDeduct() {
    _setAutoDeduct(false);
  }
}

Widget bulletText(String text) {
  return Padding(
    padding: const EdgeInsets.only(left: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "• ",
          style: TextStyle(fontSize: 18, height: 1.2),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color.fromARGB(255, 85, 85, 85),
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );
}
