// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ntp/ntp.dart';
import 'package:project/constant.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/models/offences_rule/offence_data_model.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/primary_button.dart';
import 'package:project/widget/date_picker.dart';
import 'package:table_calendar/table_calendar.dart';

class ParkingBodyScreen extends StatefulWidget {
  final UserModel userModel;
  final List<PlateNumberModel> carPlates;
  final List<PBTModel> pbtModel;
  final Map<String, dynamic> details;

  const ParkingBodyScreen({
    super.key,
    required this.userModel,
    required this.carPlates,
    required this.pbtModel,
    required this.details,
  });

  @override
  State<ParkingBodyScreen> createState() => _ParkingBodyScreenState();
}

class _ParkingBodyScreenState extends State<ParkingBodyScreen> {
  DateTime _focusedDay = DateTime.now();
  String? selectedCarPlate;
  StoreParkingFormBloc? formBloc;
  late String selectedLocation;
  double _selectedHour = 1;
  double totalPrice = 0.0;
  bool hasMatchingLocation = true;
  late Future<OffenceDataModel> _offenceAreasFuture;

  Map<String, List<double>> pricesPerHour = {
    'Pahang': [1, 2, 3, 4, 5, 6, 24],
    'Kelantan': [0.5, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    'Terengganu': [0.5, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  };

  Map<String, Map<double, double>> prices = {
    'Pahang': {1: 0.65, 2: 1.30, 3: 1.95, 4: 2.60, 5: 3.25, 6: 4.55, 24: 4.80},
    'Kelantan': {
      0.5: 0.30,
      1: 0.60,
      2: 1.20,
      3: 1.80,
      4: 2.40,
      5: 3.00,
      6: 3.60,
      7: 4.20,
      8: 4.80,
      9: 5.40,
      10: 6.00
    },
    'Terengganu': {
      0.5: 0.40,
      1: 0.80,
      2: 1.60,
      3: 2.40,
      4: 3.20,
      5: 4.00,
      6: 4.80,
      7: 5.60,
      8: 6.40,
      9: 7.20,
      10: 8.00
    },
  };

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.details['state'];
    getTime();

    // Stub: fetch offence areas list
    _offenceAreasFuture = fetchOffenceAreasList();

    // Initialize selected car plate
    if (widget.carPlates.isNotEmpty) {
      PlateNumberModel mainCarPlate = widget.carPlates.firstWhere(
        (plate) => plate.isMain == true,
        orElse: () => widget.carPlates.first,
      );
      selectedCarPlate = '${mainCarPlate.plateNumber}-${mainCarPlate.id}';
    } else {
      selectedCarPlate = null;
    }
  }

  Future<void> getTime() async {
    _focusedDay = await NTP.now();
  }

  // Stub method to remove undefined error
  Future<OffenceDataModel> fetchOffenceAreasList() async {
    return OffenceDataModel(
      areas: [],
      locations: [],
    );
  }

  double calculatePrice() {
    return prices[selectedLocation]?[_selectedHour] ?? 0.0;
  }

  String _formatDuration(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
  }

  String getDurationLabel(double hours) {
    String hourLabel = Get.locale!.languageCode == 'en'
        ? (hours == 1 ? 'hour' : 'hours')
        : 'jam';
    return '${hours.toInt()} $hourLabel';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _offenceAreasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: LoadingIndicator(
                indicatorType: Indicator.orbit,
                colors: [
                  Color(widget.details['color']),
                  Color(widget.details['color']).withOpacity(0.5),
                  kWhite
                ],
                backgroundColor: kWhite,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading offence areas'));
        }

        // Data is loaded (even if empty)
        final offenceAreas = snapshot.data!;
        List<double> availableHours = pricesPerHour[selectedLocation]!;

        return SingleChildScrollView(
          child: Column(
            children: [
              DatePickerSlider(),
              const SizedBox(height: 5),
              // Placeholder for dropdowns / calendar / form

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Duration',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        _formatDuration((_selectedHour * 3600).toInt()),
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 34, 74, 151),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Amount',
                        style: GoogleFonts.poppins(fontSize: 18),
                      ),
                      Text(
                        'RM ${calculatePrice().toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 34, 74, 151),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Column(children: [
                        Slider(
                          min: 0,
                          max: (availableHours.length - 1).toDouble(),
                          divisions: availableHours.length - 1,
                          value:
                              availableHours.indexOf(_selectedHour).toDouble(),
                          activeColor: const Color.fromARGB(255, 34, 74, 151),
                          onChanged: (value) {
                            setState(() {
                              _selectedHour = availableHours[value.toInt()];
                            });
                          },
                        ),
                        Text(
                          getDurationLabel(_selectedHour),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                borderRadius: 5,
                buttonWidth: 0.95,
                color: kPrimaryColor,
                onPressed: () {
                  // TODO: Navigate to payment or next screen
                },
                label: Text(
                  AppLocalizations.of(context)!.confirm,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                borderRadius: 5,
                buttonWidth: 0.95,
                color: const Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  // TODO: Navigate to payment or next screen
                },
                label: Text(
                  '${AppLocalizations.of(context)!.open} ${AppLocalizations.of(context)!.parking} ${AppLocalizations.of(context)!.receipt}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
