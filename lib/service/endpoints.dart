class Endpoints {
  Endpoints._();

  //production
  static const String mainApiUrl = "http://172.30.1.59:3001";
  static const String webviewUrl = "http://172.30.1.59:3080";
  // static const String mainApiUrl = "https://chat-api.components.kr";
  // static const String webviewUrl = "https://chat.components.kr";

  static const int receiveTimeout = 5000;
  static const int connectionTimeout = 3000;

  static const String userUpdateFcmToken = "$mainApiUrl/auth/update-fcm-token";
  static const String userUpdatePlatform = "$mainApiUrl/user/update-platform";
  static const String userRemoveFcmToken = "$mainApiUrl/user/remove-fcm-token";
}
