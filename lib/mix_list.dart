import 'package:flutter/material.dart';
import 'mix_list_item.dart';

class MixList extends StatelessWidget {
  final String imageUrl;
  final List<MixListItem> _mixListItems = <MixListItem>[];
  var mixElements = ['Mix1', 'Mix2'];

  MixList(this.imageUrl) {
    mixElements.forEach((element) {
      _mixListItems.add(MixListItem(element, imageUrl));
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    _mixListItems.forEach((MixListItem mixListItem) {
      children.add(mixListItem);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mix List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: Column(children: children),
    );
  }
}
