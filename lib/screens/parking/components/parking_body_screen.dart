// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';

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
  List<PlateNumberModel> carPlates = [];
  String? selectedCarPlate;
  StoreParkingFormBloc? formBloc;
  late String selectedLocation;
  double _selectedHour = 1;
  double totalPrice = 0.0;
  bool hasMatchingLocation = true;

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

  final List<String> imgList = [
    kuantanLogo,
    terengganuLogo,
    machangLogo,
  ];

  final List<String> imgName = [
    'PBT Kuantan',
    'PBT Kuala Terengganu',
    'PBT Machang',
  ];

  final List<String> imgState = [
    'Pahang',
    'Terengganu',
    'Kelantan',
  ];

  // Helper method to get the color based on index
  int getColorForIndex(int index) {
    switch (index) {
      case 0:
        return kPrimaryColor.value;
      case 1:
        return kOrange.value;
      case 2:
        return kYellow.value;
      default:
        return Colors.transparent.value; // Default color or handle error
    }
  }

  String getDurationLabel(double hours) {
    if (hours == 1.0) {
      String hour = Get.locale!.languageCode == 'en' ? 'hour' : 'jam';
      return '1 $hour';
    } else {
      String hour = Get.locale!.languageCode == 'en' ? 'hours' : 'jam';
      return '${hours.toInt()} $hour';
    }
  }

  @override
  void initState() {
    selectedLocation = widget.details['state'];
    super.initState();
    getTime();
    // Check if carPlates list is not empty
    try {
      // Check if carPlates list is not empty
      if (widget.carPlates.isNotEmpty) {
        PlateNumberModel mainCarPlate = widget.carPlates.firstWhere(
          (plate) => plate.isMain == true,
          orElse: () => widget.carPlates.first,
        );
        // Set the selectedCarPlate with both plateNumber and id to match the Dropdown value
        selectedCarPlate = '${mainCarPlate.plateNumber}-${mainCarPlate.id}';
      } else {
        // Handle case where no car plates are available
        selectedCarPlate = null;
      }
    } catch (e) {
      e.toString();
    }
  }

  Future<void> getTime() async {}

  double calculatePrice() {
    // Check if selectedLocation is a valid key in pricesPerMonth
    if (pricesPerHour.containsKey(selectedLocation)) {
      // Check if _selectedMonth is a valid key in the selectedLocation
      double? price = prices[selectedLocation]?[_selectedHour];

      // If price is not null, return it, otherwise return a default value
      return price ?? 0.0;
    } else {
      // Handle the case where selectedLocation is not a valid key
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
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
    ));
  }
}
