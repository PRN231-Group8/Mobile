import 'package:explore_now/features/home_screens/screens/home/models/tour_mood_model.dart';
import 'package:explore_now/features/personalization/models/transaction_model.dart';

import '../../home_screens/screens/home/models/tour_timestamp_model.dart';
import '../../home_screens/screens/home/models/tour_trip_model.dart';
import '../../home_screens/screens/home/models/transportation_model.dart';

class TourPackageHistory {
  final String id;
  final String title;
  final String description;
  final double totalPrice;
  final String status;
  final DateTime endDate;
  final List<TourTrip> tourTrips;
  final List<TourTimestamp> tourTimestamps;
  final List<Transportation> transportations;
  final List<TourMood> moods;
  final List<Transaction> transactions;

  TourPackageHistory({
    required this.id,
    required this.title,
    required this.description,
    required this.totalPrice,
    required this.status,
    required this.endDate,
    required this.tourTrips,
    required this.tourTimestamps,
    required this.transportations,
    required this.moods,
    required this.transactions,
  });

  factory TourPackageHistory.fromJson(Map<String, dynamic> json) {
    return TourPackageHistory(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] ?? '',
      endDate: DateTime.parse(json['endDate']),
      tourTrips: (json['tourTrips'] as List)
          .map((e) => TourTrip.fromJson(e))
          .toList(),
      tourTimestamps: (json['tourTimestamps'] as List)
          .map((e) => TourTimestamp.fromJson(e))
          .toList(),
      transportations: (json['transportations'] as List)
          .map((e) => Transportation.fromJson(e))
          .toList(),
      moods: (json['moods'] as List).map((e) => TourMood.fromJson(e)).toList(),
      transactions: (json['transactions'] as List)
          .map((e) => Transaction.fromJson(e))
          .toList(),
    );
  }
}