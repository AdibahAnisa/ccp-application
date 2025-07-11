import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ntp/ntp.dart';
import 'package:project/app/helpers/notification_service.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';

class CountdownCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> details;
  final ParkingPlaceModel parking;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  const CountdownCard({
    Key? key,
    required this.index,
    required this.details,
    required this.parking,
    required this.flutterLocalNotificationsPlugin,
  }) : super(key: key);

  @override
  State<CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends State<CountdownCard> {
  Timer? _timer;
  Duration remainingTime = const Duration();
  int updateCounter = 0;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startCountdown() async {
    _timer?.cancel();

    // Initialize Notifications
    await NotificationService().initNotification();

    DateTime now = await NTP.now();
    DateTime expiredAt =
        widget.parking.expiredAt!; // Ensure this is parsed properly

    remainingTime = expiredAt.difference(now);
    if (remainingTime.isNegative) {
      remainingTime = Duration.zero;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      setState(() {
        if (remainingTime > Duration.zero) {
          remainingTime = remainingTime - const Duration(seconds: 1);

          updateCounter++;
          if (updateCounter >= 60) {
            updateCounter = 0;
            SharedPreferencesHelper.updateParkingPlace(widget.parking);
          }

          if (remainingTime.inMinutes <= 5 &&
              remainingTime.inSeconds >= 270 &&
              remainingTime.inSeconds < 300) {
            _showNotification();
          }
        } else {
          _timer?.cancel();
          SharedPreferencesHelper.deleteParkingPlace(
            expiredAt: widget.parking.expiredAt!,
            index: widget.index,
          );
        }
      });
    });
  }

  void _showNotification() async {
    await NotificationService().showNotification(
      title: "Aleart!",
      body: "You have 5 minutes left before your time is up",
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.details['color']; // Default color if not provided

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: double.infinity,
      height: widget.parking.expiredAt!.isAfter(DateTime.now())
          ? MediaQuery.of(context).size.height * 0.1
          : MediaQuery.of(context).size.height * 0.02,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        '${AppLocalizations.of(context)!.plateNumber}: ',
                        style: textStyleNormal(
                          fontSize: 14,
                          color: color == 4294961979 ? kBlack : kWhite,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.parking.plateNumber,
                        style: textStyleNormal(
                          fontSize: 14,
                          color: color == 4294961979 ? kBlack : kWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        '${AppLocalizations.of(context)!.location}: ',
                        style: textStyleNormal(
                          fontSize: 14,
                          color: color == 4294961979 ? kBlack : kWhite,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.parking.area != null &&
                                widget.parking.state != null
                            ? '${widget.parking.area}, ${widget.parking.state}, ${widget.parking.location}'
                            : widget.parking.location,
                        overflow: TextOverflow.ellipsis,
                        style: textStyleNormal(
                          fontSize: 14,
                          color: color == 4294961979 ? kBlack : kWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${AppLocalizations.of(context)!.expiredDate}: ${DateFormat('dd-MM-yyyy HH:mm').format(widget.parking.expiredAt!.add(const Duration(hours: 8)))}',
            style: textStyleNormal(
              fontSize: 16,
              color: color == 4294961979 ? kBlack : kWhite,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${AppLocalizations.of(context)!.parkingTimeRemaining}: ${formatDuration(remainingTime)}',
            style: textStyleNormal(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color == 4294961979 ? kBlack : kWhite,
            ),
          ),
        ],
      ),
    );
  }
}
