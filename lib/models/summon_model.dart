class SummonModel {
  int? clampingAmount;
  String? clampingPaymentDate;
  String? clampingPaymentDateString;
  String? clampingReceiptNumber;
  int? compoundAmount;
  String? handheldCode;
  String? imageName1;
  String? imageName2;
  String? imageName3;
  String? imageName4;
  String? imageName5;
  bool? isClamping;
  String? latitude;
  String? longitude;
  String? notes;
  String? noticeNo;
  String? offence;
  String? offenceAct;
  String? offenceActCode;
  String? offenceArea;
  String? offenceDate;
  String? offenceDateString;
  String? offenceLocation;
  String? offenceLocationDetails;
  String? offenceNoticeStatus;
  String? offenceSection;
  String? offenceSectionCode;
  String? officerID;
  String? officerUnit;
  int? paidClampingAmount;
  int? paidCompoundAmount;
  String? paymentDate;
  String? paymentDateString;
  String? receiptNumber;
  String? roadTaxNo;
  String? vehicleColor;
  String? vehicleMakeModel;
  String? vehicleNo;
  String? vehicleType;

  SummonModel(
      {this.clampingAmount,
      this.clampingPaymentDate,
      this.clampingPaymentDateString,
      this.clampingReceiptNumber,
      this.compoundAmount,
      this.handheldCode,
      this.imageName1,
      this.imageName2,
      this.imageName3,
      this.imageName4,
      this.imageName5,
      this.isClamping,
      this.latitude,
      this.longitude,
      this.notes,
      this.noticeNo,
      this.offence,
      this.offenceAct,
      this.offenceActCode,
      this.offenceArea,
      this.offenceDate,
      this.offenceDateString,
      this.offenceLocation,
      this.offenceLocationDetails,
      this.offenceNoticeStatus,
      this.offenceSection,
      this.offenceSectionCode,
      this.officerID,
      this.officerUnit,
      this.paidClampingAmount,
      this.paidCompoundAmount,
      this.paymentDate,
      this.paymentDateString,
      this.receiptNumber,
      this.roadTaxNo,
      this.vehicleColor,
      this.vehicleMakeModel,
      this.vehicleNo,
      this.vehicleType});

  SummonModel.fromJson(Map<String, dynamic> json) {
    clampingAmount = json['ClampingAmount'];
    clampingPaymentDate = json['ClampingPaymentDate'];
    clampingPaymentDateString = json['ClampingPaymentDateString'];
    clampingReceiptNumber = json['ClampingReceiptNumber'];
    compoundAmount = json['CompoundAmount'];
    handheldCode = json['HandheldCode'];
    imageName1 = json['ImageName1'];
    imageName2 = json['ImageName2'];
    imageName3 = json['ImageName3'];
    imageName4 = json['ImageName4'];
    imageName5 = json['ImageName5'];
    isClamping = json['IsClamping'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    notes = json['Notes'];
    noticeNo = json['NoticeNo'];
    offence = json['Offence'];
    offenceAct = json['OffenceAct'];
    offenceActCode = json['OffenceActCode'];
    offenceArea = json['OffenceArea'];
    offenceDate = json['OffenceDate'];
    offenceDateString = json['OffenceDateString'];
    offenceLocation = json['OffenceLocation'];
    offenceLocationDetails = json['OffenceLocationDetails'];
    offenceNoticeStatus = json['OffenceNoticeStatus'];
    offenceSection = json['OffenceSection'];
    offenceSectionCode = json['OffenceSectionCode'];
    officerID = json['OfficerID'];
    officerUnit = json['OfficerUnit'];
    paidClampingAmount = json['PaidClampingAmount'];
    paidCompoundAmount = json['PaidCompoundAmount'];
    paymentDate = json['PaymentDate'];
    paymentDateString = json['PaymentDateString'];
    receiptNumber = json['ReceiptNumber'];
    roadTaxNo = json['RoadTaxNo'];
    vehicleColor = json['VehicleColor'];
    vehicleMakeModel = json['VehicleMakeModel'];
    vehicleNo = json['VehicleNo'];
    vehicleType = json['VehicleType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClampingAmount'] = clampingAmount;
    data['ClampingPaymentDate'] = clampingPaymentDate;
    data['ClampingPaymentDateString'] = clampingPaymentDateString;
    data['ClampingReceiptNumber'] = clampingReceiptNumber;
    data['CompoundAmount'] = compoundAmount;
    data['HandheldCode'] = handheldCode;
    data['ImageName1'] = imageName1;
    data['ImageName2'] = imageName2;
    data['ImageName3'] = imageName3;
    data['ImageName4'] = imageName4;
    data['ImageName5'] = imageName5;
    data['IsClamping'] = isClamping;
    data['Latitude'] = latitude;
    data['Longitude'] = longitude;
    data['Notes'] = notes;
    data['NoticeNo'] = noticeNo;
    data['Offence'] = offence;
    data['OffenceAct'] = offenceAct;
    data['OffenceActCode'] = offenceActCode;
    data['OffenceArea'] = offenceArea;
    data['OffenceDate'] = offenceDate;
    data['OffenceDateString'] = offenceDateString;
    data['OffenceLocation'] = offenceLocation;
    data['OffenceLocationDetails'] = offenceLocationDetails;
    data['OffenceNoticeStatus'] = offenceNoticeStatus;
    data['OffenceSection'] = offenceSection;
    data['OffenceSectionCode'] = offenceSectionCode;
    data['OfficerID'] = officerID;
    data['OfficerUnit'] = officerUnit;
    data['PaidClampingAmount'] = paidClampingAmount;
    data['PaidCompoundAmount'] = paidCompoundAmount;
    data['PaymentDate'] = paymentDate;
    data['PaymentDateString'] = paymentDateString;
    data['ReceiptNumber'] = receiptNumber;
    data['RoadTaxNo'] = roadTaxNo;
    data['VehicleColor'] = vehicleColor;
    data['VehicleMakeModel'] = vehicleMakeModel;
    data['VehicleNo'] = vehicleNo;
    data['VehicleType'] = vehicleType;
    return data;
  }
}
