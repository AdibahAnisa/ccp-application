import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';

class ReserveBayScreen extends StatefulWidget {
  const ReserveBayScreen({super.key});

  @override
  State<ReserveBayScreen> createState() => _ReserveBayScreenState();
}

class _ReserveBayScreenState extends State<ReserveBayScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late Future<void> _initData;

  List<ReserveBayModel> reserveBayList = [];

  @override
  void initState() {
    super.initState();
    _initData = _getReserveBay();
  }

  Future<void> _getReserveBay() async {
    final data = await ReserveBayResources.getListReserveBay(
      prefix: '/reservebay',
    );

    if (data != null && mounted) {
      if (data is List) {
        setState(() {
          reserveBayList =
              data.map((item) => ReserveBayModel.fromJson(item)).toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;

    return FutureBuilder<void>(
      future: _initData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: LoadingDialog(),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: LoadingDialog(),
          );
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
              '${AppLocalizations.of(context)!.parking} ${AppLocalizations.of(context)!.reserveBays}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: kPrimaryColor,
            foregroundColor: kWhite,
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoute.addReserveBayScreen,
                arguments: {
                  'locationDetail': details,
                },
              );
            },
          ),
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _getReserveBay,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: reserveBayList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.receipt,
                            color: kGrey,
                            size: 80,
                          ),
                          spaceVertical(height: 10),
                          Text(
                            'There no records of Reserve Bay.',
                            style: textStyleNormal(
                              color: kGrey,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: reserveBayList.length,
                      itemBuilder: (context, index) {
                        final reserveBay = reserveBayList[index];

                        final String reserveBayTotalLot;

                        if (reserveBay.totalLotRequired == 300) {
                          reserveBayTotalLot = '3 Bulan: RM 300';
                        } else if (reserveBay.totalLotRequired == 600) {
                          reserveBayTotalLot = '6 Bulan: RM 600';
                        } else {
                          reserveBayTotalLot = '12 Bulan: RM 1,200';
                        }

                        return ScaleTap(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoute.viewReserveBayScreen,
                              arguments: {
                                'locationDetail': details,
                                'reserveBayModel': reserveBay,
                              },
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: kWhite,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${AppLocalizations.of(context)!.companyName}: ${reserveBay.companyName}",
                                        style: textStyleNormal(),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: reserveBay.status == "PENDING"
                                            ? kGrey
                                            : reserveBay.status == "APPROVED"
                                                ? kBgSuccess
                                                : kRed,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        reserveBay.status ?? '',
                                        style: textStyleNormal(
                                          color: kWhite,
                                          fontSize: 10,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.companyRegistration}: ",
                                      style: textStyleNormal(),
                                    ),
                                    Text(
                                      "${reserveBay.companyRegistration}",
                                      style: textStyleNormal(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.totalLotRequired}: ",
                                      style: textStyleNormal(),
                                    ),
                                    Text(
                                      reserveBayTotalLot,
                                      style: textStyleNormal(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.reason}: ",
                                      style: textStyleNormal(),
                                    ),
                                    Text(
                                      "${reserveBay.reason}",
                                      style: textStyleNormal(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}
