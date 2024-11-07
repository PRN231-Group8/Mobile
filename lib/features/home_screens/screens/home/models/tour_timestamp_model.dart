import 'package:explore_now/features/home_screens/screens/home/models/location_model.dart';
import 'package:explore_now/features/home_screens/screens/home/models/preferred_time_slot_model.dart';

class TourTimestamp {
  final String id;
  final String title;
  final String description;
  final PreferredTimeSlot? preferredTimeSlot;
  final Location? location;

  TourTimestamp({
    required this.id,
    required this.title,
    required this.description,
    this.preferredTimeSlot,
    this.location,
  });

  factory TourTimestamp.fromJson(Map<String, dynamic> json) {
    return TourTimestamp(
      id: json['id'] ?? '',
      title: json['title'] ?? 'No title',
      description: json['description'] ?? 'No description',
      preferredTimeSlot: json['preferredTimeSlot'] != null
          ? PreferredTimeSlot.fromJson(json['preferredTimeSlot'])
          : null,
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
    );
  }
}
