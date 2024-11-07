class Address {
  final String fullAddress;
  final double? longitude;
  final double? latitude;

  Address({
    required this.fullAddress,
    this.longitude,
    this.latitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      fullAddress: json['fullAddress'] ?? '',
      longitude: (json['longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
    );
  }
}