class OffenceActModel {
  String? iD;
  int? code;
  String? shortDescription;
  String? description;
  bool? isDeleted;
  String? createdBy;
  String? updatedBy;
  String? createdDate;
  String? updatedDate;

  OffenceActModel(
      {this.iD,
      this.code,
      this.shortDescription,
      this.description,
      this.isDeleted,
      this.createdBy,
      this.updatedBy,
      this.createdDate,
      this.updatedDate});

  OffenceActModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    shortDescription = json['ShortDescription'];
    description = json['Description'];
    isDeleted = json['IsDeleted'];
    createdBy = json['CreatedBy'];
    updatedBy = json['UpdatedBy'];
    createdDate = json['CreatedDate'];
    updatedDate = json['UpdatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Code'] = code;
    data['ShortDescription'] = shortDescription;
    data['Description'] = description;
    data['IsDeleted'] = isDeleted;
    data['CreatedBy'] = createdBy;
    data['UpdatedBy'] = updatedBy;
    data['CreatedDate'] = createdDate;
    data['UpdatedDate'] = updatedDate;
    return data;
  }
}

class UserMaster {
  String? iD;
  String? groupID;
  String? userID;
  String? fullName;
  String? password;
  bool? isDeleted;
  String? createdBy;
  String? updatedBy;
  String? createdDate;
  String? updatedDate;

  UserMaster(
      {this.iD,
      this.groupID,
      this.userID,
      this.fullName,
      this.password,
      this.isDeleted,
      this.createdBy,
      this.updatedBy,
      this.createdDate,
      this.updatedDate});

  UserMaster.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    groupID = json['GroupID'];
    userID = json['UserID'];
    fullName = json['FullName'];
    password = json['Password'];
    isDeleted = json['IsDeleted'];
    createdBy = json['CreatedBy'];
    updatedBy = json['UpdatedBy'];
    createdDate = json['CreatedDate'];
    updatedDate = json['UpdatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['GroupID'] = groupID;
    data['UserID'] = userID;
    data['FullName'] = fullName;
    data['Password'] = password;
    data['IsDeleted'] = isDeleted;
    data['CreatedBy'] = createdBy;
    data['UpdatedBy'] = updatedBy;
    data['CreatedDate'] = createdDate;
    data['UpdatedDate'] = updatedDate;
    return data;
  }
}
