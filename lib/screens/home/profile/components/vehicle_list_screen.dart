import 'package:flutter/material.dart';
import 'package:project/models/models.dart';
import 'package:project/widget/loading_dialog.dart';

Future<void> vehicleList(BuildContext context, UserModel userModel) {
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    builder: (BuildContext context) {
      return const LoadingDialog();
    },
  );
}
