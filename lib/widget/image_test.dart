import 'package:flutter/material.dart';

class ImageTestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://pbs.twimg.com/media/Et1O05-VIAQPdb1?format=jpg&name=medium',
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
      alignment: Alignment.center,
    );
  }
}
