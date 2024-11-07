import 'package:explore_now/features/home_screens/screens/home/models/tour_mood_model.dart';
import 'package:explore_now/features/home_screens/screens/home/models/tour_timestamp_model.dart';
import 'package:explore_now/features/home_screens/screens/home/models/tour_trip_model.dart';
import 'package:explore_now/features/home_screens/screens/home/models/transportation_model.dart';

import 'location_model.dart';

class Tour {
  final String id;
  final String code;
  final DateTime? startDate;
  final DateTime? endDate;
  final double totalPrice;
  final String status;
  final String? title;
  final String? description;
  final List<Transportation> transportations;
  final List<TourTimestamp> tourTimestamps;
  final List<Location> locationInTours;
  final List<TourMood> tourMoods;
  final List<TourTrip> tourTrips;

  Tour({
    required this.id,
    required this.code,
    this.startDate,
    this.endDate,
    required this.totalPrice,
    required this.status,
    this.title,
    this.description,
    required this.transportations,
    required this.tourTimestamps,
    required this.locationInTours,
    required this.tourMoods,
    required this.tourTrips,
  });

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      title: json['title'],
      description: json['description'],
      transportations: (json['transportations'] as List?)
              ?.map((e) => Transportation.fromJson(e))
              .toList() ??
          [],
      tourTimestamps: (json['tourTimestamps'] as List?)
              ?.map((e) => TourTimestamp.fromJson(e))
              .toList() ??
          [],
      locationInTours: (json['locationInTours'] as List?)
              ?.map((e) => Location.fromJson(e))
              .toList() ??
          [],
      tourMoods: (json['tourMoods'] as List?)
              ?.map((e) => TourMood.fromJson(e))
              .toList() ??
          [],
      tourTrips: (json['tourTrips'] as List?)
              ?.map((e) => TourTrip.fromJson(e))
              .toList() ??
          [],
    );
  }

  static DateTime? _parseDate(String? dateString) {
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      print("Invalid date format: $dateString");
      return null;
    }
  }
}
