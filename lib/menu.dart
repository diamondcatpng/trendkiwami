import 'package:flutter/material.dart';

class MenuItem {
  final Icon icon;
  final String title;
  final Widget widget;

  const MenuItem({this.icon, this.title, this.widget});
}

class MenuWidget extends StatelessWidget {
  final int index;
  final List<MenuItem> items;
  final Function(int) tap;

  const MenuWidget({this.index, this.items, this.tap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items.map((item) {
        return BottomNavigationBarItem(
          icon: item.icon,
          label: item.title,
        );
      }).toList(),
      currentIndex: index,
      selectedItemColor: Colors.black87,
      onTap: tap,
    );
  }
}
