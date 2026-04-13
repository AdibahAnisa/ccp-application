import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/screens/screens.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';

class MonthlyPassScreen extends StatelessWidget {
  const MonthlyPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    UserModel? userModel = arguments['userModel'] as UserModel?;
    List<PlateNumberModel>? plateNumbers =
        arguments['plateNumbers'] as List<PlateNumberModel>?;
    List<PBTModel>? pbtModel = arguments['pbtModel'] as List<PBTModel>?;
    List<PromotionMonthlyPassModel>? promotions =
        arguments['promotions'] as List<PromotionMonthlyPassModel>?;
    List<PromotionMonthlyPassHistoryModel>? history =
        arguments['history'] as List<PromotionMonthlyPassHistoryModel>?;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context, userModel);
          },
        ),
        title: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.monthlyPass,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            spaceVertical(height: 5.0),
            Text(
              AppLocalizations.of(context)!.onStreet,
              style: textStyleNormal(
                color: details['color'] == 4294961979 ? kBlack : kWhite,
              ),
            ),
          ],
        ),
      ),
      body: MonthlyPassBody(
        carPlates: plateNumbers!,
        details: details,
        pbtModel: pbtModel!,
        userModel: userModel!,
        promotions: promotions!,
        history: history!,
      ),
    );
  }
}
