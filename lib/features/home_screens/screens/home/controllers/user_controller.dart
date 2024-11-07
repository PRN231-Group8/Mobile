import 'package:flutter/foundation.dart';
import '../../../../../data/services/personalization/user_profile_service.dart';

class UserController with ChangeNotifier {
  final UserProfileService _userProfileService = UserProfileService();
  String? userName;
  String? userEmail;
  String? profileImageUrl;
  bool isLoading = false;
  String? errorMessage;

  UserController() {
    fetchUser();
  }

  Future<void> fetchUser() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final profileData = await _userProfileService.getUserProfile();
      if (profileData["success"] == true) {
        final data = profileData["data"];
        userName = data["name"];
        userEmail = data["email"];
        profileImageUrl = data["profileImageUrl"];
      } else {
        errorMessage = profileData["message"];
      }
    } catch (e) {
      errorMessage = "Failed to load user information";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


}
