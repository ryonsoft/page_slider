import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ExamContent extends StatefulWidget {
  ExamContent(
      {required this.scrolHandler,
      required this.onWebViewCreated,
      required this.content,
      @required Key? key})
      : super(key: key);
  final Function(dynamic) scrolHandler;
  final Function(InAppWebViewController controller) onWebViewCreated;
  String content;

  @override
  ExamContentState createState() => ExamContentState();
}

class ExamContentState extends State<ExamContent> {
  InAppWebViewController? webViewController;
  @override
  Widget build(BuildContext context) {
    print(widget.content);
    return Scaffold(
      body: InAppWebView(
        initialData: InAppWebViewInitialData(data: ''),
        contextMenu: ContextMenu(
            settings:
                ContextMenuSettings(hideDefaultSystemContextMenuItems: true),
            menuItems: [
              ContextMenuItem(
                id: 1,
                title: 'Dịch',
              ),
            ]),
        initialSettings:
            InAppWebViewSettings(underPageBackgroundColor: Colors.white
                // mediaPlaybackRequiresUserGesture: false,
                // javaScriptEnabled: false,
                // useOnLoadResource: true,
                // supportZoom: false,
                // useShouldOverrideUrlLoading: false,
                // saveFormData: false,
                // thirdPartyCookiesEnabled: false,
                // useWideViewPort: false,
                // forceDark: ForceDark.OFF,
                ),
        onLoadStart: (controller, url) {},
        onLoadStop: (inAppWebViewController, url) async {
          // Sau khi trang web tải xong, can thiệp vào thuộc tính viewport và đặt kích thước chữ
          await inAppWebViewController.evaluateJavascript(source: """
          const meta = document.createElement('meta');
          meta.name = 'viewport';
          meta.content = 'width=device-width, initial-scale=1, maximum-scale=5.0, user-scalable=1';
          document.getElementsByTagName('head')[0].appendChild(meta);
          document.body.style.fontSize = '18px';
        """);
          await inAppWebViewController.evaluateJavascript(source: '''
          let initialX;
          let initialTime;
          document.addEventListener('touchstart', (e) => {
          initialX = e.touches[0].clientX;
          initialTime = new Date().getTime();
        }, false);
      
        document.addEventListener('touchend', (e) => {
           let currentX = e.changedTouches[0].clientX;
           let deltaX = currentX - initialX;
           let currentTime = new Date().getTime();
           let elapsedTime = currentTime - initialTime;
      
           if (deltaX > 50 && elapsedTime < 200) {
              window.flutter_inappwebview.callHandler('swipe', 'right-fast');
           } else if (deltaX < -50 && elapsedTime < 200) {
             window.flutter_inappwebview.callHandler('swipe', 'left-fast');
           } else if (deltaX > 50 && elapsedTime >= 200) {
             window.flutter_inappwebview.callHandler('swipe', 'right-slow');
          } else if (deltaX < -50 && elapsedTime >= 200) {
           window.flutter_inappwebview.callHandler('swipe', 'left-slow');
          }
        }, false);
      
        ''');
          setState(() {});
        },
        onWebViewCreated: (inAppWebViewController) {
          webViewController = inAppWebViewController;
          inAppWebViewController.addJavaScriptHandler(
              handlerName: 'swipe',
              callback: (args) {
                widget.scrolHandler(args[0]);
              });
          widget.onWebViewCreated(inAppWebViewController);
          inAppWebViewController.loadData(data: widget.content);
        },
        onConsoleMessage: (controller, consoleMessage) {
          // print(consoleMessage);
        },
      ),
    );
  }

  updateData(String data) {
    webViewController!.loadData(data: data);
  }
}
