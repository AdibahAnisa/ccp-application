class WalletModel {
  String? walletAmount;

  WalletModel({this.walletAmount});

  WalletModel.fromJson(Map<String, dynamic> json) {
    walletAmount = json['walletAmount']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'walletAmount': walletAmount,
    };
  }
}
