import 'package:flutter/material.dart';
import 'package:project/models/models.dart';
import 'package:project/widget/loading_dialog.dart';

Future<void> helpCenter(BuildContext context, List<PBTModel> pbtModel) async {
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return const LoadingDialog();
    },
  );
}
