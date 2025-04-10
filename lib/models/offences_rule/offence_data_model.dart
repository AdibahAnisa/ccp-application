import 'package:project/models/models.dart';

class OffenceDataModel {
  final List<OffenceAreasModel> areas;
  final List<OffenceLocationModel> locations;

  OffenceDataModel({
    required this.areas,
    required this.locations,
  });
}
