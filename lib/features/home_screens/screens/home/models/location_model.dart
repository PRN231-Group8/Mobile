import 'package:explore_now/features/home_screens/screens/home/models/photo_model.dart';

import 'address_model.dart';

class Location {
  final String id;
  final String name;
  final String description;
  final Address address;
  final String status;
  final double? temperature;
  final List<Photo> photos;

  Location({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.status,
    this.temperature,
    required this.photos,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: Address.fromJson(json['address']),
      status: json['status'] ?? '',
      temperature: (json['temperature'] as num?)?.toDouble(),
      photos: (json['photos'] as List?)
          ?.map((photo) => Photo.fromJson(photo))
          .toList() ?? [],
    );
  }
}