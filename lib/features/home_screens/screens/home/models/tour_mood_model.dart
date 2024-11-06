class TourMood {
  final String id;
  final String moodTag;
  final String iconName;

  TourMood({required this.id, required this.moodTag, required this.iconName});

  factory TourMood.fromJson(Map<String, dynamic> json) {
    return TourMood(
      id: json['id'],
      moodTag: json['moodTag'],
      iconName: json['iconName'],
    );
  }
}