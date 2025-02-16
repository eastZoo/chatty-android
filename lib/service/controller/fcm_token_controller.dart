import 'dart:io';

import 'package:chat/service/provider/fcm_token_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FcmTokenController extends GetxController {
  bool isLoading = true;
  String? userId;

  @override
  void onInit() async {
    super.onInit();
    // getUserInfo();
    updateFcmToken();
    updatePlatform();
  }

  updatePlatform() async {
    if (Platform.isAndroid) {
      FcmTokenProvider().updatePlatformProvider("Android");
    } else if (Platform.isIOS) {
      FcmTokenProvider().updatePlatformProvider("iOS");
    }
  }

  updateFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    FcmTokenProvider().updateFcmTokenProvider(fcmToken.toString());
  }

  // 로그아웃 시, FCM 토큰을 제거합니다.
  Future<void> removeFcmToken(String userId) async {
    FcmTokenProvider().removeFcmTokenProvider(userId);
  }

  // getUserInfo() async {
  //   try {
  //     var res = await UserInfoProvider().getUserInfoProvider();
  //     userInfo = UserInfo.fromJson(res["data"]);
  //     isLoading = false;
  //   } catch (error) {
  //     // error 캐치해도 일단 아바타 로딩 잡기 위해서 강제 false 처리
  //     isLoading = false;
  //   } finally {
  //     update();
  //   }
  // }
}
