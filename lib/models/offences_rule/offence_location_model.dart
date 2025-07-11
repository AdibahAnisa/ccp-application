class OffenceLocationModel {
  String? areaID;
  String? description;
  String? id;

  OffenceLocationModel({this.areaID, this.description, this.id});

  OffenceLocationModel.fromJson(Map<String, dynamic> json) {
    areaID = json['AreaID'];
    description = json['Name'];
    id = json['ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AreaID'] = areaID;
    data['Name'] = description;
    data['ID'] = id;
    return data;
  }
}
