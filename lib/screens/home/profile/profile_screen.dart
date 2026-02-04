// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/screens/home/profile/components/email_password_screen.dart';
import 'package:project/screens/home/profile/components/help_center_screen.dart';
import 'package:project/screens/home/profile/components/vehicle_list_screen.dart';
import 'package:project/screens/home/profile/components/auto_deduct_screen.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/custom_dialog.dart';
import 'package:project/widget/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:project/screens/home/profile/components/about_me_screen.dart';

//import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  final String fullName;
  final String avatar;
  final UserModel? userModel;
  final Map<String, dynamic>? locationDetail;
  const ProfileScreen({
    super.key,
    this.userModel,
    this.locationDetail,
    this.fullName = 'User',
    this.avatar = '',
  });
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

List<String> complaintTypes = [
  'Season Pass',
  'Reserve Bays',
  'Parking',
  'Enforcement',
  'Others',
];

class _ProfileScreenState extends State<ProfileScreen> {
  late final List<PBTModel> pbtModel;
  final TextEditingController _controller = TextEditingController();
  bool _isConfirmEnabled = false;
  bool _isAutoDeductEnabled = false;

  List<Icon> profileListIcon = [
    const Icon(Icons.person),
    const Icon(Icons.email_sharp),
    const Icon(Icons.location_on),
    const Icon(Icons.history),
    const Icon(Icons.autorenew_outlined),
    const Icon(Icons.settings),
    const Icon(Icons.share),
    const Icon(Icons.help_outline_rounded),
    const Icon(Icons.telegram),
  ];

  @override
  void initState() {
    super.initState();
    pbtModel = [];
    _loadAutoDeductStatus();
  }

  Future<void> _loadAutoDeductStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAutoDeductEnabled = prefs.getBool('auto_deduct_enabled') ?? false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // final Map<String, String> pbtMap = {
  //   'PBT Kuantan': 'e2cdf0ae-3d97-4032-b451-3bff0c9853ec',
  //   'PBT Machang': '942a008f-65a1-4edf-a67a-0509e1c6867d',
  //   'PBT Kuala Terengganu': 'b7c6f626-c33f-4f08-a9d2-cfe4a49bad47',
  // };

  // Future<bool> createhelpdesk() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');
  //   String? pbtId = pbtMap[selectedPBT];

  //   if (pbtId == null) {
  //     return false;
  //   }

