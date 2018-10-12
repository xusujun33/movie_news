import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'article_web_view.dart';

class ReadTime extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ReadTimeState();
}

class ReadTimeState extends State<ReadTime> {
  //用于控制返回api接口第N页的数据
  int _page = 1;
  //存放返回的map数据
  List articleData;
  //上拉加载更多中用于控制是否正在刷新
  bool isLoading = false;

  //滑动控制监听器
  ScrollController _scrollController = new ScrollController();

  //通过api接口下载数据
  Future loadData() async {
    final String loadUrl = 'http://www.wanandroid.com/article/list/0/json';
    http.Response response = await http.get(loadUrl);
    var result = json.decode(response.body);
    setState(
      () {
        articleData = result['data']['datas'];
      },
    );
  }

  //上拉加载
  Future _getMore() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      String loadUrl = 'http://www.wanandroid.com/article/list/${_page}/json';
      http.Response response = await http.get(loadUrl);
      var result = json.decode(response.body);
      _page++;
      setState(
        () {
          articleData.addAll(result['data']['datas']);
          isLoading = false;
        },
      );
    }
  }

  //上拉加载显示加载中控件
  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '加载中...',
              style: TextStyle(fontSize: 13.0),
            ),
            CircularProgressIndicator(
              strokeWidth: 0.8,
            )
          ],
        ),
      ),
    );
  }

  //下拉刷新
  Future _onRefresh() async {
    final String loadUrl = 'http://www.wanandroid.com/article/list/0/json';
    http.Response response = await http.get(loadUrl);
    var result = json.decode(response.body);
    setState(
      () {
        articleData = result['data']['datas'];
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
  }

  @override
  void initState() {
    loadData();
    _scrollController.addListener(
      () {
        //print('当前位置：${_scrollController.position.pixels}');
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          //print('最大位置：${_scrollController.position.maxScrollExtent}');
          print('滑动到底部了');
          _getMore();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('最新博文'),
      ),
      body: new Center(
        child: getArticles(),
      )
    );
  }

  getArticles() {
    if (articleData.length != 0) {
      return new ListView.builder(
        itemBuilder: (context, index) {
          print('执行了 $index 次');
          if (index >= articleData.length) {
            return _getMoreWidget();
          } else if(index == 0){
            return pictureItem();
          }else{
            return ArticlesItems(articleData[index], index);
          }
        },
        itemCount: articleData.length + 1,
        controller: _scrollController,
      );
    } else {
      return new CupertinoActivityIndicator();
    }
  }

  pictureItem(){
    return new Container(
      padding: const EdgeInsets.all(5.0),
      child: new ClipRRect(
        child: new Image.network('http://www.wanandroid.com/blogimgs/62c1bd68-b5f3-4a3c-a649-7ca8c7dfabe6.png',fit: BoxFit.fill,),
        borderRadius: new BorderRadius.circular(5.0),
      )
    );
  }

  ArticlesItems(var data, int index) {
    Widget row = Container(
      height: 120.0,
      padding: const EdgeInsets.all(4.0),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(Radius.circular(5.0)),
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            '作者：${data['author']}',
            style: new TextStyle(fontSize: 12.0),
          ),
          new Text(
            data['title'],
            style: new TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
            maxLines: 2,
          ),
          new Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  '分类：${data['superChapterName']}',
                  style: new TextStyle(fontSize: 11.0),
                ),
                new Text(
                  '时间：${data['niceDate']}',
                  style: new TextStyle(fontSize: 11.0),
                ),
              ],
            ),
          )
        ],
      ),
    );

    return new GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) {
              return new ArticleWebView(
                data: data,
              );
            },
          ),
        );
      },
      child: new Card(
        child: row,
      ),
    );
  }
}
