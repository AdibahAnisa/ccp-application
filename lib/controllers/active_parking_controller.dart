import 'dart:async';
import 'package:get/get.dart';

class ActiveParkingController extends GetxController {
  var isActive = false.obs;
  var plateNumber = ''.obs;
  var startTime = Rxn<DateTime>();
  var endTime = Rxn<DateTime>();
  var remainingTime = "00:00:00".obs;
  var currentAmount = 0.0.obs;

  Timer? _timer;

  void startActiveParking({
    required String plateNumber,
    required DateTime parkingStartTime,
    required DateTime parkingEndTime,
  }) {
    this.plateNumber.value = plateNumber;
    startTime.value = parkingStartTime;
    endTime.value = parkingEndTime;
    isActive.value = true;

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (endTime.value == null) return;

      final now = DateTime.now();
      final diff = endTime.value!.difference(now);

      if (diff.isNegative) {
        stopParking();
        return;
      }

      remainingTime.value = _formatDuration(diff);

      // OPTIONAL: calculate amount (you can adjust rate later)
      final usedMinutes = now.difference(startTime.value ?? now).inMinutes;

      final ratePerHour = 0.65; // you can pass dynamically later
      currentAmount.value = (usedMinutes / 60) * ratePerHour;
    });
  }

  void stopParking() {
    _timer?.cancel();
    isActive.value = false;
    remainingTime.value = "00:00:00";
    currentAmount.value = 0.0;
    plateNumber.value = '';
    startTime.value = null;
    endTime.value = null;
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
