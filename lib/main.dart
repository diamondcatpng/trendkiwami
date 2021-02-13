import 'package:flutter/material.dart';

import 'menu.dart';
import 'widget/hello_world.dart';
import 'widget/image_test.dart';
import 'widget/word.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  final _title = 'トレンド極';

  var _menuIndex = 0;
  final _menuItems = [
    MenuItem(
      icon: Icon(Icons.tag),
      title: 'ワード',
      widget: WordWidget(),
    ),
    MenuItem(
      icon: Icon(Icons.check),
      title: 'おすすめ',
      widget: ImageTestWidget(),
    ),
    MenuItem(
      icon: Icon(Icons.videocam),
      title: '配信中',
      widget: HelloWorldWidget(),
    ),
  ];

  void _menuSwitch(int index) {
    print(index);
    setState(() => _menuIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          centerTitle: true,
          backgroundColor: Colors.black87,
        ),
        body: _menuItems.elementAt(_menuIndex).widget,
        bottomNavigationBar: MenuWidget(
          index: _menuIndex,
          items: _menuItems,
          tap: _menuSwitch,
        ),
      ),
    );
  }
}
