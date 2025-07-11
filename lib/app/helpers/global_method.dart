import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/models/models.dart';
import 'package:project/models/offences_rule/offence_data_model.dart';
import 'package:project/resources/resources.dart';

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

  final response = await ParkingResources.getRegisterDevices(
    prefix: '/compound/register/$deviceId',
  );

  if (response != null && response['handheldCode'] != null) {
    final handheldCode = response['handheldCode'];

    final lookupResponseAreas = await ParkingResources.getDownloadLookupTable(
      prefix: '/list/area',
    );

    final lookupResponseLocations =
        await ParkingResources.getDownloadLookupTable(
      prefix: '/list/location',
    );

    await SharedPreferencesHelper.saveHandheldId(handheldCode);

    List<OffenceAreasModel> areas = [];
    List<OffenceLocationModel> locations = [];

    {
      if (lookupResponseAreas['data'] is List) {
        areas = (lookupResponseAreas['data'] as List)
            .map((e) => OffenceAreasModel.fromJson(e))
            .toList();
      }
    }

    if (lookupResponseLocations != null) {
      if (lookupResponseLocations['data'] is List) {
        locations = (lookupResponseLocations['data'] as List)
            .map((e) => OffenceLocationModel.fromJson(e))
            .toList();
      }
    }

    return OffenceDataModel(areas: areas, locations: locations);
  }

  return OffenceDataModel(areas: [], locations: []);
}
