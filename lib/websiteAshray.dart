import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'LoginForm.dart';

class Websiteview extends StatefulWidget {
  const Websiteview({Key? key}) : super(key: key);



  @override
  State<Websiteview> createState() => _WebsiteviewState();
}



class _WebsiteviewState extends State<Websiteview> {
  // initialize here
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..loadRequest(Uri.parse('https://www.figma.com/file/cF3cqHV7E2D3p0PHX6u24j/Aahar?type=design&mode=design&t=GO31pzo7qb8gv5a3-0'));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aashray.in',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor:  Color.fromARGB( 255, 0, 77, 87),

      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
