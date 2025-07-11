import 'package:project/models/offences_rule/offence_sections_model.dart';

class TicketModel {
  String? iD;
  String? ticketNumber;
  String? offenceDateTime;
  String? officerID;
  String? deviceID;
  String? officerUnit;
  String? vehicleNumber;
  String? vehicleType;
  String? vehicleMakeModel;
  String? vehicleColor;
  String? roadTaxNumber;
  String? squarePoleNumber;
  String? sectionID;
  String? offenceArea;
  String? offenceLocation;
  String? offenceLocationDetails;
  String? offenceStatus;
  String? latitude;
  String? longitude;
  int? fine;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? image5;
  bool? isClamping;
  String? notes;
  String? createdDate;
  String? updatedDate;
  String? paidAmount;
  String? paymentDate;
  String? receiptNumber;
  String? clampingPaidAmount;
  String? clampingPaymentDate;
  String? clampingReceiptNumber;
  String? paymentDeviceID;
  String? paymentOfficerID;
  String? paymentType;
  String? paymentLocation;
  String? ownerName;
  String? ownerICCategory;
  String? ownerIC;
  String? ownerAddress;
  String? sentDate;
  String? clampingSentDate;
  String? officerSaksi;
  OffenceSectionModel? offenceSection;

  TicketModel({
    this.iD,
    this.ticketNumber,
    this.offenceDateTime,
    this.officerID,
    this.deviceID,
    this.officerUnit,
    this.vehicleNumber,
    this.vehicleType,
    this.vehicleMakeModel,
    this.vehicleColor,
    this.roadTaxNumber,
    this.squarePoleNumber,
    this.sectionID,
    this.offenceArea,
    this.offenceLocation,
    this.offenceLocationDetails,
    this.offenceStatus,
    this.latitude,
    this.longitude,
    this.fine,
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.image5,
    this.isClamping,
    this.notes,
    this.createdDate,
    this.updatedDate,
    this.paidAmount,
    this.paymentDate,
    this.receiptNumber,
    this.clampingPaidAmount,
    this.clampingPaymentDate,
    this.clampingReceiptNumber,
    this.paymentDeviceID,
    this.paymentOfficerID,
    this.paymentType,
    this.paymentLocation,
    this.ownerName,
    this.ownerICCategory,
    this.ownerIC,
    this.ownerAddress,
    this.sentDate,
    this.clampingSentDate,
    this.officerSaksi,
    this.offenceSection,
  });

  TicketModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    ticketNumber = json['TicketNumber'];
    offenceDateTime = json['OffenceDateTime'];
    officerID = json['OfficerID'];
    deviceID = json['DeviceID'];
    officerUnit = json['OfficerUnit'];
    vehicleNumber = json['VehicleNumber'];
    vehicleType = json['VehicleType'];
    vehicleMakeModel = json['VehicleMakeModel'];
    vehicleColor = json['VehicleColor'];
    roadTaxNumber = json['RoadTaxNumber'];
    squarePoleNumber = json['SquarePoleNumber'];
    sectionID = json['SectionID'];
    offenceArea = json['OffenceArea'];
    offenceLocation = json['OffenceLocation'];
    offenceLocationDetails = json['OffenceLocationDetails'];
    offenceStatus = json['OffenceStatus'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    fine = json['Fine'];
    image1 = json['Image1'];
    image2 = json['Image2'];
    image3 = json['Image3'];
    image4 = json['Image4'];
    image5 = json['Image5'];
    isClamping = json['IsClamping'];
    notes = json['Notes'];
    createdDate = json['CreatedDate'];
    updatedDate = json['UpdatedDate'];
    paidAmount = json['PaidAmount'];
    paymentDate = json['PaymentDate'];
    receiptNumber = json['ReceiptNumber'];
    clampingPaidAmount = json['ClampingPaidAmount'];
    clampingPaymentDate = json['ClampingPaymentDate'];
    clampingReceiptNumber = json['ClampingReceiptNumber'];
    paymentDeviceID = json['PaymentDeviceID'];
    paymentOfficerID = json['PaymentOfficerID'];
    paymentType = json['PaymentType'];
    paymentLocation = json['PaymentLocation'];
    ownerName = json['OwnerName'];
    ownerICCategory = json['OwnerICCategory'];
    ownerIC = json['OwnerIC'];
    ownerAddress = json['OwnerAddress'];
    sentDate = json['SentDate'];
    clampingSentDate = json['ClampingSentDate'];
    officerSaksi = json['OfficerSaksi'];
    offenceSection = json['OffenceSection'] != null
        ? new OffenceSectionModel.fromJson(json['OffenceSection'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['TicketNumber'] = ticketNumber;
    data['OffenceDateTime'] = offenceDateTime;
    data['OfficerID'] = officerID;
    data['DeviceID'] = deviceID;
    data['OfficerUnit'] = officerUnit;
    data['VehicleNumber'] = vehicleNumber;
    data['VehicleType'] = vehicleType;
    data['VehicleMakeModel'] = vehicleMakeModel;
    data['VehicleColor'] = vehicleColor;
    data['RoadTaxNumber'] = roadTaxNumber;
    data['SquarePoleNumber'] = squarePoleNumber;
    data['SectionID'] = sectionID;
    data['OffenceArea'] = offenceArea;
    data['OffenceLocation'] = offenceLocation;
    data['OffenceLocationDetails'] = offenceLocationDetails;
    data['OffenceStatus'] = offenceStatus;
    data['Latitude'] = latitude;
    data['Longitude'] = longitude;
    data['Fine'] = fine;
    data['Image1'] = image1;
    data['Image2'] = image2;
    data['Image3'] = image3;
    data['Image4'] = image4;
    data['Image5'] = image5;
    data['IsClamping'] = isClamping;
    data['Notes'] = notes;
    data['CreatedDate'] = createdDate;
    data['UpdatedDate'] = updatedDate;
    data['PaidAmount'] = paidAmount;
    data['PaymentDate'] = paymentDate;
    data['ReceiptNumber'] = receiptNumber;
    data['ClampingPaidAmount'] = clampingPaidAmount;
    data['ClampingPaymentDate'] = clampingPaymentDate;
    data['ClampingReceiptNumber'] = clampingReceiptNumber;
    data['PaymentDeviceID'] = paymentDeviceID;
    data['PaymentOfficerID'] = paymentOfficerID;
    data['PaymentType'] = paymentType;
    data['PaymentLocation'] = paymentLocation;
    data['OwnerName'] = ownerName;
    data['OwnerICCategory'] = ownerICCategory;
    data['OwnerIC'] = ownerIC;
    data['OwnerAddress'] = ownerAddress;
    data['SentDate'] = sentDate;
    data['ClampingSentDate'] = clampingSentDate;
    data['OfficerSaksi'] = officerSaksi;
    if (offenceSection != null) {
      data['OffenceSection'] = offenceSection!.toJson();
    }
    return data;
  }
}
