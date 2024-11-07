import '../../personalization/models/user_model.dart';

class CommentModel {
  final String commentId;
  final String content;
  final DateTime createdDate;
  final UserModel? user;

  CommentModel({
    required this.commentId,
    required this.content,
    required this.createdDate,
    this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['id'] ?? '',
      content: json['content'] ?? '',
      createdDate: DateTime.parse(json['createdDate']),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': commentId,
      'content': content,
      'createdDate': createdDate.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}
