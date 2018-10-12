import 'package:flutter/material.dart';
import 'movie_news.dart';
import 'read_time.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Movie News',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class FaIcons {
  FaIcons._();
  static const String FONT_FAMILY_FLYOU = 'flyou';
  static const IconData movies =
      const IconData(0xe650, fontFamily: FONT_FAMILY_FLYOU);
  static const IconData read =
      const IconData(0xe763, fontFamily: FONT_FAMILY_FLYOU);
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    pages..add(MoiveNews())..add(ReadTime());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.movie),
            title: new Text('电影资讯'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.assignment),
            title: new Text('码农精选'),
          ),
        ],
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: pages[_currentIndex],
    );
  }
}
