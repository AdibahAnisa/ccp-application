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

class VehicleListScreen extends StatelessWidget {
  final UserModel userModel;

  const VehicleListScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context, userModel);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.listOfVehicle,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              /// VEHICLE LIST CONTAINER

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kGrey.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: userModel.plateNumbers == null ||
                        userModel.plateNumbers!.isEmpty
                    ? Center(
                        child: Text(
                          "No vehicles added",
                          style: textStyleNormal(color: kGrey),
                        ),
                      )
                    : Column(
                        children: userModel.plateNumbers!
                            .asMap()
                            .entries
                            .map(
                              (entry) => _buildPlateRow(
                                context,
                                entry.key,
                                entry.value,
                              ),
                            )
                            .toList(),
                      ),
              ),

              //ADD VEHICLE BUTTON
              const Spacer(),

              _buildAddVehicleButton(context, userModel),
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
          margin: const EdgeInsets.only(top: 10),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 24), // spacer to center title
            Text(
              AppLocalizations.of(context)!.addVehicle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlateRow(
      BuildContext context, int index, PlateNumberModel plate) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
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
                    style: textStyleNormal(
                        fontWeight: FontWeight.bold, fontSize: 12),
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
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: kBlack,
                      ),
                      onPressed: userModel.plateNumbers!.length > 1
                          ? () => _showDeleteConfirmationDialog(context, plate)
                          : null,
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddVehicleButton(BuildContext context, UserModel userModel) {
    return PrimaryButton(
      borderRadius: 5,
      buttonWidth: 1,
      color: kPrimaryColor,
      label: Text(
        AppLocalizations.of(context)!.addVehicle,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        if (userModel.plateNumbers != null) {
          if (userModel.plateNumbers!.length >= 3) {
            _showErrorDialog(
              context,
              AppLocalizations.of(context)!.error,
              AppLocalizations.of(context)!.errorDesc,
            );
          } else {
            _showAddVehicleDialog(context, userModel);
          }
        } else {
          _showAddVehicleDialog(context, userModel);
        }
      },
    );
  }

  Widget _buildDefaultLabel() {
    return Container(
      width: 100,
      height: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kGrey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Text(
        "Default",
        style: textStyleNormal(
          color: Colors.grey.shade700,
          fontSize: 10,
        ),
      ),
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
    final response = await AuthResources.deleteCarPlate(
        prefix: '/carplatenumber/delete/$id');
    if (response['error'] != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['error'].toString())));
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoute.homeScreen, (_) => false);
      await Future.delayed(const Duration(seconds: 1));
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'].toString())));
    }
  }

  Future<void> updatePlate(BuildContext context, String id) async {
    final response = await AuthResources.updateCarPlate(
      prefix: '/carplatenumber/update/$id',
      body: {'isMain': true},
    );
    if (response['error'] != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['error'].toString())));
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoute.homeScreen, (_) => false);
      await Future.delayed(const Duration(seconds: 1));
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'].toString())));
    }
  }

// ADD VEHICLE DIALOG
  Future<void> _showAddVehicleDialog(
      BuildContext context, UserModel userModel) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => BlocProvider(
        create: (_) => StoreVehicleFormBloc(),
        child: Builder(builder: (context) {
          final formBloc = context.read<StoreVehicleFormBloc>();
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: FormBlocListener<StoreVehicleFormBloc, String, String>(
              onSubmitting: (context, state) => LoadingDialog.show(context),
              onSubmissionFailed: (context, state) =>
                  LoadingDialog.hide(context),
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
                      const SizedBox(height: 30),
                      //ADD VEHICLE BUTTON
                      PrimaryButton(
                        borderRadius: 5,
                        buttonWidth: 1,
                        color: kPrimaryColor,
                        label: const Text(
                          'Add Vehicle',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: formBloc.submit,
                      ),
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
}
