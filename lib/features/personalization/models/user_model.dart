import '../../../utils/formatters/formatter.dart';

/// Model class representing user data.
class UserModel {
  // Keep those values final which you do not want to update
  final String id;
  String firstName;
  String lastName;

  // final String username;
  final String email;
  String phoneNumber;
  String profilePicture;
  List<String> roles;
  String deviceId;

  /// Constructor for UserModel.
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    // required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.roles,
    required this.deviceId,
  });

  /// Helper function to get the full name.
  String get fullName => '$firstName $lastName';

  /// Helper function to format phone number.
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  /// Static function to split full name intro first and last name
  static List<String> nameParts(fullName) => fullName.split(" ");

  ///Static function to generate a username from full name
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername =
        "$firstName$lastName"; // Combine first and last name
    String usernameWithPrefix = "cwt_$camelCaseUsername"; // Add "cwt_" prefix

    return usernameWithPrefix;
  }

// Static function to create an empty user model.
  static UserModel empty() => UserModel(
        id: '',
        firstName: '',
        lastName: '',
        // username: '',
        email: '',
        phoneNumber: '',
        profilePicture: '',
        roles: [],
        deviceId: '',
      );

// Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      // 'Username': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Roles': roles,
    };
  }

  /// Factory method to create a UserModel from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'] ?? '',
      // Updated to match the JSON response
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profilePicture: json['avatarPath'] ?? '',
      // Updated to match the JSON response
      roles: List<String>.from(json['roles'] ?? []),
      deviceId: json['deviceId'] ?? '',
    );
  }
}
