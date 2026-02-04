import 'dart:async';
import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';

class MonthlyPassFormBloc extends FormBloc<String, String> {
  final UserModel model;
  final List<PlateNumberModel>? platModel;
  final List<PromotionMonthlyPassModel> promotionModel;
  final List<PBTModel> pbtModel;
  final Map<String, dynamic> details;

  final SelectFieldBloc<String?, dynamic> carPlateNumber;
  final SelectFieldBloc<String?, dynamic> pbt;
  final SelectFieldBloc<String?, dynamic> promotion;
  final SelectFieldBloc<String?, dynamic> location;
  final TextFieldBloc amount;

  final paymentMethod = SelectFieldBloc<String, dynamic>(
    items: ['QR', 'FPX'],
    validators: [InputValidator.required],
  );

  MonthlyPassFormBloc({
    required this.platModel,
    required this.pbtModel,
    required this.promotionModel,
    required this.details,
    required this.model,
  })  : pbt = SelectFieldBloc(
          items: pbtModel.map((pbt) => pbt.name).toList(),
        ),
        promotion = SelectFieldBloc(
          items: promotionModel.map((promotion) => promotion.title).toList(),
        ),
        carPlateNumber = SelectFieldBloc(
          items: (platModel?.isNotEmpty ?? false)
              ? platModel!.map((plate) => plate.plateNumber).toList()
              : [],
          initialValue: platModel
                  ?.firstWhere(
                    (plate) => plate.isMain ?? false,
                    orElse: () => platModel.first,
                  )
                  .plateNumber ??
              '',
        ),
        location = SelectFieldBloc(
          items: ['Kelantan', 'Terengganu', 'Pahang'],
        ),
        amount = TextFieldBloc() {
    pbt.updateInitialValue(details['location'] ?? '');
    location.updateInitialValue(details['state'] ?? '');

    addFieldBlocs(
      fieldBlocs: [
        carPlateNumber,
        pbt,
        promotion,
        location,
        amount,
        paymentMethod,
      ],
    );
  }

  // ================= SUBMIT =================

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      if (paymentMethod.value == 'QR') {
        await _handleQRPayment();
      } else {
        await _handleFPXPayment();
      }
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }

  // ================= PAYMENT HANDLERS =================

  Future<void> _handleQRPayment() async {
    GlobalState.paymentMethod = 'QR';

    var response = await getQR();

    if (response['error'] != null) {
      await PegeypayResources.refreshToken(
        prefix: '/payment/public/refresh-token',
      );

      response = await getQR();
    }

    await SharedPreferencesHelper.setOrderDetails(
      orderNo: response['order']['order_no'],
      amount: response['order']['order_amount'].toString(),
      shiftId: response['order']['shift_id'],
      terminalId: response['order']['terminal_id'],
      storeId: response['order']['store_id'],
      status: 'paid',
    );

    emitSuccess(
      successResponse: response['data']['content']['iframe_url'],
    );
  }

  Future<void> _handleFPXPayment() async {
    GlobalState.paymentMethod = 'FPX';

    var response = await getFPX();

    if (response['error'] == "Failed to refresh token" ||
        response['SFM']?['Constant'] == "SFM_GENERAL_ERROR") {
      await PegeypayResources.refreshToken(
        prefix: '/paymentfpx/public',
      );

      response = await getFPX();
    }

    await SharedPreferencesHelper.setOrderDetails(
      orderNo: response['BillId'].toString(),
      amount: amount.value.toString(),
      storeId: "MonthlyPass",
      shiftId: model.email!,
      terminalId: response['BatchName'].toString(),
      status: "paid",
    );

    emitSuccess(successResponse: response['ShortcutLink']);
  }

  // ================= API CALLS =================

  Future<Map<String, dynamic>> getQR() async {
    final serialNumber = generateSerialNumber();

    return await PegeypayResources.generateQR(
      prefix: '/payment/generate-qr',
      body: jsonEncode({
        'order_output': "online",
        'order_number': 'CCPMP-$serialNumber',
        'order_amount': double.parse(amount.value),
        'validity_qr': "10",
        'store_id': 'Monthly Pass',
        'terminal_id': details['location'],
        'shift_id': model.idNumber,
        'to_whatsapp_no': model.phoneNumber,
      }),
    );
  }

  Future<Map<String, dynamic>> getFPX() async {
    return await ReloadResources.reloadMoneyFPX(
      prefix: '/paymentfpx/recordBill-seasonpass/',
      body: jsonEncode({
        'NetAmount': double.parse(amount.value),
      }),
    );
  }
}
