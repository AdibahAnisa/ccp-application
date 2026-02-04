import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/resources.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';

Future<void> vehicleList(BuildContext context, UserModel userModel) {
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    builder: (_) => SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, AppLocalizations.of(context)!.listOfVehicle),
            const SizedBox(height: 20),
            if (userModel.plateNumbers != null)
              ...userModel.plateNumbers!.asMap().entries.map(
                    (entry) => _buildPlateRow(context, entry.key, entry.value),
                  ),
            const SizedBox(height: 50),
            Center(child: _buildAddVehicleButton(context, userModel)),
            const SizedBox(height: 20),
            Center(child: _buildCloseButton(context)),
            const SizedBox(height: 50),
          ],
        ),
      ),
    ),
  );
}

Widget _buildHeader(BuildContext context, String title) {
  return Column(
    children: [
      Container(
        width: 100,
        child: const Divider(color: kGrey, thickness: 3),
      ),
      const SizedBox(height: 10),
      Center(
        child: Text(
          title,
          style: textStyleNormal(
              fontSize: 28, fontWeight: FontWeight.bold, color: kBlack),
        ),
      ),
    ],
  );
}

Widget _buildPlateRow(BuildContext context, int index, PlateNumberModel plate) {
  return Column(
    children: [
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${AppLocalizations.of(context)!.carPlate} ${index + 1}',
                style:
                    textStyleNormal(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 5),
              Text(
                plate.plateNumber ?? '',
                style: textStyleNormal(fontSize: 15),
              ),
            ],
          ),
          Row(
            children: [
              plate.isMain == true
                  ? _buildDefaultLabel()
                  : PrimaryButton(
                      label: Text(
                        AppLocalizations.of(context)!.setAsMain,
                        style: textStyleNormal(color: kWhite, fontSize: 8),
                      ),
                      borderRadius: 10.0,
                      buttonWidth: 0.3,
                      onPressed: () => updatePlate(context, plate.id!),
                    ),
              if (plate.plateNumber != null)
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: plate.plateNumber != null
                      ? () => _showDeleteConfirmationDialog(context, plate)
                      : null,
                ),
            ],
          ),
        ],
      ),
    ],
  );
}

Widget _buildDefaultLabel() {
  return Container(
    width: 120,
    height: 20,
    padding: const EdgeInsets.only(top: 3.0),
    decoration: BoxDecoration(
      color: kGrey.withOpacity(0.3),
      borderRadius: BorderRadius.circular(30.0),
      border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
    ),
    child: Center(
      child: Text(
        "Default",
        style: textStyleNormal(color: kWhite, fontSize: 8),
      ),
    ),
  );
}

Widget _buildAddVehicleButton(BuildContext context, UserModel userModel) {
  return PrimaryButton(
    icon: const Icon(Icons.add, color: kWhite),
    label: Text(
      AppLocalizations.of(context)!.addVehicle,
      style: textStyleNormal(
          color: kWhite, fontWeight: FontWeight.bold, fontSize: 12),
    ),
    borderRadius: 20.0,
    onPressed: () {
      if (userModel.plateNumbers != null &&
          userModel.plateNumbers!.length >= 2) {
        _showErrorDialog(context, AppLocalizations.of(context)!.error,
            AppLocalizations.of(context)!.errorDesc);
      } else {
        _showAddVehicleDialog(context, userModel);
      }
    },
  );
}

Widget _buildCloseButton(BuildContext context) {
  return PrimaryButton(
    color: kRed,
    label: Text(
      AppLocalizations.of(context)!.close,
      style: textStyleNormal(color: kWhite, fontWeight: FontWeight.bold),
    ),
    borderRadius: 20.0,
    onPressed: () => Navigator.pop(context),
  );
}

Future<void> _showErrorDialog(
    BuildContext context, String title, String message) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('OK')),
      ],
    ),
  );
}

Future<void> _showDeleteConfirmationDialog(
    BuildContext context, PlateNumberModel plate) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.confirmDeletion),
      content: Text(
          '${AppLocalizations.of(context)!.confirmDeletionDesc} ${plate.plateNumber}?'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel)),
        TextButton(
            onPressed: () => deleteplate(context, plate.id!),
            child: Text(AppLocalizations.of(context)!.confirm)),
      ],
    ),
  );
}

// --- API Calls ---
Future<void> deleteplate(BuildContext context, String id) async {
  final response =
      await AuthResources.deleteCarPlate(prefix: '/carplatenumber/delete/$id');
  if (response['error'] != null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response['error'].toString())));
  } else {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoute.homeScreen, (_) => false);
    await Future.delayed(const Duration(seconds: 1));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response['message'].toString())));
  }
}

Future<void> updatePlate(BuildContext context, String id) async {
  final response = await AuthResources.updateCarPlate(
    prefix: '/carplatenumber/update/$id',
    body: jsonEncode({'isMain': true}),
  );
  if (response['error'] != null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response['error'].toString())));
  } else {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoute.homeScreen, (_) => false);
    await Future.delayed(const Duration(seconds: 1));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response['message'].toString())));
  }
}

// --- Add Vehicle Dialog ---
Future<void> _showAddVehicleDialog(BuildContext context, UserModel userModel) {
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    builder: (_) => BlocProvider(
      create: (_) => StoreVehicleFormBloc(),
      child: Builder(builder: (context) {
        final formBloc = context.read<StoreVehicleFormBloc>();
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FormBlocListener<StoreVehicleFormBloc, String, String>(
            onSubmitting: (context, state) => LoadingDialog.show(context),
            onSubmissionFailed: (context, state) => LoadingDialog.hide(context),
            onSuccess: (context, state) {
              LoadingDialog.hide(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoute.homeScreen, (_) => false);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.successResponse!)));
            },
            onFailure: (context, state) {
              LoadingDialog.hide(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.failureResponse!)));
            },
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 20.0),
                child: Column(
                  children: [
                    _buildHeader(
                        context, AppLocalizations.of(context)!.addVehicle),
                    const SizedBox(height: 10),
                    TextFieldBlocBuilder(
                      textFieldBloc: formBloc.plateNumber,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp("[a-zA-Z0-9]")),
                        UpperCaseTextFormatter(),
                      ],
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context)!.vehicleNo),
                        hintText:
                            '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.vehicleNo}',
                        hintStyle: const TextStyle(color: Colors.black26),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        PrimaryButton(
                          color: kRed,
                          buttonWidth: 0.4,
                          label: Text(AppLocalizations.of(context)!.cancel,
                              style: textStyleNormal(color: kWhite)),
                          borderRadius: 20.0,
                          onPressed: () => Navigator.pop(context),
                        ),
                        PrimaryButton(
                          buttonWidth: 0.4,
                          icon: const Icon(Icons.add, color: kWhite),
                          label: Text(AppLocalizations.of(context)!.add,
                              style: textStyleNormal(color: kWhite)),
                          borderRadius: 20.0,
                          onPressed: formBloc.submit,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    ),
  );
}
