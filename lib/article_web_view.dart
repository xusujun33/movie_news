import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ArticleWebView extends StatefulWidget {
  ArticleWebView({Key key, this.data}) : super(key: key);
  var data;

  @override
  State<StatefulWidget> createState() => new ArticleWebViewState();
}

class ArticleWebViewState extends State<ArticleWebView>{


  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      appBar: new AppBar(
        title: new Text('${widget.data['author']}'),
      ),
      url: widget.data['link'],
    );
  }

}
