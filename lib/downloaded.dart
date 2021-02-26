import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Downloaded extends StatelessWidget {
  String _id;
  String _mixId;
  String _userId;

  Downloaded(this._id, this._mixId, this._userId);

  String get id => _id;
  String get mixId => _mixId;

  Downloaded.map(DocumentSnapshot document) {
    this._id = document.id;
    this._mixId = document.get('mixId');
    this._userId = document.get('userId');
  }

  Map<String, dynamic> toMap() {
    Map map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['mixId'] = _mixId;
    map['userId'] = _userId;
    return map;
  }

  Downloaded.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._mixId = map['eventId'];
    this._userId = map['userId'];
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
