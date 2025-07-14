import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:get/get.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';

class SummonsScreen extends StatefulWidget {
  const SummonsScreen({super.key});

  @override
  State<SummonsScreen> createState() => _SummonsScreenState();
}

class _SummonsScreenState extends State<SummonsScreen> {
  late final TicketModel summonModel;
  late final CompoundModel compoundModel;
  List<TicketModel>? summonsList;
  late Future<void> _initData;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final TextEditingController _searchController = TextEditingController();
  // Use a Set to keep track of selected notices
  final Set<String> _selectedIds =
      <String>{}; // Change to String if you want to store other IDs like offenderIDNo or vehicleRegistrationNumber
  final List<TicketModel> _selectedSummons =
      []; // Temporary list to store selected summons

  List<PlateNumberModel>? _plateNumbers = [];
  UserModel? _userModel = UserModel();
  Map<String, dynamic> _details = {};

  String _selectedInputType = Get.locale!.languageCode == "en"
      ? 'Notice No.'
      : 'No. Notis'; // Default selected dropdown value

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    compoundModel = CompoundModel();
    summonModel = TicketModel();
    _searchController.addListener(_onSearchChanged); // Add search listener
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

      _details = arguments['locationDetail'] as Map<String, dynamic>;
      _userModel = arguments['userModel'] as UserModel?;
      _plateNumbers = arguments['plateNumbers'] as List<PlateNumberModel>?;

      _initData = _getSummons(); // Set future for FutureBuilder
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getSummons() async {
    if (_plateNumbers == null || _plateNumbers!.isEmpty) return;

    try {
      // Run multiple async API calls in parallel
      final responses = await Future.wait(
        _plateNumbers!.map((plate) async {
          try {
            final response = await CompoundResources.displayPrimaryCompound(
              prefix: '/compound/outstanding',
              body: jsonEncode({'VehicleNo': plate.plateNumber}),
            );

            if (response['Result'] is List &&
                (response['Result'] as List).isNotEmpty) {
              final List fetched = response['Result'];
              return fetched.map((e) => TicketModel.fromJson(e)).toList();
            } else {
              return <TicketModel>[]; // Empty list if null or empty
            }
          } catch (e) {
            print('Error on plate ${plate.plateNumber}: $e');
            return <TicketModel>[]; // Return empty list on error
          }
        }),
      );

      // Flatten the list of lists
      summonsList = responses.expand((e) => e).toList();
    } catch (e) {
      print('General error in fetching summons: $e');
    }

    setState(() {});
  }

  Future<void> _onSearchChanged() async {
    String query = _searchController.text.toLowerCase();

    if (query.isNotEmpty) {
      // Filter the summonsList based on the selected input type
      setState(() {
        summonsList = summonsList?.where((summon) {
          if (_selectedInputType == 'Notice No.' ||
              _selectedInputType == 'No. Notis') {
            return summon.ticketNumber?.toLowerCase().contains(query) ?? false;
          } else if (_selectedInputType == 'Plate Number' ||
              _selectedInputType == 'Nombor Plat') {
            return summon.vehicleNumber?.toLowerCase().contains(query) ?? false;
          }
          return false;
        }).toList();
      });
    } else {
      // If the query is empty, reload the original summons list
      await _getSummons();
      setState(() {}); // Ensure the state is updated to reflect the changes
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> inputType = [
      AppLocalizations.of(context)!.noticeNo,
      AppLocalizations.of(context)!.plateNumber,
    ];
    return FutureBuilder<void>(
      future: _initData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: LoadingDialog(),
          );
        } else {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _getSummons,
            child: Scaffold(
              backgroundColor: kBackgroundColor,
              appBar: AppBar(
                toolbarHeight: 100,
                foregroundColor:
                    _details['color'] == 4294961979 ? kBlack : kWhite,
                backgroundColor: Color(_details['color']!),
                centerTitle: true,
                title: Text(
                  AppLocalizations.of(context)!.summons,
                  style: textStyleNormal(
                    fontSize: 26,
                    color: _details['color'] == 4294961979 ? kBlack : kWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          label: Text(AppLocalizations.of(context)!.search),
                          hintText:
                              AppLocalizations.of(context)!.enterSearchTerm,
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DropdownButton<String>(
                                value: _selectedInputType,
                                items: inputType.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedInputType = newValue!;
                                    _onSearchChanged(); // Trigger search when dropdown changes
                                  });
                                },
                              ),
                              spaceHorizontal(width: 10.0),
                              _searchController.text.isNotEmpty
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          _searchController.clear();
                                          _onSearchChanged(); // Trigger search changed to reload original list
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: kRed,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
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
                      spaceVertical(height: 10.0),
                      summonsList?.isNotEmpty ?? false
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: summonsList?.length ?? 0,
                              itemBuilder: (context, index) {
                                final notice = summonsList![index];
                                final isSelected = _selectedIds.contains(notice
                                    .ticketNumber); // Change to your selected ID
                                return ScaleTap(
                                  onPressed: () {
                                    setState(() {
                                      // Toggle the selection state
                                      if (isSelected) {
                                        _selectedIds
                                            .remove(notice.ticketNumber);
                                        _selectedSummons.remove(
                                            notice); // Remove from the temporary list
                                      } else {
                                        _selectedIds.add(notice.ticketNumber!);
                                        _selectedSummons.add(
                                            notice); // Add to the temporary list
                                      }
                                    });
                                  },
                                  child: Card(
                                    color: isSelected
                                        ? Colors.blue.withOpacity(0.3)
                                        : kWhite, // Change background color when selected
                                    child: ListTile(
                                      title: Text(
                                        '${AppLocalizations.of(context)!.noticeNo}: ${notice.ticketNumber}',
                                        style: textStyleNormal(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          spaceVertical(height: 10.0),
                                          Text(
                                            '${AppLocalizations.of(context)!.vehicleNo}: ${notice.ticketNumber}',
                                            style: textStyleNormal(),
                                          ),
                                          Text(
                                            '${AppLocalizations.of(context)!.offencesAct}: ${notice.offenceSection?.act?.description}',
                                            style: textStyleNormal(),
                                          ),
                                          Text(
                                            '${AppLocalizations.of(context)!.offencesDate}: ${formatOffenceDate(notice.offenceDateTime!)}',
                                            style: textStyleNormal(),
                                          ),
                                          Text(
                                            '${AppLocalizations.of(context)!.amount}: RM ${notice.fine!.toStringAsFixed(2)}',
                                            style: textStyleNormal(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.25),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.thumb_up_alt_sharp,
                                      color: kGrey,
                                      size: 80,
                                    ),
                                    spaceVertical(height: 10.0),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .compoundDesc,
                                      style: textStyleNormal(
                                        color: kGrey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Visibility(
                visible: _selectedIds.isNotEmpty ? true : false,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: PrimaryButton(
                    buttonWidth: 0.8,
                    borderRadius: 10.0,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoute.summonsPaymentScreen,
                        arguments: {
                          'locationDetail': _details,
                          'userModel': _userModel,
                          'selectedSummons':
                              _selectedSummons, // Pass the temporary list
                        },
                      );
                    },
                    label: Text(
                      AppLocalizations.of(context)!.pay,
                      style: textStyleNormal(
                        color: kWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
