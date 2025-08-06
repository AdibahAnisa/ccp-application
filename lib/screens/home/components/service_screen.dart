import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
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
    pbtModel = [];
    promotionMonthlyPassModel = [];
    promotionMonthlyPassHistoryModel = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.ourService,
            style: textStyleNormal(
              color: kBlack,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          spaceVertical(height: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: _initData,
                      builder: (context, snapshot) {
                        return ServiceCard(
                          onPressed: () {
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
                          image: parkingImage,
                          title: AppLocalizations.of(context)!.parking2,
                        );
                      }),
                  ServiceCard(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoute.summonsScreen,
                          arguments: {
                            'locationDetail': widget.details,
                            'plateNumbers': widget.plateNumbers ?? [],
                            'userModel': widget.userModel,
                          });
                    },
                    image: summonImage,
                    title: AppLocalizations.of(context)!.summons,
                  ),
                  ServiceCard(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoute.reserveBayScreen,
                          arguments: {
                            'locationDetail': widget.details,
                          });
                    },
                    image: reserveBayImage,
                    title: AppLocalizations.of(context)!.reserveBays,
                  ),
                ],
              ),
              spaceVertical(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceCard(
                    onPressed: () {
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
                    image: monthlyPassImage,
                    title: AppLocalizations.of(context)!.monthlyPass,
                  ),
                  ServiceCard(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoute.transportInfoScreen,
                        arguments: {
                          'locationDetail': widget.details,
                        },
                      );
                    },
                    image: transportInfoImage,
                    title: AppLocalizations.of(context)!.transportInfo2,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
