import 'package:flutter/widgets.dart';
import 'package:web_browser/web_browser.dart';

class WebView extends StatefulWidget {
  const WebView({Key? key}) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: WebBrowser(
          initialUrl: 'https://flutter.dev/',
          javascriptEnabled: true,
        ),
      ),
    );
  }
}
