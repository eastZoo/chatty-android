import 'package:chat/service/controller/fcm_token_controller.dart';
import 'package:chat/service/endpoints.dart';
import 'package:chat/service/provider/fcm_token_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();
  String? _token;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocalStorageData();
    });
    _getToken();
    _setupFCM();
    _requestPermission();
    // 추가 설정 필요 시 여기서 수행
  }

  void _getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    setState(() {
      _token = token;
    });
    print("FCM Token: $token");
    FcmTokenProvider().updateFcmTokenProvider(token.toString());
  }

  void _setupFCM() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message: ${message.notification?.title}");
      // 여기에서 로컬 알림을 표시하거나 UI를 업데이트할 수 있습니다.
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Opened app from notification: ${message.notification?.title}");
      // 여기에서 특정 화면으로 네비게이션하거나 다른 작업을 수행할 수 있습니다.
    });
  }

  void _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> _initializeLocalStorageData() async {
    if (webViewController == null) return;

    print("웹뷰 로컬스토리지 데이터");

    try {
      // JavaScript 실행으로 localStorage 데이터 가져오기
      final accessToken = await webViewController?.evaluateJavascript(
          source: "localStorage.getItem('accessToken')");
      final refreshToken = await webViewController?.evaluateJavascript(
          source: "localStorage.getItem('refreshToken')");

      // SecureStorage 업데이트
      const storage = FlutterSecureStorage();
      if (accessToken != null) {
        print("accessToken: $accessToken");
        await storage.write(
            key: dotenv.env['ACCESS_TOKEN_NAME']!,
            value: accessToken.toString());
      }
      if (refreshToken != null) {
        print("refreshToken: $refreshToken");
        await storage.write(
            key: dotenv.env['REFRESH_TOKEN_NAME']!,
            value: refreshToken.toString());
      }
    } catch (e) {
      print('로컬스토리지 데이터 초기화 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest:
            URLRequest(url: Uri.parse(Endpoints.webviewUrl), headers: {}),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
              javaScriptCanOpenWindowsAutomatically: true,
              javaScriptEnabled: true,
              useOnDownloadStart: true,
              useOnLoadResource: true,
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: true,
              allowFileAccessFromFileURLs: true,
              allowUniversalAccessFromFileURLs: true,
              transparentBackground: false,
              verticalScrollBarEnabled: false,
              horizontalScrollBarEnabled: false,
              userAgent:
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.122 Safari/537.36'),
          android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
              allowContentAccess: true,
              builtInZoomControls: true,
              thirdPartyCookiesEnabled: true,
              allowFileAccess: true,
              supportMultipleWindows: true,
              overScrollMode: AndroidOverScrollMode.OVER_SCROLL_NEVER),
          ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
            allowsBackForwardNavigationGestures: true,
          ),
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
          _initializeLocalStorageData();
          // // 예시: JavaScript 채널 설정
          // webViewController.addJavaScriptHandler(
          //   handlerName: 'flutterHandler',
          //   callback: (args) {
          //     // args로부터 메시지를 받고 처리합니다.
          //     if (args.isNotEmpty) {
          //       _onWebViewMessage(args[0]);
          //     }
          //     return;
          //   },
          // );
        },
        onLoadHttpError: (controller, url, statusCode, description) {
          webViewController?.loadFile(assetFilePath: "assets/html/404.html");
        },
        onConsoleMessage: (controller, message) {
          print('on Console message - $message');
        },
        // 무한 로딩 이슈가 있을 경우, 초기 로딩 관련 옵션들을 조정합니다.
        onLoadStop: (controller, url) async {
          // 예: 로딩 스피너를 제거하거나, JS 코드를 실행하여 상태를 업데이트할 수 있습니다.
          await _initializeLocalStorageData();
        },
      ),
    );
  }
}
