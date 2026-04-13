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
  List<TicketModel> _originalSummons = [];

  List<PlateNumberModel>? _plateNumbers = [];
  UserModel? _userModel = UserModel();
  Map<String, dynamic> _details = {};

  final TextEditingController _searchController = TextEditingController();

  final Set<String> _selectedIds = {};
  final List<TicketModel> _selectedSummons = [];

  late Future<void> _initData;

  bool _isInitialized = false;

  String _selectedInputType =
      Get.locale!.languageCode == "en" ? 'Notice No.' : 'No. Notis';

  @override
  void initState() {
    super.initState();

    compoundModel = CompoundModel();
    summonModel = TicketModel();

    _searchController.addListener(_onSearchChanged);
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

      _initData = _getSummons();

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
            }

            return <TicketModel>[];
          } catch (e) {
            return <TicketModel>[];
          }
        }),
      );

      summonsList = responses.expand((e) => e).toList();
      _originalSummons = List.from(summonsList!);
    } catch (e) {
      debugPrint('Error fetching summons: $e');
    }

    setState(() {});
  }

  Future<void> _onSearchChanged() async {
    String query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      summonsList = List.from(_originalSummons);
    } else {
      summonsList = _originalSummons.where((summon) {
        if (_selectedInputType == 'Notice No.' ||
            _selectedInputType == 'No. Notis') {
          return summon.ticketNumber?.toLowerCase().contains(query) ?? false;
        }

        if (_selectedInputType == 'Plate Number' ||
            _selectedInputType == 'Nombor Plat') {
          return summon.vehicleNumber?.toLowerCase().contains(query) ?? false;
        }

        return false;
      }).toList();
    }

    setState(() {});
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
          return const Scaffold(body: LoadingDialog());
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              AppLocalizations.of(context)!.summons,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    /// SEARCH BOX
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.search,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          _onSearchChanged();
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// DROPDOWN BOX
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: _selectedInputType,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: inputType.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedInputType = value!;
                            _onSearchChanged();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: summonsList?.isNotEmpty ?? false
                    ? ListView.builder(
                        itemCount: summonsList!.length,
                        itemBuilder: (context, index) {
                          final notice = summonsList![index];
                          final isSelected =
                              _selectedIds.contains(notice.ticketNumber);

                          return ScaleTap(
                            onPressed: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedIds.remove(notice.ticketNumber);
                                  _selectedSummons.remove(notice);
                                } else {
                                  _selectedIds.add(notice.ticketNumber!);
                                  _selectedSummons.add(notice);
                                }
                              });
                            },
                            child: Card(
                              color: isSelected
                                  ? Colors.blue.withOpacity(0.3)
                                  : kWhite,
                              child: ListTile(
                                title: Text(
                                  "${AppLocalizations.of(context)!.noticeNo}: ${notice.ticketNumber}",
                                  style: textStyleNormal(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "${AppLocalizations.of(context)!.amount}: RM ${notice.fine?.toStringAsFixed(2)}",
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: Text("No summons found")),
              ),
            ],
          ),
          bottomNavigationBar: Visibility(
            visible: _selectedIds.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: PrimaryButton(
                buttonWidth: 0.8,
                borderRadius: 10,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoute.summonsPaymentScreen,
                    arguments: {
                      'locationDetail': _details,
                      'userModel': _userModel,
                      'selectedSummons': _selectedSummons,
                    },
                  );
                },
                label: Text(
                  AppLocalizations.of(context)!.pay,
                  style: textStyleNormal(color: kWhite),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
