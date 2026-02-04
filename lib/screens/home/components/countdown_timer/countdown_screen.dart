import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/models/models.dart';
import 'package:project/screens/home/components/countdown_timer/countdown_card.dart';

class CountdownScreen extends StatefulWidget {
  final Map<String, dynamic> details;
  final DateTime currentTime;

  const CountdownScreen({
    super.key,
    required this.details,
    required this.currentTime,
  });

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  List<ParkingPlaceModel> savedParkings = [];
  final PageController _pageController = PageController();
  List<Timer?> _timers = [];

  Timer? _autoScrollTimer;
  int _currentPage = 0;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    loadSavedParkings();
  }

  @override
  void dispose() {
    for (var timer in _timers) {
      timer?.cancel();
    }
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> loadSavedParkings() async {
    savedParkings = await SharedPreferencesHelper.getAllParkingPlaces();
    setState(() {});
    if (savedParkings.isNotEmpty) {
      startAutoScroll();
    }
  }

  void startAutoScroll() {
    _autoScrollTimer =
        Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients && savedParkings.isNotEmpty) {
        _currentPage++;
        if (_currentPage >= savedParkings.length) {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> initializeNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  @override
  Widget build(BuildContext context) {
    if (savedParkings.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.02,
        decoration: BoxDecoration(
          color: Color(widget.details['color']),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),
        ),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: PageView.builder(
        controller: _pageController,
        itemCount: savedParkings.length,
        itemBuilder: (context, index) {
          return CountdownCard(
            index: index,
            details: widget.details,
            parking: savedParkings[index],
            flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
          );
        },
      ),
    );
  }
}
