class ParkingPlaceModel {
  final String duration;
  final String pbt;
  final String? state;
  final String? area;
  final String location;
  final String plateNumber;
  final DateTime? expiredAt;

  ParkingPlaceModel({
    required this.duration,
    required this.pbt,
    this.state,
    this.area,
    required this.location,
    required this.plateNumber,
    this.expiredAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'duration': duration,
      'pbt': pbt,
      'state': state,
      'area': area,
      'location': location,
      'plateNumber': plateNumber,
      'expiredAt': expiredAt?.toIso8601String(),
    };
  }

  factory ParkingPlaceModel.fromMap(Map<String, dynamic> map) {
    return ParkingPlaceModel(
      duration: map['duration'],
      pbt: map['pbt'],
      state: map['state'],
      area: map['area'],
      location: map['location'],
      plateNumber: map['plateNumber'],
      expiredAt: map['expiredAt'] != null
          ? DateTime.tryParse(map['expiredAt'])
          : null,
    );
  }

  ParkingPlaceModel copyWith({
    String? duration,
    String? pbt,
    String? state,
    String? area,
    String? location,
    String? plateNumber,
    DateTime? expiredAt,
  }) {
    return ParkingPlaceModel(
      duration: duration ?? this.duration,
      pbt: pbt ?? this.pbt,
      state: state ?? this.state,
      area: area ?? this.area,
      location: location ?? this.location,
      plateNumber: plateNumber ?? this.plateNumber,
      expiredAt: expiredAt ?? this.expiredAt,
    );
  }
}
