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
    print("RELOAD FORM SUBMITTING");
    print("PAYMENT METHOD: ${paymentMethod.value}");
    print("AMOUNT VALUE: ${amount.value}");
    print("TOKEN VALUE: ${token.value}");
    print("OTHER VALUE: ${other.value}");
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
    } catch (e, stack) {
      print("RELOAD SUBMIT ERROR: $e");
      print("STACK: $stack");
      emitFailure(failureResponse: e.toString());
    }
  }

  // -------------------- Payment Handlers --------------------

  Future<void> _handleQRPayment() async {
    print("START QR PAYMENT");
    Map<String, dynamic> response = await _getQR();

    print("QR RESPONSE: $response");

    // If token expired, refresh and retry once
    if (response['error'] != null) {
      print("QR ERROR: ${response['error']}");

      final refresh = await PegeypayResources.refreshToken(
        prefix: '/payment/public/refresh-token',
      );

      print("REFRESH RESPONSE: $refresh");

      final newToken = refresh['access_token'] ?? refresh['accessToken'];

      if (newToken == null) {
        throw Exception(
            "Pegeypay token not found. Please call /payment/public/token first.");
      }

      await SharedPreferencesHelper.setPegeypayToken(
        token: newToken,
      );

      response = await _getQR();

      print("QR RESPONSE AFTER REFRESH: $response");
    }

    // Save order details
    await SharedPreferencesHelper.setReloadAmount(
        amount: double.parse(amount.value));
    final order = response['order'] ?? {};
    final data = response['data'] ?? {};

    await SharedPreferencesHelper.setOrderDetails(
      orderNo: order['order_no'] ?? response['order_no'] ?? "",
      amount: (order['order_amount'] ?? "").toString(),
      shiftId: order['shift_id'] ?? "",
      terminalId: order['terminal_id'] ?? "",
      storeId: order['store_id'] ?? "",
      status: 'pending',
    );

    GlobalState.paymentMethod = 'QR';
    final iframeUrl = response['data']?['content']?['iframe_url'];

    print("QR IFRAME URL: $iframeUrl");
    print("FULL QR RESPONSE: $response");

    if (iframeUrl == null || iframeUrl.toString().isEmpty) {
      throw Exception('QR URL is null or missing');
    }

    emitSuccess(successResponse: iframeUrl.toString());
  }

  Future<void> _handleFPXPayment() async {
    print("START FPX PAYMENT");
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
      status: "pending",
    );

    GlobalState.paymentMethod = 'FPX';
    emitSuccess(
      successResponse: jsonEncode({
        "url": response['ShortcutLink'],
        "orderNo": response['BillId'].toString(),
        "type": "FPX",
      }),
    );
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
        'terminal_id': details['location'] ?? "CCP APP",
        'shift_id': model.idNumber?.isNotEmpty == true
            ? model.idNumber
            : model.email ?? "TOKEN_RELOAD",
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
