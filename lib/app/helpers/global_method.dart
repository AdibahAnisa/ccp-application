import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
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
    prefix: '/VistaParkingWebService/HandheldService.svc/RegisterDevice/$deviceId',
  );

  if (response != null && response['HandheldCode'] != null) {
    final handheldCode = response['HandheldCode'];

    final lookupResponse = await ParkingResources.getDownloadLookupTable(
      prefix: '/VistaParkingWebService/HandheldService.svc/DownloadLookupTable/$handheldCode',
    );

    List<OffenceAreasModel> areas = [];
    List<OffenceLocationModel> locations = [];

    if (lookupResponse != null) {
      if (lookupResponse['OffenceAreas'] is List) {
        areas = (lookupResponse['OffenceAreas'] as List)
            .map((e) => OffenceAreasModel.fromJson(e))
            .toList();
      }

      if (lookupResponse['OffenceLocations'] is List) {
        locations = (lookupResponse['OffenceLocations'] as List)
            .map((e) => OffenceLocationModel.fromJson(e))
            .toList();
      }
    }

    return OffenceDataModel(areas: areas, locations: locations);
  }

  return OffenceDataModel(areas: [], locations: []);
}
