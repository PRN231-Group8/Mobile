import 'package:explore_now/features/tour_post/models/photo_model.dart';
import '../../personalization/models/user_model.dart';
import 'comment_model.dart';

class PostModel {
  final String postsId;
  final String content;
  final int rating;
  final String status;
  final DateTime createDate;
  final UserModel user;
  final List<CommentModel> comments;
  final List<PhotoModel> photos;

  PostModel({
    required this.postsId,
    required this.content,
    required this.rating,
    required this.status,
    required this.createDate,
    required this.user,
    required this.comments,
    required this.photos,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postsId: json['postsId'],
      content: json['content'],
      rating: json['rating'],
      status: json['status'],
      createDate: DateTime.parse(json['createDate']),
      user: UserModel.fromJson(json['user']),
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => CommentModel.fromJson(e))
              .toList() ??
          [],
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => PhotoModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postsId': postsId,
      'content': content,
      'rating': rating,
      'status': status,
      'createDate': createDate.toIso8601String(),
      'user': user.toJson(),
      'comments': comments.map((e) => e.toJson()).toList(),
      'photos': photos.map((e) => e.toJson()).toList(),
    };
  }
}
