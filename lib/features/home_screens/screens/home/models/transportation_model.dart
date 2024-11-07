class Transportation {
  final String id;
  final String type;
  final double price;
  final int capacity;
  final String tourId;

  Transportation({
    required this.id,
    required this.type,
    required this.price,
    required this.capacity,
    required this.tourId,
  });

  factory Transportation.fromJson(Map<String, dynamic> json) {
    return Transportation(
      id: json['id'],
      type: json['type'],
      price: json['price'],
      capacity: json['capacity'],
      tourId: json['tourId'],
    );
  }
}