class TourTrip {
  final String tourTripId;
  final DateTime tripDate;
  final String tripStatus;
  final double price;
  final int bookedSeats;

  TourTrip({
    required this.tourTripId,
    required this.tripDate,
    required this.tripStatus,
    required this.price,
    required this.bookedSeats,
  });

  factory TourTrip.fromJson(Map<String, dynamic> json) {
    return TourTrip(
      tourTripId: json['tourTripId'],
      tripDate: DateTime.parse(json['tripDate']),
      tripStatus: json['tripStatus'],
      price: json['price'],
      bookedSeats: json['bookedSeats'],
    );
  }
}