import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/models/models.dart';

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
  })  : pbt = SelectFieldBloc(
          items: pbtModel.map((pbt) => pbt.name).toList(),
        ),
        offenceAreas = SelectFieldBloc(
          items: offenceAreasModel,
          validators: [
            (value) => value == '' ? 'Please select an area.' : null,
          ],
        ),
        offenceLocation = SelectFieldBloc(
          items: [], // initially empty
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
        stateCountry = SelectFieldBloc(
          items: ['Kelantan', 'Terengganu', 'Pahang'],
        ),
        amount = TextFieldBloc(),
        expiredAt = TextFieldBloc(),
        noReceipt = TextFieldBloc() {
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
      ],
    );
    offenceAreas.onValueChanges(
      onData: (previous, current) async* {
        final selectedArea = current.value;

        if (selectedArea != null) {
          // Filter locations where AreaID matches selectedArea.ID
          final filteredLocations = offenceLocationModel
              .where((loc) => loc.areaID == selectedArea.id)
              .toList();

          // Update the location dropdown options
          offenceLocation.updateItems(filteredLocations);
        }
      },
    );
  }

  @override
  FutureOr<void> onSubmitting() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    try {
      emitSuccess(successResponse: 'Payment Parking Successful!');
    } catch (e) {
      emitFailure(failureResponse: 'An error occurred: ${e.toString()}');
      // Log for debugging
    }
  }
}