  //   var url = Uri.parse("$baseUrl/helpdesk/create-helpdesk");
  //   var response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode({
  //       'pbt': pbtId,
  //       'description': description.text,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyToken);
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoute.loginScreen, (context) => false);
  }

  void _validateInput(String input) {
    setState(() {
      if (input.trim().toUpperCase() !=
              AppLocalizations.of(context)!.delete.toUpperCase() ||
          input.isEmpty) {
        _isConfirmEnabled = false;
      } else {
        _isConfirmEnabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    UserModel? userModel = arguments?['userModel'] as UserModel?;
    Map<String, dynamic>? details =
        arguments?['locationDetail'] as Map<String, dynamic>?;
    String avatar = arguments?['avatar'] as String? ?? '';

    final int colorValue = details != null && details['color'] != null
        ? details['color'] as int
        : 0xFFFFFFFF;

    List<String> profileList = [
      AppLocalizations.of(context)!.aboutMe,
      AppLocalizations.of(context)!.emailPassword,
      AppLocalizations.of(context)!.listOfVehicle,
      AppLocalizations.of(context)!.transactionHistory,
      "Auto-Deduct",
      AppLocalizations.of(context)!.settings,
      AppLocalizations.of(context)!.shareThisApp,
      AppLocalizations.of(context)!.helpCenter,
      AppLocalizations.of(context)!.termAndConditions,
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 280,
            decoration: const BoxDecoration(
              color: Color(0xFF1946AB),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BackButton(color: kWhite),
                      Text(
                        AppLocalizations.of(context)!.profile,
                        style: textStyleNormal(
                          fontSize: 26,
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ScaleTap(
                        onPressed: () async {
                          await CustomDialog.show(
                            context,
                            title: AppLocalizations.of(context)!.logout,
                            description:
                                '${AppLocalizations.of(context)!.logoutDesc}?',
                            btnOkOnPress: () async {
                              await logout();
                            },
                            btnOkText: AppLocalizations.of(context)!.yes,
                            btnCancelOnPress: () {
                              Navigator.pop(context);
                            },
                            btnCancelText: AppLocalizations.of(context)!.no,
                          );
                        },
                        child: const Icon(
                          Icons.logout,
                          color: kRed,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Profile avatar
                CircleAvatar(
                  radius: 40,
                  backgroundImage: avatar.isNotEmpty
                      ? NetworkImage(avatar)
                      : const AssetImage('assets/images/account.png')
                          as ImageProvider,
                ),
                const SizedBox(height: 10),
                // Profile name
                Text(
                  userModel != null
                      ? '${userModel.firstName} ${userModel.secondName}'
                      : widget.fullName,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.bold,
                    color: kWhite,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                // Profile list
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: profileList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                leading: profileListIcon[index],
                                title: Text(
                                  profileList[index],
                                  style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: index == 4
                                    ? Text(
                                        _isAutoDeductEnabled
                                            ? "Enabled"
                                            : "Disabled",
                                        style: TextStyle(
                                          color: _isAutoDeductEnabled
                                              ? const Color.fromARGB(
                                                  255, 34, 74, 151)
                                              : const Color.fromARGB(
                                                  255, 85, 85, 85),
                                          fontSize: 13,
                                        ),
                                      )
                                    : null,
                                trailing: const Icon(
                                    Icons.keyboard_arrow_right_sharp),
                                onTap: () {
                                  if (userModel == null) return;

                                  if (index == 0) {
                                    displayAboutMe(context, userModel);
                                  } else if (index == 1) {
                                    displayEmailPassword(
                                        context, userModel, details ?? {});
                                  } else if (index == 2) {
                                    vehicleList(context, userModel);
                                  } else if (index == 3) {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoute.transactionHistoryScreen,
                                      arguments: {
                                        'locationDetail': details ?? {},
                                      },
                                    );
                                  } else if (index == 4) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const AutoDeductScreen(),
                                      ),
                                    );
                                    _loadAutoDeductStatus();
                                  } else if (index == 5) {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoute.settingsScreen,
                                      arguments: {
                                        'locationDetail': details ?? {},
                                      },
                                    );
                                  } else if (index == 6) {
                                    Share.share(
                                        'Hey, check out this app! https://play.google.com/store/apps/details?id=com.example.project');
                                  } else if (index == 7) {
                                    helpCenter(context, pbtModel);
                                  }
                                },
                              ),
                              const Divider(
                                color: kBlack,
                                thickness: 0.2,
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                      // Delete account button
                      PrimaryButton(
                        borderRadius: 10.0,
                        buttonWidth: 0.9,
                        color: kRed,
                        label: Text(
                          AppLocalizations.of(context)!.deleteAccount,
                          style: textStyleNormal(
                              color: kWhite, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          CustomDialog.show(
                            context,
                            dialogType: DialogType.danger,
                            title: AppLocalizations.of(context)!.deleteAccount,
                            description:
                                AppLocalizations.of(context)!.deleteDesc,
                            center: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.typeDelete,
                                  style: textStyleNormal(
                                    fontSize: 12,
                                    color: kRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _controller,
                                  onChanged: _validateInput,
                                  decoration: InputDecoration(
                                    hintText:
                                        '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.delete.toUpperCase()}',
                                    hintStyle: const TextStyle(
                                      color: Colors.black26,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                            btnOkOnPress: () async {
                              if (_isConfirmEnabled) {
                                Navigator.pop(context);
                              }
                            },
                            btnOkText: AppLocalizations.of(context)!.yes,
                            btnCancelOnPress: () {
                              _isConfirmEnabled = false;
                              _controller.clear();
                              Navigator.pop(context);
                            },
                            btnCancelText: AppLocalizations.of(context)!.no,
                          );
                        },
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
