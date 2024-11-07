class PreferredTimeSlot {
  final String startTime;
  final String endTime;

  PreferredTimeSlot({
    required this.startTime,
    required this.endTime,
  });

  factory PreferredTimeSlot.fromJson(Map<String, dynamic> json) {
    return PreferredTimeSlot(
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}