import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/models/models.dart';
import 'package:project/screens/home/reload/reload_screen.dart';
import 'package:project/src/localization/app_localizations.dart';

class InsufficientBalanceDialog extends StatelessWidget {
  final String plateNumber;
  final double requiredAmount;
  final Map<String, dynamic> details;
  final UserModel userModel;

  const InsufficientBalanceDialog({
    super.key,
    required this.plateNumber,
    required this.requiredAmount,
    required this.details,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.insufficientBalanceTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.insufficientBalanceDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: AppLocalizations.of(context)!.insufficientBalanceAction1,
                style: const TextStyle(fontSize: 13),
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!
                        .insufficientBalanceAction2,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!
                        .insufficientBalanceAction3,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.to(() => ReloadScreen(
                            plateNumber: plateNumber,
                            requiredAmount: requiredAmount,
                            details: details,
                            userModel: userModel,
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(34, 74, 151, 1),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(AppLocalizations.of(context)!
                        .insufficientBalanceAction2),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
