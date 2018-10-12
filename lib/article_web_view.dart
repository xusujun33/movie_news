import 'package:flutter/material.dart';


class ArticleWebView extends StatelessWidget {
  ArticleWebView({Key key, this.data}) : super(key: key);
  var data;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('${data['author']}'),
      ),
      body: new Center(
        child: new Text('a'),
      ),
    );
  }
}
