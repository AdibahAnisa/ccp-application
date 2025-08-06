// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';

class StoreReserveBayFormBloc extends FormBloc<String, String> {
  final ReserveBayModel model = ReserveBayModel();
  final companyName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final ssm = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

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
    validators: [
      InputValidator.required,
    ],
  );

  final address1 = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final address2 = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final address3 = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final postcode = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final city = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final states = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final picFirstName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final picLastName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final phoneNumber = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final email = TextFieldBloc(
    validators: [
      InputValidator.required,
      InputValidator.emailChar,
    ],
  );

  final idNumber = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final totalLot = SelectFieldBloc(
    items: [
      '3 Bulan: RM 300',
      '6 Bulan: RM 600',
      '6 Bulan: RM 600',
      '12 Bulan: RM 1,200',
    ],
    validators: [
      InputValidator.required,
    ],
  );

  final reason = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final lotNumber = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final location = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final designatedBay = TextFieldBloc(
    initialValue: 'empty',
  );

  final designatedBayName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final certificate = TextFieldBloc(
    initialValue: 'empty',
  );

  final certificateName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final idCard = TextFieldBloc(
    initialValue: 'empty',
  );

  final idCardName = TextFieldBloc(
    validators: [
      InputValidator.required,
    ],
  );

  final tnc = BooleanFieldBloc(initialValue: false, validators: [
    InputValidator.required,
  ]);

  StoreReserveBayFormBloc() {
    addFieldBlocs(
      step: 0,
      fieldBlocs: [
        companyName,
        ssm,
        businessType,
        address1,
        address2,
        address3,
        postcode,
        city,
        states,
      ],
    );

    addFieldBlocs(
      step: 1,
      fieldBlocs: [
        picFirstName,
        picLastName,
        phoneNumber,
        email,
        idNumber,
        totalLot,
        reason,
        lotNumber,
        location,
      ],
    );

    addFieldBlocs(
      step: 2,
      fieldBlocs: [
        designatedBay,
        designatedBayName,
        certificate,
        certificateName,
        idCard,
        idCardName,
      ],
    );

    addFieldBlocs(
      step: 3,
      fieldBlocs: [
        tnc,
      ],
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    emitSuccess(successResponse: 'Reserve Bay Request Successfully Submitted');
  }
}
