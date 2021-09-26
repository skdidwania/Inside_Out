import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {

  final String postUrl;
  ArticleView({@required this.postUrl});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  List <String>choices = ['Open With Browser'];
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "News",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: <Widget>[
          MaterialButton(
            padding: EdgeInsets.symmetric(horizontal: 16),
              onPressed: () { Share.share('Visit this website :' + widget.postUrl);
              },
              child: Icon(Icons.share,)),
          PopupMenuButton<String>(
            onSelected: choiceOption,
            itemBuilder: (BuildContext context) {
              return choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
    ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          initialUrl:  widget.postUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController){
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
  void choiceOption(String choice) {
    if (choice=="Open With Browser") {
      _launchInBrowser();
    }
  }
  Future<void> _launchInBrowser() async {
    if (await canLaunch(widget.postUrl)) {
      await launch(widget.postUrl, forceWebView: false);
    } else {
      throw 'Could not launch ${widget.postUrl}';
    }
  }
}
