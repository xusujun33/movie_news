import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class MoiveNews extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MoiveNewsState();
}

class MoiveNewsState extends State<MoiveNews> {
  var subjects = [];

  @override
  void initState() {
    loadData();
  }

  loadData() async {
    final loadUrl = 'https://api.douban.com/v2/movie/in_theaters';
    http.Response response = await http.get(loadUrl);
    var result = json.decode(response.body);
    setState(
      () {
        subjects = result['subjects'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new CupertinoPageScaffold(
      navigationBar: new CupertinoNavigationBar(
        middle: new Text('电影资讯'),
      ),
      child: new Center(
        child: getMovieNews(),
      ),
    );
  }

  getMovieNews() {
    if (subjects.length != 0) {
      return new ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          if(index < subjects.length){
            return movieItems(subjects[index]);
          }
        },
      );
    } else {
      return new CupertinoActivityIndicator();
    }
  }

  movieItems(var subjects) {
    var avatars = List.generate(
      subjects['casts'].length,
      (index) {
        return new Container(
          child: new CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage:
                new NetworkImage(subjects['casts'][index]['avatars']['small']),
          ),
        );
      },
    );

    var row = Container(
      padding: const EdgeInsets.all(3.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new ClipRRect(
              child: new Image.network(
                subjects['images']['large'],
                width: 100.0,
                height: 150.0,
                fit: BoxFit.fill,
              ),
              borderRadius: new BorderRadius.circular(4.0),
            ),
          ),
          new Expanded(
            flex: 2,
            child: new Container(
              height: 150.0,
              margin: const EdgeInsets.only(left: 6.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    subjects['title'],
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  new Text('综合评分：${subjects['rating']['average']}'),
                  new Text('类型：${subjects['genres'].join('、')}'),
                  new Text('导演：${subjects['directors'][0]['name']}'),
                  new Container(
                    child: new Row(
                      children: <Widget>[
                        new Text('主演：'),
                        new Row(
                          children: avatars,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return new Card(
      child: row,
    );
  }
}
