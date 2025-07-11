class OffenceAreasModel {
  String? description;
  String? id;

  OffenceAreasModel({this.description, this.id});

  OffenceAreasModel.fromJson(Map<String, dynamic> json) {
    description = json['Name'];
    id = json['ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = description;
    data['ID'] = id;
    return data;
  }
}
