import 'dart:async';
import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';

class ReloadFormBloc extends FormBloc<String, String> {
  final UserModel model;
  final Map<String, dynamic> details;

  final other = TextFieldBloc();
  final token = TextFieldBloc(validators: [InputValidator.required]);
  final amount = TextFieldBloc(validators: [InputValidator.amount]);

  final paymentMethod = SelectFieldBloc(
    initialValue: 'QR',
    items: ['QR', 'FPX'],
    validators: [InputValidator.required],
  );

  ReloadFormBloc({
    required this.model,
    required this.details,
  }) {
    addFieldBlocs(fieldBlocs: [other, token, amount, paymentMethod]);
  }

  @override
  FutureOr<void> onSubmitting() async {
    // Validate token or "other" field
    if (token.value.isEmpty && other.value.isEmpty) {
      token.addFieldError('Select the Amount First');
      other.addFieldError('Amount is required');
      emitFailure();
      return;
    }

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

  // -------------------- Payment Handlers --------------------

  Future<void> _handleQRPayment() async {
    Map<String, dynamic> response = await _getQR();

    // If token expired, refresh and retry once
    if (response['error'] != null) {
      final refresh = await PegeypayResources.refreshToken(
        prefix: '/payment/public/refresh-token',
      );
      await SharedPreferencesHelper.setPegeypayToken(
        token: refresh['access_token'],
      );
      response = await _getQR(); // Retry
    }

    // Save order details
    await SharedPreferencesHelper.setReloadAmount(
        amount: double.parse(amount.value));
    await SharedPreferencesHelper.setOrderDetails(
      orderNo: response['order']['order_no'],
      amount: response['order']['order_amount'].toString(),
      shiftId: response['order']['shift_id'],
      terminalId: response['order']['terminal_id'],
      storeId: response['order']['store_id'],
      status: 'paid',
    );

    GlobalState.paymentMethod = 'QR';
    emitSuccess(successResponse: response['data']['content']['iframe_url']);
  }

  Future<void> _handleFPXPayment() async {
    Map<String, dynamic> response = await _getFPX();

    // Refresh token if failed
    if (response['error'] == "Failed to refresh token" ||
        response['SFM']?['Constant'] == "SFM_GENERAL_ERROR") {
      await PegeypayResources.refreshToken(prefix: '/paymentfpx/public');
      response = await _getFPX(); // Retry
    }

    await SharedPreferencesHelper.setOrderDetails(
      orderNo: response['BillId'].toString(),
      amount: amount.value.toString(),
      storeId: "Token",
      shiftId: model.email!,
      terminalId: response['BatchName'].toString(),
      status: "paid",
    );

    GlobalState.paymentMethod = 'FPX';
    emitSuccess(successResponse: response['ShortcutLink']);
  }

  // -------------------- API Calls --------------------

  Future<Map<String, dynamic>> _getQR() async {
    String serialNumber = generateSerialNumber();

    return await PegeypayResources.generateQR(
      prefix: '/payment/generate-qr',
      body: jsonEncode({
        'order_output': "online",
        'order_number': 'CCPR-$serialNumber',
        'order_amount': double.parse(amount.value),
        'validity_qr': "10",
        'store_id': 'Token',
        'terminal_id': details['location'],
        'shift_id': model.idNumber,
        'to_whatsapp_no': model.phoneNumber,
      }),
    );
  }

  Future<Map<String, dynamic>> _getFPX() async {
    return await ReloadResources.reloadMoneyFPX(
      prefix: '/paymentfpx/recordBill-token/',
      body: jsonEncode({'NetAmount': double.parse(amount.value)}),
    );
  }
}
