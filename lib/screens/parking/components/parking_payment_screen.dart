import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ntp/ntp.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/custom_dialog.dart';
import 'package:project/widget/primary_button.dart';

class ParkingPaymentScreen extends StatefulWidget {
  const ParkingPaymentScreen({
    super.key,
  });

  @override
  State<ParkingPaymentScreen> createState() => _ParkingPaymentScreenState();
}

class _ParkingPaymentScreenState extends State<ParkingPaymentScreen> {
  //final double _value = 40.0;
  String _currentDate = '';
  String _currentTime = '';
  bool isCountdownActive = false;
  String? currentDuration;
  String? expiredDuration;
  ParkingPlaceModel? parkingPlaceModel;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => updateDateTime());
  }

  void updateDateTime() async {
    try {
      DateTime liveTime = await NTP.now(timeout: const Duration(seconds: 5));
      setState(() {
        _currentDate = liveTime.toString().split(' ')[0]; // Get current date
        _currentTime = DateFormat('h:mm a').format(liveTime);
      });
    } catch (e) {
      // Fallback to local time in case of an error
      DateTime fallbackTime = DateTime.now();
      _currentDate = fallbackTime.toString().split(' ')[0]; // Get current date
      _currentTime = DateFormat('h:mm a').format(fallbackTime);
    }
  }

  Future<void> analyzeParkingExpired(StoreParkingFormBloc formBloc) async {
    final List<ParkingPlaceModel> parkingPlaces =
        await SharedPreferencesHelper.getAllParkingPlaces();

    // Find the matching parking place based on location (or state/area/pbt)
    final matchingPlace = parkingPlaces.firstWhere(
      (place) =>
          place.pbt == formBloc.pbt.value &&
          place.state == formBloc.offenceLocation.value?.description &&
          place.area == formBloc.offenceAreas.value?.description &&
          place.location == formBloc.stateCountry.value &&
          place.plateNumber == formBloc.carPlateNumber.value,
      orElse: () => ParkingPlaceModel(
          duration: '0m',
          pbt: '',
          state: '',
          area: '',
          location: '',
          plateNumber: ''),
    );

    currentDuration = matchingPlace.duration;
    expiredDuration = matchingPlace.expiredAt != null
        ? DateFormat('hh:mm:ss a').format(matchingPlace.expiredAt!)
        : '';
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    String? parkingCar = arguments['selectedCarPlate'] as String?;
    String? duration = arguments['duration'] as String?;
    double amount = double.parse(arguments['amount']);
    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    StoreParkingFormBloc? formBloc =
        arguments['formBloc'] as StoreParkingFormBloc;

    analyzeParkingExpired(formBloc);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: details['color'] == 4294961979 ? kBlack : kWhite,
        backgroundColor: Color(details['color']),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.payment,
          style: textStyleNormal(
            fontSize: 26,
            color: details['color'] == 4294961979 ? kBlack : kWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.date,
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      _currentDate,
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.time,
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      _currentTime,
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "PBT",
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      formBloc.pbt.value!,
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (formBloc.offenceAreas.value != null)
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.areas,
                          style:
                              GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          child: Text(
                            formBloc.offenceAreas.value!.description!,
                            style: GoogleFonts.firaCode(),
                            textAlign:
                                TextAlign.right, // Align text to the right
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              if (formBloc.offenceLocation.value != null)
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.state,
                          style:
                              GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          child: Text(
                            formBloc.offenceLocation.value!.description!,
                            style: GoogleFonts.firaCode(),
                            textAlign:
                                TextAlign.right, // Align text to the right
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.plateNumber,
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      parkingCar!.split('-')[0],
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.duration,
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      duration!,
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.description,
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.parking,
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.total,
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      'RM ${amount.toStringAsFixed(2)}',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.paymentDesc,
                  style: GoogleFonts.firaCode(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 100),
              Center(
                child: PrimaryButton(
                  onPressed: () async {
                    // Get current date and time
                    DateTime now = await NTP.now();

                    setState(() {
                      CustomDialog.show(
                        context,
                        dialogType: DialogType.danger,
                        title: AppLocalizations.of(context)!.confirmPayment,
                        description:
                            AppLocalizations.of(context)!.confirmPaymentDesc,
                        btnOkOnPress: () async {
                          formBloc.amount
                              .updateValue(amount.toStringAsFixed(2));
                          final receiptNo = generateReceiptNumber();

                          final location = formBloc.pbt.value;

                          DateTime newTime;
                          if (expiredDuration != '') {
                            newTime = now
                                .add(parseDuration(duration))
                                .add(parseDuration(currentDuration!));
                          } else {
                            newTime = now.add(parseDuration(duration));
                          }

                          final startTimeFormatted = expiredDuration != ''
                              ? DateFormat('hh:mm:ss a').format(
                                  now.add(parseDuration(currentDuration!)))
                              : _currentTime;

                          final endTimeFormatted =
                              DateFormat('hh:mm:ss a').format(newTime);
                          final formattedTimestamp =
                              newTime.toUtc().toIso8601String();

                          final plate = parkingCar.split('-')[0];
                          final type = AppLocalizations.of(context)!.parking;
                          final area = formBloc.offenceAreas.value?.description;
                          final state =
                              formBloc.offenceLocation.value?.description;

                          await SharedPreferencesHelper.setReceipt(
                            noReceipt: receiptNo,
                            startTime: startTimeFormatted,
                            endTime: endTimeFormatted,
                            duration: duration,
                            location: location,
                            plateNumber: plate,
                            type: type,
                            area: area,
                            state: state,
                          );

                          formBloc.noReceipt.updateValue(receiptNo);
                          formBloc.expiredAt.updateValue(formattedTimestamp);

                          // Create model
                          parkingPlaceModel = ParkingPlaceModel(
                            duration: duration,
                            pbt: location!,
                            state: state,
                            area: area,
                            location: formBloc.stateCountry.value!,
                            plateNumber: parkingCar,
                            expiredAt: DateTime.tryParse(formattedTimestamp),
                          );

                          // ✅ Clean handling using upsert method
                          await SharedPreferencesHelper.upsertParkingPlace(
                              parkingPlaceModel!);

                          formBloc.submit();
                        },
                        btnOkText: AppLocalizations.of(context)!.yes,
                        btnCancelOnPress: () {
                          Navigator.pop(context);
                        },
                        btnCancelText: AppLocalizations.of(context)!.no,
                      );
                    });
                  },
                  label: Text(
                    AppLocalizations.of(context)!.pay,
                    style: textStyleNormal(
                        color: kWhite, fontWeight: FontWeight.bold),
                  ),
                  color: kPrimaryColor,
                  borderRadius: 10.0,
                  buttonWidth: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
