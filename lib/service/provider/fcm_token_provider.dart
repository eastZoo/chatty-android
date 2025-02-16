import 'package:chat/service/api_request.dart';
import 'package:chat/service/endpoints.dart';

class FcmTokenProvider {
  updateFcmTokenProvider(String token) async {
    return await ApiRequest(
        url: Endpoints.userUpdateFcmToken, data: {"token": token}).ayncPut();
  }

  updatePlatformProvider(String platform) async {
    return await ApiRequest(
        url: Endpoints.userUpdatePlatform,
        data: {"platform": platform}).ayncPut();
  }

  removeFcmTokenProvider(String userId) async {
    return await ApiRequest(
        url: Endpoints.userRemoveFcmToken,
        data: {"userId": userId}).ayncDelete();
  }
}
