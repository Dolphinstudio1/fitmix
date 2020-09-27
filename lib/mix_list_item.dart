import 'package:flutter/material.dart';

class MixListItem extends StatelessWidget {

  final String title;
  final String imageUrl;

  MixListItem(this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(child: Row(children: <Widget>[Text(title)]),); //Image(image: null), 
  }
}
