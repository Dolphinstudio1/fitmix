import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'mix_list_item.dart';
import 'media_player_designed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'favorite.dart';
import 'login.dart';

class MixList extends StatefulWidget {
  String groupName;

  @override
  _MixListState createState() => _MixListState(groupName);

  MixList(this.groupName);
}

class _MixListState extends State<MixList> {
  final groupName;
  var blueColor = Color(0xFF090e42);
  final List<SongItem> _mixListItems = <SongItem>[];

  //var mixElements = ['Mix1', 'Mix2'];
  final firestoreInstance = FirebaseFirestore.instance;

  _MixListState(this.groupName) {
    /*mixElements.forEach((element) {
      _mixListItems.add(MixListItem(element, imageUrl));
    });*/

    //setState(() {});
  }

  void _queryDocs() async {
    //var firebaseUser = await FirebaseAuth.instance.currentUser();

    /*.then((value) {
        print(value.docs.length);
        print(value.docs.data());
      });*/
  }

  List<Favorite> favorites = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirestoreHelper.getUserFavorites(Login.getUser().uid).then((data) {
      setState(() {
        favorites = data;
      });
    });

    /*firestoreInstance
        .collection('mixes')
        .where('group_name', isEqualTo: groupName)
        /*.get().then((data) => print(data.docs[0].data()['mix_name'].toString()));*/
        /*.snapshots()
        .listen((data) => print(data.docs[0].data()['mix_name'].toString()));*/
        //.doc(f)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                print(doc.data());
                print(doc.exists);
                //print(doc.metadata);
                print(doc.id);
                //print(doc.data().values);
                print(doc.get("image_name"));
                print(doc.get("mix_name"));
                print(doc.get("iamge_url"));
                print(doc.get("mix_url"));
                _mixListItems.add(SongItem(doc.get("mix_name"), 'Andris',
                    doc.get("iamge_url"), doc.get("mix_url")));
              })
            });*/
    //print(groupName);
    print('mixListLenght1 - ' + _mixListItems.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    //print(groupName);
    //print('mixListLenght2 - ' + _mixListItems.length.toString());

    _mixListItems.forEach((SongItem mixListItem) {
      children.add(mixListItem);
    });

    //children.add(SongItem('title', 'artist', 'image', 'musicUrl'));

    return Scaffold(
      backgroundColor: blueColor,
      /*appBar: AppBar(
        title: Text(
          "Mix List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),*/
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 52.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Best vibes of the week',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddMix())); //musicUrl*/
                  },
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("mixes")
                    .where('group_name', isEqualTo: groupName)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> querySnapshot) {
                  if (querySnapshot.hasError) return Text("Some error");
                  if (querySnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    final list = querySnapshot.data.docs;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          //DocumentSnapshot data = querySnapshot.data[index];
                          return SongItem(
                              list[index].id,
                              list[index].get("mix_name").substring(
                                  0, list[index].get("mix_name").length - 4),
                              'artist',
                              list[index].get("iamge_url"),
                              list[index].get("mix_url"),
                              favorites);
                        },
                        itemCount: list.length,
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class SongItem extends StatefulWidget {
  final String mixId;
  final String title;
  final String artist;
  final String image;
  final String musicUrl;
  List<Favorite> favorites;

  SongItem(this.mixId, this.title, this.artist, this.image, this.musicUrl,
      this.favorites);

  @override
  _SongItemState createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {
  bool isUserFavorite(String mixId) {
    Favorite favorite = widget.favorites
        .firstWhere((Favorite f) => (f.mixId == mixId), orElse: () => null);
    if (favorite == null)
      return false;
    else
      return true;
  }

  toggleFavorite(String mixId) async {
    if (isUserFavorite(mixId)) {
      Favorite favorite =
          widget.favorites.firstWhere((Favorite f) => (f.mixId == mixId));
      String favId = favorite.id;
      await FirestoreHelper.deleteFavorite(favId);
    } else {
      await FirestoreHelper.addFavorite(mixId, Login.getUser().uid);
    }
    List<Favorite> updatedFavorites =
        await FirestoreHelper.getUserFavorites(Login.getUser().uid);
    setState(() {
      widget.favorites = updatedFavorites;
      print("Favorites - " + widget.favorites.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Color starColor =
        (isUserFavorite(widget.mixId) ? Colors.amber : Colors.grey);
    Icon starIcon = (isUserFavorite(widget.mixId)
        ? Icon(Icons.star_outlined)
        : Icon(Icons.star_border_outlined));

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailedScreen(widget.musicUrl,
                          widget.title, widget.artist, widget.image)));
            },
            child: Stack(
              children: <Widget>[
                Container(
                  height: 80.0,
                  width: 80.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 80.0,
                  width: 80.0,
                  child: Icon(
                    Icons.play_circle_filled,
                    color: Colors.white.withOpacity(0.7),
                    size: 42.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  widget.artist,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 18.0),
                ),
              ],
            ),
          ),
          //Spacer(),
          Column(
            children: [
              IconButton(
                icon: starIcon,
                color: Colors.white.withOpacity(0.6),
                iconSize: 30.0,
                onPressed: () {
                  toggleFavorite(widget.mixId);
                  print("MixId - " + widget.mixId);
                },
              ),
              IconButton(
                icon: Icon(Icons.download_outlined),
                color: Colors.white.withOpacity(0.6),
                iconSize: 30.0,
                onPressed: () {
                  //_loadFile();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
