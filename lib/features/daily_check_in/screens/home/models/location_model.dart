import 'photo_model.dart';

class Location {
  final String id;
  final String name;
  final String description;
  final String address;
  final String status;
  final double temperature;
  final List<Photo> photos;

  Location({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.status,
    required this.temperature,
    required this.photos,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    var photoList = json['photos'] as List;
    List<Photo> photos = photoList.map((i) => Photo.fromJson(i)).toList();

    return Location(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      status: json['status'],
      temperature: json['temperature'].toDouble(),
      photos: photos,
    );
  }
}
