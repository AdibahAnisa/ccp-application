import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/src/localization/app_localizations.dart';

class DatePickerSlider extends StatefulWidget {
  @override
  _DatePickerSliderState createState() => _DatePickerSliderState();
}

class _DatePickerSliderState extends State<DatePickerSlider> {
  DateTime today = DateTime.now();
  int selectedIndex = 0;
  late List<DateTime> availableDates;

  @override
  void initState() {
    super.initState();
    // Generate 14 days from today
    availableDates = List.generate(14, (index) {
      return today.add(Duration(days: index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: availableDates.length,
            itemBuilder: (context, index) {
              DateTime date = availableDates[index];
              bool isPast = date.isBefore(today);
              bool isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: isPast
                    ? null
                    : () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                child: Container(
                  width: 60,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color.fromARGB(255, 34, 74, 151)
                        : isPast
                            ? Colors.grey.shade300
                            : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.blueAccent : Colors.grey,
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(date),
                        style: TextStyle(
                          color: isPast
                              ? Colors.grey
                              : isSelected
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        DateFormat('d').format(date),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: isPast
                              ? Colors.grey
                              : isSelected
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Text(
          '${AppLocalizations.of(context)!.selectedDate} ${DateFormat('EEE, d MMM').format(availableDates[selectedIndex])}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
