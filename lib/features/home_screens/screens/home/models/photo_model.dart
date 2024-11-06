
class Photo {
  final String id;
  final String url;
  final String alt;

  Photo({
    required this.id,
    required this.url,
    required this.alt,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      url: json['url'],
      alt: json['alt'],
    );
  }
}
