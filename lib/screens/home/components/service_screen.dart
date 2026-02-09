import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/service_card.dart';

class ServiceScreen extends StatefulWidget {
  final UserModel? userModel;
  final List<PlateNumberModel>? plateNumbers;
  final Map<String, dynamic> details;

  const ServiceScreen({
    super.key,
    this.userModel,
    this.plateNumbers,
    required this.details,
  });

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late final List<PBTModel> pbtModel;
  late final List<PromotionMonthlyPassModel> promotionMonthlyPassModel;
  late final List<PromotionMonthlyPassHistoryModel>
      promotionMonthlyPassHistoryModel;
  late Future<void> _initData;

  @override
  void initState() {
    super.initState();
    pbtModel = [];
    promotionMonthlyPassModel = [];
    promotionMonthlyPassHistoryModel = [];
    _initData = _initDataCombined();
    _getPromotionMonthlyPassHistory();
  }

  /// Fetch PBT and Promotions concurrently
  Future<void> _initDataCombined() async {
    await Future.wait([_getPBT(), _getPromotionMonthlyPass()]);
  }

  Future<void> _getPBT() async {
    final data = await PbtResources.getPBT(prefix: '/pbt/');
    if (data != null && mounted) {
      setState(() {
        pbtModel.addAll(
          data
              .map<PBTModel>((item) => PBTModel(
                    id: item['id'],
                    name: item['name'],
                    description: item['description'],
                  ))
              .toList(),
        );
      });
    }
  }

  Future<void> _getPromotionMonthlyPass() async {
    final data = await PromotionsResources.getPromotionMonthlyPass(
        prefix: '/promotion/public');
    if (data != null && mounted) {
      setState(() {
        promotionMonthlyPassModel.addAll(
          data
              .map<PromotionMonthlyPassModel>(
                  (item) => PromotionMonthlyPassModel(
                        id: item['id'],
                        title: item['title'],
                        description: item['description'],
                        type: item['type'],
                        rate: item['rate'],
                        date: item['date'],
                        expiredDate: item['expiredDate'],
                        image: item['image'],
                        timeUse: item['timeUse'],
                        createdAt: item['createdAt'],
                        updatedAt: item['updatedAt'],
                      ))
              .toList(),
        );
      });
    }
  }

  Future<void> _getPromotionMonthlyPassHistory() async {
    final data = await PromotionsResources.getPromotionHistory(
        prefix: '/monthlyPass/all/promotion');
    if (data != null && mounted) {
      setState(() {
        promotionMonthlyPassHistoryModel.addAll(
          data
              .map<PromotionMonthlyPassHistoryModel>(
                  (item) => PromotionMonthlyPassHistoryModel(
                        id: item['id'],
                        promotionId: item['promotionId'],
                        userId: item['userId'],
                        timeUse: item['timeUse'],
                        createdAt: item['createdAt'],
                        updatedAt: item['updatedAt'],
                      ))
              .toList(),
        );
      });
    }
  }

  Widget _buildServiceIcon(
    IconData icon,
    String label,
    List<Color> gradientColors,
    Color iconColor,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: gradientColors,
              center: Alignment.center,
              radius: 0.7,
            ),
            border: Border.all(
              color: gradientColors.first,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors.last.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 32,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while fetching data
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  AppLocalizations.of(context)!.ourService,
                  style: textStyleNormal(
                    color: kBlack,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: SizedBox(
                  height: 135,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoute.parkingScreen,
                            arguments: {
                              'locationDetail': widget.details,
                              'userModel': widget.userModel,
                              'plateNumbers': widget.plateNumbers ?? [],
                              'pbtModel': pbtModel,
                            },
                          );
                        },
                        child: _buildServiceIcon(
                          Icons.directions_car_filled_outlined,
                          AppLocalizations.of(context)!.parking2,
                          [Color(0xFFA7C7E7), Color(0xFFFFFFFF)],
                          Color(0xFF0F52BA),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoute.summonsScreen,
                            arguments: {
                              'locationDetail': widget.details,
                              'plateNumbers': widget.plateNumbers ?? [],
                              'userModel': widget.userModel,
                            },
                          );
                        },
                        child: _buildServiceIcon(
                          Icons.description_outlined,
                          AppLocalizations.of(context)!.summons,
                          [Color(0xFFAFE1AF), Color(0xFFFFFFFF)],
                          Color(0xFF2AAA8A),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoute.reserveBayScreen,
                            arguments: {
                              'locationDetail': widget.details,
                            },
                          );
                        },
                        child: _buildServiceIcon(
                          Icons.place_outlined,
                          AppLocalizations.of(context)!.reserveBays,
                          [Color(0xFFFFC0BC), Color(0xFFFFFFFF)],
                          Color(0xFFE37383),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoute.monthlyPassScreen,
                            arguments: {
                              'locationDetail': widget.details,
                              'userModel': widget.userModel,
                              'plateNumbers': widget.plateNumbers ?? [],
                              'pbtModel': pbtModel,
                              'promotions': promotionMonthlyPassModel,
                              'history': promotionMonthlyPassHistoryModel,
                            },
                          );
                        },
                        child: _buildServiceIcon(
                          Icons.credit_card_outlined,
                          AppLocalizations.of(context)!.monthlyPass,
                          [Color(0xFFFA8072), Color(0xFFFFFFFF)],
                          Color(0xFFD22B2B),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoute.transportInfoScreen,
                            arguments: {
                              'locationDetail': widget.details,
                            },
                          );
                        },
                        child: _buildServiceIcon(
                          Icons.directions_bus_filled_outlined,
                          AppLocalizations.of(context)!.transportInfo2,
                          [Color(0xFFFAC898), Color(0xFFFFFFFF)],
                          Color(0xFFE49B0F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
