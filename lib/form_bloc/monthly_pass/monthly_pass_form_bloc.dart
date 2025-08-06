import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';

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

  final paymentMethod = SelectFieldBloc(
    items: ['QR', 'FPX'],
    validators: [
      InputValidator.required,
    ],
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

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    emitSuccess();
  }
}
