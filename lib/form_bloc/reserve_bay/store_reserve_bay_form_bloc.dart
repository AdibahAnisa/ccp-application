// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';

class StoreReserveBayFormBloc extends FormBloc<String, String> {
  final ReserveBayModel model = ReserveBayModel();

  // Step 0: Company Info
  final companyName = TextFieldBloc(validators: [InputValidator.required]);
  final ssm = TextFieldBloc(validators: [InputValidator.required]);
  final businessType = SelectFieldBloc(
    items: [
      'Klinik Swasta',
      'Agensi Kerajaan',
      'Bank / Institusi Kewangan',
      'Kilang',
      'Kedai Membaiki Kenderaan / Motorsikal',
      'Industri Kecil / Sederhana',
      'Hotel Bajet',
      'Lain - Lain',
    ],
    validators: [InputValidator.required],
  );
  final address1 = TextFieldBloc(validators: [InputValidator.required]);
  final address2 = TextFieldBloc(validators: [InputValidator.required]);
  final address3 = TextFieldBloc(validators: [InputValidator.required]);
  final postcode = TextFieldBloc(validators: [InputValidator.required]);
  final city = TextFieldBloc(validators: [InputValidator.required]);
  final states = TextFieldBloc(validators: [InputValidator.required]);

  // Step 1: PIC & Reservation Details
  final picFirstName = TextFieldBloc(validators: [InputValidator.required]);
  final picsecondName = TextFieldBloc(validators: [InputValidator.required]);
  final phoneNumber = TextFieldBloc(validators: [InputValidator.required]);
  final email = TextFieldBloc(
      validators: [InputValidator.required, InputValidator.emailChar]);
  final idNumber = TextFieldBloc(validators: [InputValidator.required]);
  final totalLot = SelectFieldBloc(
    items: ['3 Bulan: RM 300', '6 Bulan: RM 600', '12 Bulan: RM 1,200'],
    validators: [InputValidator.required],
  );
  final reason = TextFieldBloc(validators: [InputValidator.required]);
  final lotNumber = TextFieldBloc(validators: [InputValidator.required]);
  final location = TextFieldBloc(validators: [InputValidator.required]);

  // Step 2: File Uploads
  final designatedBay = TextFieldBloc(initialValue: 'empty');
  final designatedBayName =
      TextFieldBloc(validators: [InputValidator.required]);
  final certificate = TextFieldBloc(initialValue: 'empty');
  final certificateName = TextFieldBloc(validators: [InputValidator.required]);
  final idCard = TextFieldBloc(initialValue: 'empty');
  final idCardName = TextFieldBloc(validators: [InputValidator.required]);

  // Step 3: Terms & Conditions
  final tnc = BooleanFieldBloc(
      initialValue: false, validators: [InputValidator.required]);

  StoreReserveBayFormBloc() {
    // Assign fields to steps
    addFieldBlocs(step: 0, fieldBlocs: [
      companyName,
      ssm,
      businessType,
      address1,
      address2,
      address3,
      postcode,
      city,
      states
    ]);
    addFieldBlocs(step: 1, fieldBlocs: [
      picFirstName,
      picsecondName,
      phoneNumber,
      email,
      idNumber,
      totalLot,
      reason,
      lotNumber,
      location
    ]);
    addFieldBlocs(step: 2, fieldBlocs: [
      designatedBay,
      designatedBayName,
      certificate,
      certificateName,
      idCard,
      idCardName
    ]);
    addFieldBlocs(step: 3, fieldBlocs: [tnc]);
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      if (state.currentStep == 0) {
        // Step 0: Company Info
        model.companyName = companyName.value;
        model.companyRegistration = ssm.value;
        model.businessType = businessType.value;
        model.address1 = address1.value;
        model.address2 = address2.value;
        model.address3 = address3.value;
        model.postcode = postcode.value;
        model.city = city.value;
        model.state = states.value;

        emitSuccess();
      } else if (state.currentStep == 1) {
        // Step 1: PIC & Reservation Details
        model.picFirstName = picFirstName.value;
        model.picsecondName = picsecondName.value;
        model.phoneNumber = phoneNumber.value;
        model.email = email.value;
        model.idNumber = idNumber.value;

        if (totalLot.value == "3 Bulan: RM 300") {
          model.totalLotRequired = 300;
        } else if (totalLot.value == "6 Bulan: RM 600") {
          model.totalLotRequired = 600;
        } else {
          model.totalLotRequired = 1200;
        }

        model.lotNumber = lotNumber.value;
        model.reason = reason.value;
        model.location = location.value;

        emitSuccess();
      } else if (state.currentStep == 2) {
        // Step 2: File Uploads
        model.designatedBayPicture = designatedBay.value;
        model.registerNumberPicture = certificate.value;
        model.idCardPicture = idCard.value;

        emitSuccess();
      } else if (state.currentStep == 3) {
        // Step 3: Final Submission to API
        final response = await ReserveBayResources.createReserveBay(
          prefix: '/reservebay/create',
          body: jsonEncode({
            'companyName': model.companyName,
            'companyRegistration': model.companyRegistration,
            'businessType': model.businessType,
            'address1': model.address1,
            'address2': model.address2,
            'address3': model.address3,
            'postcode': model.postcode,
            'city': model.city,
            'state': model.state,
            'picFirstName': model.picFirstName,
            'picsecondName': model.picsecondName,
            'phoneNumber': model.phoneNumber,
            'email': model.email,
            'idNumber': model.idNumber,
            'totalLotRequired': model.totalLotRequired,
            'reason': model.reason,
            'lotNumber': model.lotNumber,
            'location': model.location,
            'designatedBayPicture': model.designatedBayPicture,
            'registerNumberPicture': model.registerNumberPicture,
            'idCardPicture': model.idCardPicture,
          }),
        );

        if (response['error'] != null) {
          emitFailure(failureResponse: response['error'].toString());
        } else {
          emitSuccess(
              successResponse: 'Reserve Bay Request Successfully Submitted');
        }
      }
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }
}
