import 'package:flutter/material.dart';
import 'package:project/models/models.dart';
import 'package:project/widget/loading_dialog.dart';

Future<void> displayEmailPassword(
    BuildContext context, UserModel userModel, Map<String, dynamic> details) {
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    builder: (BuildContext context) {
      return const LoadingDialog();
    },
  );
}
