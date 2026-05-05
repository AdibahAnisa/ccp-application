// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/app/helpers/avatar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/screens/screens.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/custom_dialog.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:project/controllers/active_parking_controller.dart';
import 'package:project/services/fcm_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final UserModel userModel;
  late Timer _timer;
  Duration remainingDuration = const Duration();
  String lastUpdated = '';
  String? detectedPlate;
  bool isScanning = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late Future<void> _initData;
  late Map<String, dynamic> details;
  File? avatarFile;

  Location locationController = Location();
  late final List<PromotionMonthlyPassModel> promotionMonthlyPassModel;
  List<NotificationModel> notificationList = [];

  DateTime currentTime = DateTime.now();
  DateTime? parkingStartTime;
  DateTime? startTime;
  DateTime? endTime;
  String zone = "Detecting...";

  Timer? _parkingTimer;
  double currentAmount = 0.0;
  Duration parkedDuration = Duration.zero;

  double calculateCurrentAmount() {
    if (startTime == null) return 0.0;

    final usedMinutes = DateTime.now().difference(startTime!).inMinutes;
    final ratePerHour = getHourlyRateByState(details['state']);

    return (usedMinutes / 60) * ratePerHour;
  }

  final ActiveParkingController controller = Get.put(ActiveParkingController());

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  String detectZone(double lat, double lng) {
    if (lat > 3.13 && lat < 3.15) {
      return "Zone A";
    } else {
      return "Zone B";
    }
  }

  double getHourlyRateByState(String? state) {
    if (state == null) return 0.0;

    final Map<String, Map<double, double>> prices = {
      'Pahang': {
        1: 0.65,
        2: 1.30,
        3: 1.95,
        4: 2.60,
        5: 3.25,
        6: 4.55,
        24: 4.80
      },
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

    final statePrices = prices[state];
    if (statePrices == null) return 0.0;

    // Prefer 1 hour, fallback to smallest duration
    if (statePrices.containsKey(1)) {
      return statePrices[1]!;
    }

    final minHour = statePrices.keys.reduce((a, b) => a < b ? a : b);
    return statePrices[minHour]!;
  }

  @override
  void initState() {
    super.initState();

    userModel = UserModel();
    promotionMonthlyPassModel =
        List<PromotionMonthlyPassModel>.empty(growable: true);

    _initData = _initApp();

    _initData.then((_) {
      FCMService(
        getUserModel: () async => userModel,
        getDetails: () async => details,
      ).init();
    });

    _getPromotionMonthlyPass();
    _getPegeypayToken();
    _getNotification();

    analyzeLocation();
    getLocation();
    getCurrentTime();
    _loadAvatar();

    loadParkingSession();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      updateTimer();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void updateTimer() {
    if (endTime == null) return;

    final now = DateTime.now();

    final diff = endTime!.difference(now);

    setState(() {
      remainingDuration = diff.isNegative ? Duration.zero : diff;
    });

    if (remainingDuration == Duration.zero && endTime != null) {
      clearParkingSession();
    }
  }

  Future<void> _initApp() async {
    await analyzeLocation();
    await _getUserDetails();
  }

  Future<String?> _getAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_avatar');
  }

  Future<void> _loadAvatar() async {
    final file = await AvatarHelper.getAvatarFile();

    if (file != null && mounted) {
      setState(() {
        avatarFile = file;
      });
    }
  }

  Future<void> clearParkingSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('startTime');
    await prefs.remove('endTime');
    await prefs.remove('zone');

    setState(() {
      startTime = null;
      endTime = null;
      zone = "No Active Parking";
      remainingDuration = Duration.zero;
    });
  }

  Future<File?> capturePlateImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (pickedFile == null) return null;

    return File(pickedFile.path);
  }

  Future<String?> detectPlate(String imagePath) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://lpr.vista-summerose.com:5002/api/plates'),
      );

      request.headers['Authorization'] = 'Token YOUR_API_KEY';

      request.files.add(
        await http.MultipartFile.fromPath('upload', imagePath),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        final data = json.decode(resBody);

        if (data['results'] != null && data['results'].isNotEmpty) {
          return data['results'][0]['plate'];
        }
      } else {
        print("LPR API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("LPR ERROR: $e");
    }

    return null;
  }

  Future<void> saveParkingSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('startTime', startTime!.toIso8601String());
    await prefs.setString('endTime', endTime!.toIso8601String());
    await prefs.setString('zone', zone);
  }

  Future<void> loadParkingSession() async {
    final prefs = await SharedPreferences.getInstance();

    final start = prefs.getString('startTime');
    final end = prefs.getString('endTime');

    if (start != null && end != null) {
      setState(() {
        startTime = DateTime.parse(start);
        endTime = DateTime.parse(end);
        zone = prefs.getString('zone') ?? "Unknown";
      });

      startTimer(); // resume timer
    }
  }

  Future<void> getCurrentTime() async {
    try {
      currentTime = await NTP.now(
        lookUpAddress: 'https://mst.sirim.my/',
        timeout: const Duration(seconds: 5),
      );
    } catch (e) {
      currentTime = DateTime.now();
    }
  }

  Future<void> getLocation() async {
    PermissionStatus permissionGranted =
        await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      await CustomDialog.show(
        context,
        icon: Icons.location_on,
        dialogType: 2,
        description: 'This app needs access to your location to function.',
        btnOkText: AppLocalizations.of(context)!.yes,
        btnOkOnPress: () async {
          permissionGranted = await locationController.requestPermission();
          await permission.Permission.notification.request();
          if (permissionGranted == PermissionStatus.granted)
            Navigator.pop(context);
        },
        btnCancelText: AppLocalizations.of(context)!.no,
        btnCancelOnPress: () => Navigator.pop(context),
      );
    }
  }

  Future<void> analyzeLocation() async {
    details = await SharedPreferencesHelper.getLocationDetails();
  }

  Future<void> _getUserDetails() async {
    final data =
        await ProfileResources.getProfile(prefix: '/auth/user-profile');
    if (data != null && mounted) {
      final user = data['user'];
      DateTime liveTime = await NTP.now();
      setState(() {
        userModel.id = user['id'];
        userModel.firstName = user['firstName'];
        userModel.secondName = user['secondName'];
        userModel.email = user['email'];
        userModel.phoneNumber = user['phoneNumber'];
        userModel.address1 = user['address1'];
        userModel.address2 = user['address2'];
        userModel.address3 = user['address3'];
        userModel.city = user['city'];
        userModel.state = user['state'];
        userModel.postcode = user['postcode'];
        if (user['wallet'] != null) {
          userModel.wallet = WalletModel.fromJson(user['wallet']);
        }
        if (user['plateNumber'] != null) {
          userModel.plateNumbers = (user['plateNumber'] as List)
              .map((e) => PlateNumberModel.fromJson(e))
              .toList();
        }

        lastUpdated = DateFormat('d MMMM y HH:mm').format(liveTime);
      });
    }
  }

  void startTimer() {
    _timer.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      updateTimer();
    });
  }

  Future<void> startParkingSession(int hours) async {
    final now = DateTime.now();

    startTime = now;
    endTime = now.add(Duration(hours: hours));

    final locationData = await locationController.getLocation();

    zone = detectZone(
      locationData.latitude!,
      locationData.longitude!,
    );

    await saveParkingSession();

    startTimer();
    setState(() {});
  }

  Future<void> startParking() async {
    parkingStartTime = await NTP.now();
    startParkingTimer();
  }

  void startParkingTimer() {
    _parkingTimer?.cancel();

    if (parkingStartTime == null) return;

    _parkingTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        final now = DateTime.now();

        parkedDuration = now.difference(parkingStartTime!);

        final hours = parkedDuration.inMinutes / 60;
        final rate = getHourlyRateByState(details['state'] as String?);

        setState(() {
          currentAmount = hours * rate;
        });
      },
    );
  }

  Future<void> _getPromotionMonthlyPass() async {
    final data = await PromotionsResources.getPromotionMonthlyPass(
        prefix: '/promotion/public');
    if (data != null && mounted) {
      setState(() {
        promotionMonthlyPassModel.clear();
        promotionMonthlyPassModel.addAll(data
            .map<PromotionMonthlyPassModel>(
                (item) => PromotionMonthlyPassModel.fromJson(item))
            .toList());
      });
    }
  }

  Future<void> _getPegeypayToken() async {
    final response =
        await PegeypayResources.getToken(prefix: '/payment/public/token');
    if (response != null && mounted && response['status'] == 200) {
      await SharedPreferencesHelper.setPegeypayToken(
          token: response['accessToken']);
    }
  }

  Future<void> scheduleNotification() async {
    // For now just print (we can upgrade later)
    print("Parking will end at $endTime");
  }

  Future<void> _getNotification() async {
    final data = await NotificationsResources.getNotifications(
        prefix: '/notification/public');
    if (data != null && mounted && data is List) {
      setState(() {
        notificationList =
            data.map((item) => NotificationModel.fromJson(item)).toList();
      });
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyToken);
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoute.loginScreen, (context) => false);
  }

  @override
  Widget build(BuildContext context) {
    final double walletAmount =
        double.tryParse(userModel.wallet?.walletAmount ?? '0') ?? 0.0;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: FutureBuilder<void>(
        future: _initData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: LoadingDialog());
          }

          final mainColor = Color(details['color'] ?? 0xFF0055D4);
          final isWhiteHeader = details['color'] == 4294961979;

          return Scaffold(
            backgroundColor: Colors.white,
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _getUserDetails,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // --- HEADER SECTION ---
                        Container(
                          padding: const EdgeInsets.fromLTRB(25, 70, 25, 130),
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ScaleTap(
                                    onPressed: () async {
                                      await Navigator.pushNamed(
                                        context,
                                        AppRoute.profileScreen,
                                        arguments: {
                                          'userModel': userModel,
                                          'locationDetail': details,
                                        },
                                      );

                                      await _getUserDetails();
                                      await _loadAvatar();
                                    },
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: avatarFile != null
                                          ? FileImage(avatarFile!)
                                          : const AssetImage(
                                                  'assets/images/account.png')
                                              as ImageProvider,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          AppLocalizations.of(context)!.welcome,
                                          style: TextStyle(
                                              color: isWhiteHeader
                                                  ? Colors.black54
                                                  : Colors.white70)),
                                      Text(
                                          "${userModel.firstName ?? ''} ${userModel.secondName ?? ''}",
                                          style: TextStyle(
                                              color: isWhiteHeader
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoute.notificationScreen,
                                          arguments: {
                                            'locationDetail': details,
                                            'notificationList':
                                                notificationList,
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.notifications_none,
                                          color: isWhiteHeader
                                              ? Colors.black
                                              : Colors.white)),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            AppLocalizations.of(context)!
                                                .tokenBalance,
                                            style: TextStyle(
                                                color: isWhiteHeader
                                                    ? Colors.black54
                                                    : Colors.white70)),
                                        Row(
                                          children: [
                                            Text(
                                              walletAmount.toStringAsFixed(2),
                                              style: textStyleNormal(
                                                color: details['color'] ==
                                                        4294961979
                                                    ? kBlack
                                                    : kWhite,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 34,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            ScaleTap(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  AppRoute.reloadScreen,
                                                  arguments: {
                                                    'details': details,
                                                    'userModel': userModel,
                                                  },
                                                );
                                              },
                                              child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor:
                                                    details['color'] ==
                                                            4294961979
                                                        ? kBlack
                                                        : kWhite,
                                                child: Icon(Icons.add,
                                                    color: Color(
                                                        details['color'])),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          Get.locale!.languageCode == 'ms'
                                              ? '${AppLocalizations.of(context)!.updatedOn}\n$lastUpdated'
                                              : '${AppLocalizations.of(context)!.updatedOn} $lastUpdated',
                                          style: textStyleNormal(
                                            color:
                                                details['color'] == 4294961979
                                                    ? kBlack
                                                    : kWhite,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ScaleTap(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoute.stateScreen,
                                              arguments: {
                                                'locationDetail': details
                                              },
                                            );
                                          },
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            clipBehavior: Clip.none,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: kWhite,
                                                radius: 30,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Image.asset(
                                                      details['logo']),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: 90,
                                          child: Text(
                                            details['location'],
                                            style: textStyleNormal(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color:
                                                  details['color'] == 4294961979
                                                      ? kBlack
                                                      : kWhite,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // --- POSITIONED OVERLAPPING CARD ---
                        Positioned(
                            bottom: -65,
                            left: 0,
                            right: 0,
                            child: _buildActiveParkingCard()),
                      ],
                    ),
                    const SizedBox(height: 80),
                    ServiceScreen(
                      details: details,
                      userModel: userModel,
                      plateNumbers: userModel.plateNumbers,
                    ),
                    const SizedBox(height: 35),
                    const SliderScreen(),
                    const SizedBox(height: 25),
                    NewsUpdateScreen(
                        promotionMonthlyPassModel: promotionMonthlyPassModel),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveParkingCard() {
    final controller = Get.find<ActiveParkingController>();

    final bool hasPlates =
        userModel.plateNumbers != null && userModel.plateNumbers!.isNotEmpty;

    final String defaultPlate =
        hasPlates ? userModel.plateNumbers!.first.plateNumber! : "ABC 1234";

    final double rate = getHourlyRateByState(details['state']);

    return Obx(() {
      final DateTime? startTime = controller.startTime.value;
      final DateTime? endTime = controller.endTime.value;

      final bool isActive = startTime != null &&
          endTime != null &&
          endTime.isAfter(DateTime.now());
      final String activePlate = controller.plateNumber.value.isNotEmpty
          ? controller.plateNumber.value
          : defaultPlate;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue[50],
                        child: const Icon(
                          Icons.directions_car,
                          color: Color(0xFF0F52BA),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isActive ? "Parkir Aktif" : "No Active Parking",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              isActive
                                  ? (details['location'] ?? "Parking Area")
                                  : "No Active Parking",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      child: Text(
                        isActive ? controller.remainingTime.value : "00:00:00",
                        style: const TextStyle(
                          color: Color(0xFF0F52BA),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      isActive && endTime != null
                          ? "Tamat : ${DateFormat('hh:mm a').format(endTime)}"
                          : "No session",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Text(
                  "Nombor Plat : ",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 3),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    activePlate,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Kadar: RM ${rate.toStringAsFixed(2)}/jam",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isActive
                        ? "Semasa: RM ${controller.currentAmount.value.toStringAsFixed(2)}"
                        : "Semasa: RM 0.00",
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
