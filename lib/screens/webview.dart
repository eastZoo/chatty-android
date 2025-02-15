import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late final InAppWebViewController webViewController;
  final GlobalKey webViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // 추가 설정 필요 시 여기서 수행
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(
            url: Uri.parse("https://chat.components.kr"), headers: {}),
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
              transparentBackground: true,
              verticalScrollBarEnabled: false,
              horizontalScrollBarEnabled: false,
              // disableHorizontalScroll: true,
              // disableVerticalScroll: true,
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
        },
        onLoadHttpError: (controller, url, statusCode, description) {
          webViewController.loadFile(assetFilePath: "assets/html/404.html");
        },
        onConsoleMessage: (controller, message) {
          print('on Console message - $message');
        },
        // 무한 로딩 이슈가 있을 경우, 초기 로딩 관련 옵션들을 조정합니다.
        onLoadStop: (controller, url) async {
          // 예: 로딩 스피너를 제거하거나, JS 코드를 실행하여 상태를 업데이트할 수 있습니다.
        },
      ),
    );
  }
}
