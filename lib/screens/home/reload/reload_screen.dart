// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter/material.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/component/webview.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';
import 'package:project/controllers/active_parking_controller.dart';

class ReloadScreen extends StatefulWidget {
  final String? plateNumber;
  final double? requiredAmount;
  final Map<String, dynamic> details;
  final UserModel userModel;

  const ReloadScreen({
    super.key,
    this.plateNumber,
    this.requiredAmount,
    required this.details,
    required this.userModel,
  });
  @override
  State<ReloadScreen> createState() => _ReloadScreenState();
}

class _ReloadScreenState extends State<ReloadScreen> {
  String? _selectedLabel; // Variable to store the selected label
  bool isOtherValue = false; // Flag to determine if "Other" is selected
  late ReloadFormBloc formBloc; // Make it non-nullable
  late double amountReload;

  @override
  void initState() {
    super.initState();
    getReloadAmount();
  }

  void _showError(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> getReloadAmount() async {
    amountReload = await SharedPreferencesHelper.getReloadAmount();
  }

  Future<bool> _confirmParkingAfterReload() async {
    if (widget.plateNumber == null || widget.plateNumber!.isEmpty) {
      return true; // normal reload only, no parking confirm
    }
    try {
      final token = await SharedPreferencesHelper.getToken();

      final response = await http.post(
        Uri.parse("$baseUrl/parking/confirm"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "plateNumber": widget.plateNumber,
          "hours": 1,
          "state": widget.details["state"],
          "pbt": widget.details["pbt"],
          "location": widget.details["location"],
          "area": widget.details["area"],
        }),
      );

      print("AUTO CONFIRM STATUS: ${response.statusCode}");
      print("AUTO CONFIRM BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["success"] == true &&
          data["type"] == "AUTO_PAID") {
        final activeParkingController = Get.find<ActiveParkingController>();

        activeParkingController.startActiveParking(
          plateNumber: widget.plateNumber!,
          parkingStartTime: DateTime.parse(data["startTime"]),
          parkingEndTime: DateTime.parse(data["endTime"]),
        );
        await Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color.fromRGBO(34, 74, 151, 1),
                    size: 55,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Auto Deduct Berjaya",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      text: "Bayaran parkir selama 1 jam bagi kenderaan ",
                      children: [
                        TextSpan(
                          text: widget.plateNumber,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              " telah berjaya ditolak daripada baki token anda.",
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );

        return true;
      }

      Get.snackbar("Error", "Reload berjaya tetapi auto deduct gagal.");
      return false;
    } catch (e) {
      print("AUTO CONFIRM ERROR: $e");
      Get.snackbar("Error", "Something went wrong during auto deduct.");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final plateNumber = widget.plateNumber ?? '';
    final requiredAmount = widget.requiredAmount ?? 0.0;

    return BlocProvider(
      create: (context) => ReloadFormBloc(
        model: widget.userModel,
        details: widget.details,
      ),
      child: Builder(
        builder: (context) {
          formBloc = BlocProvider.of<ReloadFormBloc>(context);

          if (formBloc.token.value == null || formBloc.token.value!.isEmpty) {
            final amount = requiredAmount.toStringAsFixed(2);
            formBloc.token.updateValue(amount);
            formBloc.amount.updateValue(amount);
          }

          return FormBlocListener<ReloadFormBloc, String, String>(
            onSubmitting: (context, state) {
              LoadingDialog.show(context);
            },
            onSubmissionFailed: (context, state) => LoadingDialog.hide(context),
            onSuccess: (context, state) async {
              LoadingDialog.hide(context);

              final payment = GlobalState.paymentMethod;

              if (!context.mounted) return;

              try {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewPage(
                      title: payment == 'FPX' ? "FPX" : "QR Code",
                      url: state.successResponse!,
                      details: widget.details,
                    ),
                  ),
                );

                if (!context.mounted) return;

                LoadingDialog.show(context);

                final order = await SharedPreferencesHelper.getOrderDetails();

                Map<String, dynamic> response;

                /// ================= FPX =================
                if (payment == 'FPX') {
                  response = await ReloadResources.reloadProcess(
                    prefix: '/paymentfpx/callbackurl-fpx/',
                    body: jsonEncode({
                      'ActivityTag': "CheckPaymentStatus",
                      'LanguageCode': "en",
                      'AppReleaseId': "34",
                      'GMTTimeDifference': 8,
                      'PaymentTxnRef': null,
                      'BillId': order['orderNo'],
                      'BillReference': null,
                    }),
                  );

                  final status = response['SFM']?['Constant'];

                  if (status == 'SFM_EXECUTE_PAYMENT_SUCCESS') {
                    final confirm = await ReloadResources.reloadSuccessful(
                      prefix: '/payment/callbackUrl/pegeypay',
                      body: jsonEncode({
                        'order_no': order['orderNo'],
                        'order_amount': double.parse(order['amount']),
                        'order_status': order['status'],
                        'store_id': order['storeId'],
                        'shift_id': order['shiftId'],
                        'terminal_id': order['terminalId'],
                      }),
                    );

                    if (confirm['order_status'] == 'paid') {
                      await _confirmParkingAfterReload();

                      if (!context.mounted) return;

                      Navigator.pushNamed(
                        context,
                        AppRoute.reloadReceiptScreen,
                        arguments: {
                          'locationDetail': widget.details,
                          'userModel': widget.userModel,
                          'amount': double.parse(order['amount']),
                        },
                      );
                    } else {
                      _showError(context, 'Payment not completed');
                    }
                  } else if (status == "SFM_EXECUTE_PAYMENT_FAILED") {
                    _showError(context, 'FPX Payment Failed');
                  } else if (status == "SFM_EXECUTE_PAYMENT_CANCELLED" ||
                      status == "SFM_TXN_NOT_FOUND") {
                    _showError(context, 'Payment Cancelled');
                  } else {
                    _showError(context, 'Payment Pending / Unknown Status');
                  }
                }

                /// ================= QR =================
                else {
                  response = await ReloadResources.reloadProcess(
                    prefix: '/payment/transaction-details',
                    body: jsonEncode({
                      'order_no': order['orderNo'],
                    }),
                  );

                  if (response['status'] == 'success' &&
                      response['content']['order_status'] == 'successful') {
                    final confirm = await ReloadResources.reloadSuccessful(
                      prefix: '/payment/callbackUrl/pegeypay',
                      body: jsonEncode({
                        'order_no': order['orderNo'],
                        'order_amount': double.parse(order['amount']),
                        'order_status': order['status'],
                        'store_id': order['storeId'],
                        'shift_id': order['shiftId'],
                        'terminal_id': order['terminalId'],
                      }),
                    );

                    if (confirm['order_status'] == 'paid') {
                      await _confirmParkingAfterReload();

                      if (!context.mounted) return;

                      Navigator.pushNamed(
                        context,
                        AppRoute.reloadReceiptScreen,
                        arguments: {
                          'locationDetail': widget.details,
                          'userModel': widget.userModel,
                          'amount':
                              double.parse(confirm['order_amount'].toString()),
                        },
                      );
                    } else {
                      _showError(context, 'Reload failed');
                    }
                  } else {
                    _showError(context, 'QR Payment not successful');
                  }
                }
              } catch (e) {
                _showError(context, 'Something went wrong');
              } finally {
                LoadingDialog.hide(context);
              }
            },
            onFailure: (context, state) {
              LoadingDialog.hide(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failureResponse!),
                ),
              );
            },
            child: Scaffold(
              backgroundColor: kBackgroundColor,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_outlined),
                  onPressed: () {
                    Navigator.pop(context, widget.userModel);
                  },
                ),
                title: Text(
                  AppLocalizations.of(context)!.reload,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: PrimaryButton(
                buttonWidth: 0.9,
                borderRadius: 10.0,
                onPressed: () {
                  formBloc.token.validate();

                  final value = formBloc.token.value;

                  if (value == null || value.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please select or enter amount')),
                    );
                    return;
                  }

                  Navigator.pushNamed(
                    context,
                    AppRoute.reloadPaymentScreen,
                    arguments: {
                      'locationDetail': widget.details,
                      'userModel': widget.userModel,
                      'formBloc': formBloc,
                    },
                  );
                },
                label: Text(
                  AppLocalizations.of(context)!.confirm,
                  style: textStyleNormal(
                    color: kWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.18,
                      child: GridView.count(
                        crossAxisCount: 3, // 3 columns
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2,
                        children: [
                          _buildGridItem('RM 10.00'),
                          _buildGridItem('RM 20.00'),
                          _buildGridItem('RM 30.00'),
                          _buildGridItem('RM 40.00'),
                          _buildGridItem('RM 50.00'),
                          _buildGridItem(AppLocalizations.of(context)!.other),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isOtherValue,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BlocBuilder<ReloadFormBloc,
                          FormBlocState<String, String>>(
                        bloc: formBloc,
                        builder: (context, state) {
                          return TextFieldBlocBuilder(
                            textFieldBloc: formBloc.other,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              if (isOtherValue) {
                                formBloc.token.updateValue(value);
                                formBloc.amount.updateValue(value);
                              }
                            },
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.amount,
                              hintText:
                                  '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.amount}',
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              prefixText: 'RM ',
                              prefixStyle: textStyleNormal(),
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
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: BlocBuilder<ReloadFormBloc,
                        FormBlocState<String, String>>(
                      bloc: formBloc,
                      builder: (context, state) {
                        return TextFieldBlocBuilder(
                          readOnly: true,
                          textFieldBloc: formBloc.token,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.token,
                            prefixStyle: textStyleNormal(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridItem(String label) {
    bool isHighlighted = _selectedLabel == label;

    return ScaleTap(
      onPressed: () {
        setState(() {
          _selectedLabel = label;

          if (label != AppLocalizations.of(context)!.other) {
            // Update token with value from label
            formBloc.token.updateValue(label.replaceAll('RM ', ''));
            formBloc.other.updateValue(label.replaceAll('RM ', ''));
            formBloc.amount.updateValue(label.replaceAll('RM ', ''));
            // Hide the 'Other' field if another option is selected
            isOtherValue = false;
          } else {
            formBloc.other.clear();
            formBloc.token.clear();
            formBloc.amount.clear();
            // Show the 'Other' field
            isOtherValue = true;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isHighlighted ? kPrimaryColor : kWhite,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: textStyleNormal(
            fontSize: 16,
            color: isHighlighted ? kWhite : kBlack,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
