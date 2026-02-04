import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/models/models.dart';
import 'package:project/models/offences_rule/offence_data_model.dart';
import 'package:project/resources/resources.dart';

Future<OffenceDataModel> fetchOffenceAreasList() async {
  final deviceInfo = DeviceInfoPlugin();
  String? deviceId;

  // Get device ID based on platform
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

  // Fetch registered device info from API
  final response = await ParkingResources.getRegisterDevices(
    prefix: '/compound/register/$deviceId',
  );

  if (response == null || response['handheldCode'] == null) {
    return OffenceDataModel(areas: [], locations: []);
  }

  final handheldCode = response['handheldCode'];

  // Save handheldCode to SharedPreferences
  await SharedPreferencesHelper.saveHandheldId(handheldCode);

  // Fetch lookup tables for areas and locations
  final lookupResponseAreas = await ParkingResources.getDownloadLookupTable(
    prefix: '/list/area',
  );
  final lookupResponseLocations = await ParkingResources.getDownloadLookupTable(
    prefix: '/list/location',
  );

  // Convert API response to models
  List<OffenceAreasModel> areas = [];
  if (lookupResponseAreas != null && lookupResponseAreas['data'] is List) {
    areas = (lookupResponseAreas['data'] as List)
        .map((e) => OffenceAreasModel.fromJson(e))
        .toList();
  }

  List<OffenceLocationModel> locations = [];
  if (lookupResponseLocations != null &&
      lookupResponseLocations['data'] is List) {
    locations = (lookupResponseLocations['data'] as List)
        .map((e) => OffenceLocationModel.fromJson(e))
        .toList();
  }

  return OffenceDataModel(areas: areas, locations: locations);
}
