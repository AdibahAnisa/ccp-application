import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/localization/app_localizations.dart';

class ParkingAlertDialog extends StatefulWidget {
  final String plateNumber;

  const ParkingAlertDialog({super.key, required this.plateNumber});

  @override
  State<ParkingAlertDialog> createState() => _ParkingAlertDialogState();
}

class _ParkingAlertDialogState extends State<ParkingAlertDialog> {
  double hours = 1;
  double pricePerHour = 0.65;

  int remainingSeconds = 120; // 2 minutes
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds <= 0) {
        t.cancel();
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  double get totalPrice => hours * pricePerHour;

  String get timeText {
    int min = remainingSeconds ~/ 60;
    int sec = remainingSeconds % 60;
    return "$min:${sec.toString().padLeft(2, '0')}";
  }

  bool get isExpired => remainingSeconds <= 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TITLE
            Text(
              AppLocalizations.of(context)!.parkingAutoDeductTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // DESCRIPTION
            Text.rich(
              TextSpan(
                text: AppLocalizations.of(context)!
                    .parkingDescription(widget.plateNumber)
                    .split(widget.plateNumber)[0],
                style: const TextStyle(fontSize: 13, color: Colors.black),
                children: [
                  TextSpan(
                    text: widget.plateNumber,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!
                        .parkingDescription(widget.plateNumber)
                        .split(widget.plateNumber)[1],
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // TIMER
            Text(
              AppLocalizations.of(context)!.validityPeriod(timeText),
              style: TextStyle(
                color: isExpired
                    ? const Color.fromARGB(255, 194, 50, 39)
                    : const Color.fromARGB(255, 56, 167, 60),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // BOX
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(AppLocalizations.of(context)!.durationLabel),
                  const SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.hoursValue(
                      hours.toInt(),
                    ),
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(34, 74, 151, 1)),
                  ),

                  const SizedBox(height: 10),

                  Text(AppLocalizations.of(context)!.amountLabel),
                  Text(
                    "RM ${totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(34, 74, 151, 1)),
                  ),

                  const SizedBox(height: 10),

                  // SLIDER
                  Slider(
                    value: hours,
                    min: 1,
                    max: 6,
                    divisions: 5,
                    label: "${hours.toInt()} Jam",
                    onChanged: isExpired
                        ? null
                        : (value) {
                            setState(() {
                              hours = value;
                            });
                          },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text.rich(
              TextSpan(
                text: AppLocalizations.of(context)!.autoDeductInfo,
                style: const TextStyle(fontSize: 13, color: Colors.black),
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.autoDeductInfoBold,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.autoDeductInfoSuffix,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isExpired
                        ? null
                        : () async {
                            await confirmParking();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isExpired
                          ? Colors.grey
                          : Color.fromRGBO(34, 74, 151, 1),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(AppLocalizations.of(context)!.agree),
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
            )
          ],
        ),
      ),
    );
  }

  // ===============================
  // API CALL
  // ===============================
  Future<void> confirmParking() async {
    print("📡 Sending confirm parking...");
    print("Plate: ${widget.plateNumber}");
    print("Hours: $hours");
    print("Amount: $totalPrice");

    // TODO: CALL YOUR API HERE
    // await ParkingAPI.confirm(...);

    Get.back();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button (top right)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, size: 18),
                ),
              ),

              const SizedBox(height: 10),

              // Icon
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFFE6F0FF),
                child: Icon(Icons.check_circle,
                    color: Color(0xFF0F52BA), size: 32),
              ),

              const SizedBox(height: 16),

              Text(
                AppLocalizations.of(context)!.parking_confirmed,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              Text.rich(
                TextSpan(
                  text: AppLocalizations.of(context)!.parkingPaidMessage,
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.hoursValue(hours),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!
                          .parkingPaidMessage1(widget.plateNumber)
                          .split(widget.plateNumber)[0],
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
