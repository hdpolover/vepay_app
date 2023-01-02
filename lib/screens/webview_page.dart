import 'package:flutter/material.dart';
import 'package:vepay_app/common/common_widgets.dart';

class WebViewPage extends StatefulWidget {
  String title;
  String url;
  WebViewPage({required this.title, required this.url, Key? key})
      : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets().buildCommonAppBar(widget.title),
      body: Container(),
    );
  }
}
