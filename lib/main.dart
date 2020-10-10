import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(NamazApp());

class NamazApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color(0xF01BA2DD));
    return MaterialApp(
      title: 'Намаз',
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> with WidgetsBindingObserver {
  final _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      var c = await _controller.future;
      c.evaluateJavascript('player.pauseVideo()');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        child: WebView(
          initialUrl: 'https://azan.ru/namaz',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      onWillPop: () async {
        var c = await _controller.future;
        if (await c.canGoBack()) {
          await c.goBack();
          return false;
        }
        return true;
      },
    );
  }
}
