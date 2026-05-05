import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/routes/route_manager.dart';

class AutoDeductRequiredDialog extends StatelessWidget {
  final String plateNumber;
  final double requiredAmount;

  const AutoDeductRequiredDialog({
    super.key,
    required this.plateNumber,
    required this.requiredAmount,
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
            const Text(
              "Auto-Deduct: Tindakan Diperlukan",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Auto-Deduct anda tidak aktif.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 8),
            const Text(
              "Aktifkan sekarang untuk memastikan bayaran parkir berjalan lancar.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 10),
            const Text(
              "Sila tekan Aktif untuk meneruskan.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();

                      Get.toNamed(
                        AppRoute.autoDeductScreen,
                        arguments: {
                          "plateNumber": plateNumber,
                          "requiredAmount": requiredAmount,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(34, 74, 151, 1),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Aktif"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                      elevation: 0,
                    ),
                    child: const Text("Batal"),
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
