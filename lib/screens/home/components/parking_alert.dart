import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/controllers/active_parking_controller.dart';
import 'package:project/models/models.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/src/localization/app_localizations.dart';

class ParkingAlertDialog extends StatefulWidget {
  final String plateNumber;
  final UserModel? userModel;
  final Map<String, dynamic>? details;

  const ParkingAlertDialog({
    super.key,
    required this.plateNumber,
    this.userModel,
    this.details,
  });

  @override
  State<ParkingAlertDialog> createState() => _ParkingAlertDialogState();
}

class _ParkingAlertDialogState extends State<ParkingAlertDialog> {
  double hours = 1;
  double pricePerHour = 0.65;

  int remainingSeconds = 120;
  Timer? timer;
  bool isLoading = false;

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
        if (mounted) {
          setState(() {
            remainingSeconds--;
          });
        }
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
    final min = remainingSeconds ~/ 60;
    final sec = remainingSeconds % 60;
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
            Text(
              AppLocalizations.of(context)!.parkingAutoDeductTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
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
                    AppLocalizations.of(context)!.hoursValue(hours.toInt()),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(34, 74, 151, 1),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(AppLocalizations.of(context)!.amountLabel),
                  Text(
                    "RM ${totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(34, 74, 151, 1),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: hours,
                    min: 1,
                    max: 6,
                    divisions: 5,
                    label: "${hours.toInt()} Hour",
                    onChanged: isExpired || isLoading
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isExpired || isLoading
                        ? null
                        : () async {
                            await confirmParking();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isExpired
                          ? Colors.grey
                          : const Color.fromRGBO(34, 74, 151, 1),
                      foregroundColor: Colors.white,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(AppLocalizations.of(context)!.agree),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => Get.back(),
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

  Future<void> confirmParking() async {
    try {
      setState(() {
        isLoading = true;
      });

      final token = await SharedPreferencesHelper.getToken();
      final state =
          widget.details?["state"] ?? widget.userModel?.state ?? "Pahang";

      final response = await http.post(
        Uri.parse("$baseUrl/parking/confirm"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "plateNumber": widget.plateNumber,
          "hours": hours,
          "state": state,
          "pbt": widget.details?["pbt"] ?? widget.details?["location"] ?? "",
          "location": widget.details?["location"] ?? "",
          "area": widget.details?["area"] ?? widget.details?["location"] ?? "",
        }),
      );

      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("RESPONSE BODY: ${response.body}");

      final data = jsonDecode(response.body);
      final type = data["type"];

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      if (response.statusCode != 200) {
        Get.snackbar(
            "Error", data["message"] ?? "Parking confirmation failed.");
        return;
      }

      if (data["success"] == false) {
        if (type == "NO_WALLET_AND_AUTO_OFF" || type == "AUTO_OFF") {
          Get.toNamed(
            AppRoute.autoDeductScreen,
            arguments: {
              "plateNumber": widget.plateNumber,
              "hours": hours,
              "requiredAmount": data["requiredAmount"] ?? totalPrice,
              "details": widget.details,
              "userModel": widget.userModel,
            },
          );
          return;
        }

        if (type == "NO_WALLET") {
          Get.toNamed(
            AppRoute.reloadScreen,
            arguments: {
              "plateNumber": widget.plateNumber,
              "hours": hours,
              "requiredAmount": data["requiredAmount"] ?? totalPrice,
              "details": widget.details,
              "userModel": widget.userModel,
            },
          );
          return;
        }
      }

      if (data["success"] == true && type == "AUTO_PAID") {
        final activeParkingController = Get.find<ActiveParkingController>();

        activeParkingController.startActiveParking(
          plateNumber: widget.plateNumber,
          parkingStartTime: DateTime.parse(data["startTime"]),
          parkingEndTime: DateTime.parse(data["endTime"]),
        );

        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.blue, size: 50),
                  SizedBox(height: 10),
                  Text(
                    "Auto Deduct Berjaya",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Bayaran parkir telah berjaya ditolak daripada baki token anda.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
        return;
      }

      Get.snackbar("Error", "Parking confirmation failed.");
    } catch (e) {
      debugPrint("❌ Confirm parking error: $e");
      Get.snackbar("Error", "Something went wrong.");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
