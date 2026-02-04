// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ntp/ntp.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/models/offences_rule/offence_data_model.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/primary_button.dart';
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
                backgroundColor: kBackgroundColor,
                pathBackgroundColor: kBackgroundColor,
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
              const SizedBox(height: 20),
              // Placeholder for dropdowns / calendar / form
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Duration: ${_formatDuration((_selectedHour * 3600).toInt())}',
                      style: GoogleFonts.secularOne(fontSize: 20),
                    ),
                    Slider(
                      min: 0,
                      max: (availableHours.length - 1).toDouble(),
                      divisions: availableHours.length - 1,
                      value: availableHours.indexOf(_selectedHour).toDouble(),
                      onChanged: (value) {
                        setState(() {
                          _selectedHour = availableHours[value.toInt()];
                        });
                      },
                      label: getDurationLabel(_selectedHour),
                    ),
                    Text(
                      'Amount: RM ${calculatePrice().toStringAsFixed(2)}',
                      style: GoogleFonts.secularOne(fontSize: 20),
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                onPressed: () {
                  // TODO: Navigate to payment or next screen
                },
                label: const Text('Confirm'),
              ),
            ],
          ),
        );
      },
    );
  }
}
