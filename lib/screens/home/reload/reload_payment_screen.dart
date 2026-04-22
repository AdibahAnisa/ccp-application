import 'dart:async';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ntp/ntp.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/custom_dialog.dart';
import 'package:project/widget/primary_button.dart';

class ReloadPaymentScreen extends StatefulWidget {
  const ReloadPaymentScreen({super.key});

  @override
  State<ReloadPaymentScreen> createState() => _ReloadPaymentScreenState();
}

class _ReloadPaymentScreenState extends State<ReloadPaymentScreen> {
  String _currentDate = ''; // Initialize variable for date
  String _currentTime = '';
  // ignore: unused_field
  String? _qrCodeUrl;
  String? shortcutLink;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => updateDateTime());
  }

  void updateDateTime() async {
    try {
      DateTime liveTime = await NTP.now(timeout: const Duration(seconds: 5));
      setState(() {
        _currentDate = liveTime.toString().split(' ')[0]; // Get current date
        _currentTime = DateFormat('h:mm a').format(liveTime);
      });
    } catch (e) {
      // Fallback to local time in case of an error
      DateTime fallbackTime = DateTime.now();
      _currentDate = fallbackTime.toString().split(' ')[0]; // Get current date
      _currentTime = DateFormat('h:mm a').format(fallbackTime);
    }
  }

  void _showQRInstruction(BuildContext context, ReloadFormBloc formBloc) {
    CustomDialog.show(
      context,
      dialogType: DialogType.info,
      title: AppLocalizations.of(context)!.qrPaymentTitle,
      description: AppLocalizations.of(context)!.qrPaymentInstructions,
      btnOkOnPress: () async {
        await SharedPreferencesHelper.setTime(
          startTime: _currentTime,
          endTime: '',
        );

        formBloc.submit();
        Navigator.pop(context);
      },
      btnOkText: AppLocalizations.of(context)!.continueBtn,
      btnCancelOnPress: () => Navigator.pop(context),
      btnCancelText: AppLocalizations.of(context)!.cancel,
    );
  }

  void _showFPXConfirm(BuildContext context, ReloadFormBloc formBloc) {
    CustomDialog.show(
      context,
      dialogType: DialogType.danger,
      title: AppLocalizations.of(context)!.confirmPayment,
      description: AppLocalizations.of(context)!.confirmPaymentDesc,
      btnOkOnPress: () async {
        await SharedPreferencesHelper.setTime(
          startTime: _currentTime,
          endTime: '',
        );

        formBloc.submit();
        Navigator.pop(context);
      },
      btnOkText: AppLocalizations.of(context)!.yes,
      btnCancelOnPress: () => Navigator.pop(context),
      btnCancelText: AppLocalizations.of(context)!.no,
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    Map<String, dynamic> details =
        arguments['locationDetail'] as Map<String, dynamic>;
    UserModel? userModel = arguments['userModel'] as UserModel?;
    ReloadFormBloc? formBloc = arguments['formBloc'] as ReloadFormBloc;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context, userModel);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.payment,
          style: const TextStyle(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: PrimaryButton(
        borderRadius: 10.0,
        buttonWidth: 0.9,
        onPressed: () {
          final method = formBloc.paymentMethod.value;

          if (method == "QR") {
            _showQRInstruction(context, formBloc);
          } else if (method == "FPX") {
            _showFPXConfirm(context, formBloc);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(AppLocalizations.of(context)!.selectPaymentMethod)),
            );
          }
        },
        label: Text(
          AppLocalizations.of(context)!.pay,
          style: textStyleNormal(color: kWhite, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildRow(AppLocalizations.of(context)!.name2,
                  '${userModel!.firstName} ${userModel.secondName}'),
              buildRow(AppLocalizations.of(context)!.date2, _currentDate),
              buildRow(AppLocalizations.of(context)!.time2, _currentTime),
              buildRow(
                  AppLocalizations.of(context)!.email2, userModel.email ?? ''),
              buildRow(
                  AppLocalizations.of(context)!.description2, "Reload Token"),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 5),
              buildRow(
                AppLocalizations.of(context)!.total2,
                'RM ${double.parse(formBloc.amount.value).toStringAsFixed(2)}',
              ),
              const SizedBox(height: 25),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.paymentDesc,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                AppLocalizations.of(context)!.paymentMethod,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  _paymentCard("QR", "assets/images/duitnow.png", formBloc),
                  const SizedBox(width: 12),
                  _paymentCard("FPX", "assets/images/fpx.png", formBloc),
                ],
              ),
              // Align(
              //   alignment: Alignment.centerLeft, // 👈 force left
              //   child: SizedBox(
              //     height: 150,
              //     child: RadioButtonGroupFieldBlocBuilder<String>(
              //       padding: EdgeInsets.zero,
              //       canTapItemTile: true,
              //       groupStyle: const FlexGroupStyle(
              //         direction: Axis.horizontal,
              //       ),
              //       selectFieldBloc: formBloc.paymentMethod,
              //       decoration: InputDecoration(
              //         labelText: AppLocalizations.of(context)!.paymentMethod,
              //         labelStyle: textStyleNormal(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 22,
              //         ),
              //       ),
              //       itemBuilder: (context, item) {
              //         bool isSelected = formBloc.paymentMethod.value == item;
              //         return FieldItem(
              //           child: GestureDetector(
              //             onTap: () => formBloc.paymentMethod.updateValue(item),
              //             child: Container(
              //               width: item == 'QR' ? 80 : 120,
              //               height: 80,
              //               decoration: BoxDecoration(
              //                 color: isSelected
              //                     ? Colors.blue.withOpacity(0.2)
              //                     : Colors.transparent,
              //                 border: isSelected
              //                     ? Border.all(color: Colors.blue, width: 2)
              //                     : null,
              //                 image: DecorationImage(
              //                   image: AssetImage(
              //                     item == 'QR'
              //                         ? 'assets/images/duitnow.png'
              //                         : 'assets/images/fpx.png',
              //                   ),
              //                   fit: BoxFit.contain,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50, // light red background
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.red.shade200, // soft border color
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.importantNoticeTitle,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.reloadRedirectNotice,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.red.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
      ],
    ),
  );
}

Widget _paymentCard(String type, String imagePath, ReloadFormBloc formBloc) {
  bool isSelected = formBloc.paymentMethod.value == type;

  return Expanded(
    child: GestureDetector(
      onTap: () => formBloc.paymentMethod.updateValue(type),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            height: 80,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
  );
}
