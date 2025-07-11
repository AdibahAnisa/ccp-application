import 'package:project/models/models.dart';

class OffenceSectionModel {
  String? iD;
  String? actID;
  int? code;
  String? sectionNo;
  String? subSectionNo;
  String? description;
  int? zone1;
  int? zone2;
  int? zone3;
  int? zone4;
  int? smallAmount1;
  int? smallAmount2;
  int? smallAmount3;
  int? smallAmount4;
  int? amount1;
  int? amount2;
  int? amount3;
  int? amount4;
  String? desc1;
  String? desc2;
  String? desc3;
  String? desc4;
  int? maxAmount;
  String? resultCode;
  bool? isDeleted;
  String? createdBy;
  String? updatedBy;
  String? createdDate;
  String? updatedDate;
  OffenceActModel? act;

  OffenceSectionModel(
      {this.iD,
      this.actID,
      this.code,
      this.sectionNo,
      this.subSectionNo,
      this.description,
      this.zone1,
      this.zone2,
      this.zone3,
      this.zone4,
      this.smallAmount1,
      this.smallAmount2,
      this.smallAmount3,
      this.smallAmount4,
      this.amount1,
      this.amount2,
      this.amount3,
      this.amount4,
      this.desc1,
      this.desc2,
      this.desc3,
      this.desc4,
      this.maxAmount,
      this.resultCode,
      this.isDeleted,
      this.createdBy,
      this.updatedBy,
      this.createdDate,
      this.updatedDate,
      this.act});

  OffenceSectionModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    actID = json['ActID'];
    code = json['Code'];
    sectionNo = json['SectionNo'];
    subSectionNo = json['SubSectionNo'];
    description = json['Description'];
    zone1 = json['Zone1'];
    zone2 = json['Zone2'];
    zone3 = json['Zone3'];
    zone4 = json['Zone4'];
    smallAmount1 = json['SmallAmount1'];
    smallAmount2 = json['SmallAmount2'];
    smallAmount3 = json['SmallAmount3'];
    smallAmount4 = json['SmallAmount4'];
    amount1 = json['Amount1'];
    amount2 = json['Amount2'];
    amount3 = json['Amount3'];
    amount4 = json['Amount4'];
    desc1 = json['Desc1'];
    desc2 = json['Desc2'];
    desc3 = json['Desc3'];
    desc4 = json['Desc4'];
    maxAmount = json['MaxAmount'];
    resultCode = json['ResultCode'];
    isDeleted = json['IsDeleted'];
    createdBy = json['CreatedBy'];
    updatedBy = json['UpdatedBy'];
    createdDate = json['CreatedDate'];
    updatedDate = json['UpdatedDate'];
    act = json['act'] != null ? OffenceActModel.fromJson(json['act']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['ActID'] = actID;
    data['Code'] = code;
    data['SectionNo'] = sectionNo;
    data['SubSectionNo'] = subSectionNo;
    data['Description'] = description;
    data['Zone1'] = zone1;
    data['Zone2'] = zone2;
    data['Zone3'] = zone3;
    data['Zone4'] = zone4;
    data['SmallAmount1'] = smallAmount1;
    data['SmallAmount2'] = smallAmount2;
    data['SmallAmount3'] = smallAmount3;
    data['SmallAmount4'] = smallAmount4;
    data['Amount1'] = amount1;
    data['Amount2'] = amount2;
    data['Amount3'] = amount3;
    data['Amount4'] = amount4;
    data['Desc1'] = desc1;
    data['Desc2'] = desc2;
    data['Desc3'] = desc3;
    data['Desc4'] = desc4;
    data['MaxAmount'] = maxAmount;
    data['ResultCode'] = resultCode;
    data['IsDeleted'] = isDeleted;
    data['CreatedBy'] = createdBy;
    data['UpdatedBy'] = updatedBy;
    data['CreatedDate'] = createdDate;
    data['UpdatedDate'] = updatedDate;
    if (act != null) {
      data['act'] = act!.toJson();
    }
    return data;
  }
}
