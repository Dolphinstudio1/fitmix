import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMixDatabase extends StatelessWidget {
  final int groupNumber;
  final String imageName;
  final String imageUrl;
  final String mixName;
  final String mixUrl;

  //final DateTime uploadDate;

  final firestoreInstance = FirebaseFirestore.instance;

  AddMixDatabase(this.groupNumber, this.imageName, this.imageUrl, this.mixName,
      this.mixUrl); //this.uploadDate

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection

    CollectionReference mixes = FirebaseFirestore.instance.collection('mixes');

    Future<void> addMix() {
      // Call the user's CollectionReference to add a new user
      return mixes
          .add({
            'group_number': groupNumber,
            'image_name': imageName, // John Doe
            'iamge_url': imageUrl, // Stokes and Sons
            'mix_name': mixName,
            'mix_url': mixUrl,
            //'upload_date': uploadDate // 42
          })
          .then((value) => print("Mix Added"))
          .catchError((error) => print("Failed to add mix: $error"));
    }

    void _queryDocs() async {
      //var firebaseUser = await FirebaseAuth.instance.currentUser();
      firestoreInstance
          .collection('mixes')
          //.doc(f)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) {
                  print(doc.data());
                  print(doc.exists);
                  print(doc.metadata);
                  print(doc.id);
                  print(doc.data().values);
                  print(doc.get("image_name"));
                })
              });
      /*.then((value) {
        print(value.docs.length);
        print(value.docs.data());
      });*/
    }

    return Column(
      children: [
        FlatButton(
          onPressed: addMix,
          child: Text(
            "Add Mix",
          ),
        ),
        FlatButton(
          onPressed: _queryDocs,
          child: Text(
            "Query Docs",
          ),
        )
      ],
    );
  }
}
