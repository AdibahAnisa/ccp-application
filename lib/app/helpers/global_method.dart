import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/models/models.dart';
import 'package:project/models/offences_rule/offence_data_model.dart';

Future<OffenceDataModel> fetchOffenceAreasList() async {
  final deviceInfo = DeviceInfoPlugin();
  String? deviceId;

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor;
  }

  if (deviceId == null) {
    return OffenceDataModel(areas: [], locations: []);
  }

  return OffenceDataModel(areas: [], locations: []);
}
