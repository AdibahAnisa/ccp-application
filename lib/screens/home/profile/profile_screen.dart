// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:project/app/helpers/avatar_helper.dart';
import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/screens/home/profile/components/email_password_screen.dart';
import 'package:project/screens/home/profile/components/help_center_screen.dart';
import 'package:project/screens/home/profile/components/privacy_policy_screen.dart';
import 'package:project/screens/home/profile/components/terms_condition_screen.dart';
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
  final String email;
  final String avatar;
  final UserModel? userModel;
  final Map<String, dynamic>? locationDetail;
  const ProfileScreen({
    super.key,
    this.userModel,
    this.locationDetail,
    this.fullName = 'User',
    this.avatar = '',
    this.email = 'User',
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
  UserModel? userModel;
  bool _isInitialized = false;
  File? _profileImage;

  List<Icon> profileListIcon = [
    const Icon(Icons.person),
    const Icon(Icons.email_outlined),
    const Icon(Icons.location_on),
    const Icon(Icons.history),
    const Icon(Icons.autorenew_outlined),
    const Icon(Icons.settings),
    const Icon(Icons.share),
    const Icon(Icons.help_outline_rounded),
    const Icon(Icons.telegram),
    const Icon(Icons.privacy_tip_outlined),
  ];

  @override
  void initState() {
    super.initState();
    pbtModel = [];
    userModel = widget.userModel;
    _loadAutoDeductStatus();
    _loadAvatar();
  }

  Future<void> _loadAutoDeductStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAutoDeductEnabled = prefs.getBool('auto_deduct_enabled') ?? false;
    });
  }

  Future<void> _loadAvatar() async {
    final file = await AvatarHelper.getAvatarFile();

    if (file != null) {
      setState(() {
        _profileImage = file;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await AvatarHelper.saveAvatar(pickedFile.path);

      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (arguments != null) {
        userModel = arguments['userModel'];
      }

      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? details = widget.locationDetail;
    String avatar = widget.avatar;
    // final arguments =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Map<String, dynamic>? details =
    //     arguments?['locationDetail'] as Map<String, dynamic>?;
    // String avatar = arguments?['avatar'] as String? ?? '';

    // final int colorValue = details != null && details['color'] != null
    //     ? details['color'] as int
    //     : 0xFFFFFFFF;

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
      AppLocalizations.of(context)!.privacyPolicy,
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 320,
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
                    children: [
                      const BackButton(color: kWhite),
                      Expanded(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.profile,
                            style: textStyleNormal(
                              fontSize: 26,
                              color: kWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // Profile avatar
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('assets/images/account.png')
                          as ImageProvider,
                ),
                const SizedBox(height: 15),
                // Profile name
                Text(
                  userModel != null
                      ? '${userModel!.firstName} ${userModel!.secondName}'
                      : widget.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kWhite,
                    fontSize: 25,
                  ),
                ),

                Text(
                  userModel != null ? '${userModel!.email}' : widget.email,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: kWhite.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                onTap: () async {
                                  if (userModel == null) return;

                                  if (index == 0) {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AboutMeScreen(
                                            userModel: userModel!),
                                      ),
                                    );

                                    if (result != null) {
                                      setState(() {
                                        userModel = result;
                                      });
                                    }
                                  } else if (index == 1) {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EmailPasswordScreen(
                                            userModel: userModel!),
                                      ),
                                    );

                                    if (result != null) {
                                      setState(() {
                                        userModel = result;
                                      });
                                    }
                                  } else if (index == 2) {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => VehicleListScreen(
                                            userModel: userModel!),
                                      ),
                                    );

                                    if (result != null) {
                                      setState(() {
                                        userModel = result;
                                      });
                                    }
                                  } else if (index == 3) {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoute.transactionHistoryScreen,
                                      arguments: {
                                        'locationDetail': details ?? {},
                                      },
                                    );
                                  } else if (index == 4) {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const AutoDeductScreen(),
                                      ),
                                    );

                                    await _loadAutoDeductStatus();
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => HelpCentreScreen(
                                          pbtModel: pbtModel,
                                        ),
                                      ),
                                    );
                                  } else if (index == 8) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const TermsAndConditionScreen(),
                                      ),
                                    );
                                  } else if (index == 9) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const PrivacyPolicyScreen(),
                                      ),
                                    );
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
                      PrimaryButton(
                        borderRadius: 10.0,
                        buttonWidth: 0.9,
                        color: kRed,
                        label: Text(
                          AppLocalizations.of(context)!.logout,
                          style: textStyleNormal(
                              color: kWhite, fontWeight: FontWeight.bold),
                        ),
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
