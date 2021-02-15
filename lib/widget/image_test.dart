import 'package:flutter/material.dart';

class ImageTestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
        'https://pbs.twimg.com/media/EooWa1EU8AAuPD3?format=jpg&name=large',
      ),
    );
  }
}
