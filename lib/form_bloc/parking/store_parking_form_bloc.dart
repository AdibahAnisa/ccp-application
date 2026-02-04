import 'dart:async';
import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';

class StoreParkingFormBloc extends FormBloc<String, String> {
  final List<PlateNumberModel>? platModel;
  final List<PBTModel> pbtModel;
  final List<OffenceAreasModel> offenceAreasModel;
  final List<OffenceLocationModel> offenceLocationModel;
  final Map<String, dynamic> details;

  final SelectFieldBloc<String?, dynamic> carPlateNumber;
  final SelectFieldBloc<String?, dynamic> pbt;
  final SelectFieldBloc<OffenceAreasModel?, dynamic> offenceAreas;
  final SelectFieldBloc<OffenceLocationModel?, dynamic> offenceLocation;
  final SelectFieldBloc<String?, dynamic> stateCountry;

  final TextFieldBloc amount;
  final TextFieldBloc expiredAt;
  final TextFieldBloc noReceipt;

  StoreParkingFormBloc({
    required this.platModel,
    required this.pbtModel,
    required this.offenceAreasModel,
    required this.offenceLocationModel,
    required this.details,
  })  : carPlateNumber = SelectFieldBloc(
          items: (platModel?.isNotEmpty ?? false)
              ? platModel!.map((p) => p.plateNumber).toList()
              : [],
          initialValue: platModel
                  ?.firstWhere(
                    (p) => p.isMain ?? false,
                    orElse: () => platModel!.first,
                  )
                  .plateNumber ??
              '',
        ),
        pbt = SelectFieldBloc(
          items: pbtModel.map((p) => p.name).toList(),
        ),
        offenceAreas = SelectFieldBloc(
          items: offenceAreasModel,
          validators: [
            (value) => value == null ? 'Please select an area.' : null,
          ],
        ),
        offenceLocation = SelectFieldBloc(
          items: [],
        ),
        stateCountry = SelectFieldBloc(
          items: const ['Kelantan', 'Terengganu', 'Pahang'],
        ),
        amount = TextFieldBloc(),
        expiredAt = TextFieldBloc(),
        noReceipt = TextFieldBloc() {
    /// Pre-fill values
    pbt.updateInitialValue(details['location'] ?? '');
    stateCountry.updateInitialValue(details['state'] ?? '');

    addFieldBlocs(
      fieldBlocs: [
        carPlateNumber,
        pbt,
        offenceAreas,
        offenceLocation,
        stateCountry,
        amount,
        expiredAt,
        noReceipt,
      ],
    );

    /// Cascading dropdown: Area → Location
    offenceAreas.onValueChanges(
      onData: (previous, current) async* {
        final selectedArea = current.value;
        if (selectedArea == null) return;

        final filteredLocations = offenceLocationModel
            .where((loc) => loc.areaID == selectedArea.id)
            .toList();

        offenceLocation.updateItems(filteredLocations);
      },
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      final double amountDouble = double.parse(amount.value);

      /// 1️⃣ Payment
      final paymentResponse = await ParkingResources.payment(
        prefix: '/payment/parking',
        body: jsonEncode({
          'amount': amountDouble,
        }),
      );

      if (paymentResponse['error'] != null) {
        emitFailure(
          failureResponse: paymentResponse['error'].toString(),
        );
        return;
      }

      /// 2️⃣ Create Parking
      final parkingResponse = await ParkingResources.createParking(
        prefix: '/parking/create',
        body: jsonEncode({
          'walletTransactionId':
              paymentResponse['walletTransactionid'].toString(),
          'plateNumber': carPlateNumber.value,
          'pbt': pbt.value,
          'location': stateCountry.value,
          'area': offenceAreas.value?.description ?? 'No Area',
          'state': offenceLocation.value?.description ?? 'No Location',
          'expiredAt': expiredAt.value,
          'noReceipt': noReceipt.value,
        }),
      );

      if (parkingResponse['error'] != null) {
        emitFailure(
          failureResponse: parkingResponse['error'].toString(),
        );
        return;
      }

      /// ✅ Success (emit ONCE only)
      emitSuccess(
        successResponse: 'Payment Parking Successful!',
      );
    } catch (e) {
      emitFailure(
        failureResponse: 'An error occurred: ${e.toString()}',
      );
    }
  }
}
