import 'dart:async';
import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';

class CompoundFormBloc extends FormBloc<String, String> {
  final UserModel model;
  final Map<String, dynamic> details;

  final amount = TextFieldBloc(
    validators: [InputValidator.amount],
  );

  final paymentMethod = SelectFieldBloc(
    items: ['QR', 'FPX'],
    validators: [InputValidator.required],
  );

  CompoundFormBloc({
    required this.model,
    required this.details,
  }) {
    addFieldBlocs(
      fieldBlocs: [amount, paymentMethod],
    );
  }

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

  /* ───────────────────── QR PAYMENT ───────────────────── */

  Future<void> _handleQRPayment() async {
    GlobalState.paymentMethod = 'QR';

    var response = await _getQR();

    if (response['error'] != null) {
      await _refreshQRToken();
      response = await _getQR();
    }

    await _saveQROrder(response);
    emitSuccess(
      successResponse: response['data']['content']['iframe_url'],
    );
  }

  Future<void> _refreshQRToken() async {
    final tokenResponse = await PegeypayResources.refreshToken(
      prefix: '/payment/public/refresh-token',
    );

    await SharedPreferencesHelper.setPegeypayToken(
      token: tokenResponse['access_token'],
    );
  }

  Future<Map<String, dynamic>> _getQR() async {
    final serialNumber = generateSerialNumber();

    return PegeypayResources.generateQR(
      prefix: '/payment/generate-qr',
      body: jsonEncode({
        'order_output': 'online',
        'order_number': 'CCPC-$serialNumber',
        'order_amount': double.parse(amount.value),
        'validity_qr': '10',
        'store_id': 'Compound',
        'terminal_id': details['location'],
        'shift_id': model.idNumber,
        'to_whatsapp_no': model.phoneNumber,
      }),
    );
  }

  Future<void> _saveQROrder(Map<String, dynamic> response) async {
    final order = response['order'];

    await SharedPreferencesHelper.setOrderDetails(
      orderNo: order['order_no'],
      amount: order['order_amount'].toString(),
      shiftId: order['shift_id'],
      terminalId: order['terminal_id'],
      storeId: order['store_id'],
      toWhatsappNo: order['to_whatsapp_no'],
      status: 'paid',
    );
  }

  /* ───────────────────── FPX PAYMENT ───────────────────── */

  Future<void> _handleFPXPayment() async {
    GlobalState.paymentMethod = 'FPX';

    var response = await _getFPX();

    if (_shouldRefreshFPX(response)) {
      await _refreshFPXToken();
      response = await _getFPX();
    }

    await _saveFPXOrder(response);
    emitSuccess(successResponse: response['ShortcutLink']);
  }

  bool _shouldRefreshFPX(Map<String, dynamic> response) {
    return response['error'] == 'Failed to refresh token' ||
        response['error'] == 'Internal server error' ||
        response['SFM']?['Constant'] == 'SFM_GENERAL_ERROR';
  }

  Future<void> _refreshFPXToken() async {
    await PegeypayResources.refreshToken(
      prefix: '/paymentfpx/public',
    );
  }

  Future<Map<String, dynamic>> _getFPX() async {
    return ReloadResources.reloadMoneyFPX(
      prefix: '/paymentfpx/recordBill-compound/',
      body: jsonEncode({
        'NetAmount': double.parse(amount.value),
      }),
    );
  }

  Future<void> _saveFPXOrder(Map<String, dynamic> response) async {
    await SharedPreferencesHelper.setOrderDetails(
      orderNo: response['BillId'].toString(),
      amount: amount.value.toString(),
      storeId: 'Compound',
      shiftId: model.email!,
      terminalId: response['BatchName'].toString(),
      status: 'paid',
    );
  }
}
