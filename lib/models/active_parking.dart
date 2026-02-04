class ActiveParking {
  final String plateNumber;
  final String location;
  final String zone;
  final String slot;
  final DateTime startTime;
  final double ratePerHour;
  final double latitude;
  final double longitude;

  ActiveParking({
    required this.plateNumber,
    required this.location,
    required this.zone,
    required this.slot,
    required this.startTime,
    required this.ratePerHour,
    required this.latitude,
    required this.longitude,
  });

  /// For general API
  factory ActiveParking.fromJson(Map<String, dynamic> json) {
    return ActiveParking(
      plateNumber: json['plateNumber'],
      location: json['location'],
      zone: json['zone'],
      slot: json['slot'],
      startTime: DateTime.parse(json['startTime']),
      ratePerHour: (json['ratePerHour'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  /// For LPR API
  factory ActiveParking.fromLprJson(
    Map<String, dynamic> json, {
    required String location,
    required String zone,
    required String slot,
    required double ratePerHour,
  }) {
    return ActiveParking(
      plateNumber: json['plate'],
      location: location,
      zone: zone,
      slot: slot,
      startTime: DateTime.parse(json['timestamp']),
      ratePerHour: ratePerHour,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
