import 'package:firebase_core/firebase_core.dart';
import 'package:fitmix/downloaded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'mix_list_item.dart';
import 'media_player_designed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'favorite.dart';
import 'login.dart';
import 'localstore_helper.dart';
import 'media_player_plandesk.dart' as plandesk;

class MixList extends StatefulWidget {
  final String groupName;

  const MixList(this.groupName, {Key key}) : super(key: key);

  @override
  _MixListState createState() => _MixListState();
}

class _MixListState extends State<MixList> {
  //final groupName;
  var blueColor = Color(0xFF090e42);
  List<SongItem> _mixListItems = <SongItem>[];

  //var mixElements = ['Mix1', 'Mix2'];
  final firestoreInstance = FirebaseFirestore.instance;

  //final GlobalKey<_MixListState> _myKey = GlobalKey();

  /*_MixListState(this.groupName) {
    /*mixElements.forEach((element) {
      _mixListItems.add(MixListItem(element, imageUrl));
    });*/

    //setState(() {});
  }*/

  void _queryDocs() async {
    //var firebaseUser = await FirebaseAuth.instance.currentUser();

    /*.then((value) {
        print(value.docs.length);
        print(value.docs.data());
      });*/
  }

  List<Favorite> favorites = [];
  List<Downloaded> downloaded = [];

  //List<SongItem> favoriteMixes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavoriteList();
    getDownloadedList();
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

  void getFavoriteList() {
    FirestoreHelper.getUserFavorites(Login.getUser().uid).then((data) {
      setState(() {
        favorites = data;
        if (widget.groupName == "Favorites") {
          fetchAllFavoriteMixes(membersIDS: favorites).then((value) {
            setState(() {
              _mixListItems = value;
            });
          });
        }
      });
    });
  }

  void getDownloadedList() {
    FirestoreHelper.getUserDownloaded(Login.getUser().uid).then((data) {
      setState(() {
        downloaded = data;
        if (widget.groupName == "Downloaded") {
          fetchAllDownloadedMixes(membersIDS: downloaded).then((value) {
            setState(() {
              _mixListItems = value;
            });
          });
        }
      });
    });
  }

  var ref = FirebaseFirestore.instance.collection('mixes');

  List<dynamic> membersIDS = [
    "0tDoh4xSSAQ9kK8ljytc",
    "0wp3YJys36rPHCAvrgXV",
    "73oviVSRdHIys3AlWj5j",
    "vrWaSt1lj1JeiirWQAae"
  ];

  /// Fetch members list
  Future<List<SongItem>> fetchAllFavoriteMixes({List<Favorite> membersIDS}) async {
    /*/// With whereIn
    var result = await ref.where('uid', whereIn: membersIDS).get();
    print(result.docs);
    //var documents = result.docs.map((doc) => User.fromMap(doc.data, doc.id)).toList();
    //return documents;*/

    /// With loop
    List<SongItem> results = [];
    for (Favorite userID in membersIDS) {
      print(userID.mixId);
      await ref.doc(userID.mixId).get().then((result) {
        //print(result.data());
        results.add(SongItem(
            result.id,
            result.get("bmp_value"),
            result.get("mix_name"),
            'artist',
            result.get("iamge_url"),
            result.get("mix_url"),
            widget.groupName,
            favorites,
            downloaded,
            //refreshCallback: () {getFavoriteList()}
            favoritesCallback: getFavoriteList, downloadedCallback: getDownloadedList));
      });
    }
    //print(results);
    return results;
  }

  /// Fetch members list
  Future<List<SongItem>> fetchAllDownloadedMixes({List<Downloaded> membersIDS}) async {
    /*/// With whereIn
    var result = await ref.where('uid', whereIn: membersIDS).get();
    print(result.docs);
    //var documents = result.docs.map((doc) => User.fromMap(doc.data, doc.id)).toList();
    //return documents;*/

    /// With loop
    List<SongItem> results = [];
    for (Downloaded userID in membersIDS) {
      print(userID.mixId);
      await ref.doc(userID.mixId).get().then((result) {
        //print(result.data());
        results.add(SongItem(
            result.id,
            result.get("bmp_value"),
            result.get("mix_name"),
            'artist',
            result.get("iamge_url"),
            result.get("mix_url"),
            widget.groupName,
            favorites,
            downloaded,
            //refreshCallback: () {getFavoriteList()}
            favoritesCallback: getFavoriteList, downloadedCallback: getDownloadedList));
      });
    }
    //print(results);
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    //final child = KeyedSubtree(key: _myKey, child: widget.child);

    //print(groupName);
    //print('mixListLenght2 - ' + _mixListItems.length.toString());

    /*_mixListItems.forEach((SongItem mixListItem) {
      children.add(mixListItem);
    });*/

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
                    print(FieldPath.documentId);
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
            child: (widget.groupName == 'Favorites' || widget.groupName == 'Downloaded')
                ?
                //print(favoriteMixes.length);
                ListView.builder(
                    itemCount: _mixListItems.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return _mixListItems[index];
                    })
                /*StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance
                .collection("mixes")//.get()
                //.doc(),
                .where(FieldPath.documentId, whereIn: [])
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
                })*/
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("mixes")
                        .where('group_name', isEqualTo: widget.groupName)
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
                                  list[index].get("bpm_value"),
                                  list[index].get("mix_name"), //.substring(0, list[index].get("mix_name").length - 4)
                                  'artist',
                                  list[index].get("iamge_url"),
                                  list[index].get("mix_url"),
                                  widget.groupName,
                                  favorites,
                                  downloaded);
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
  final int bpm;
  final String title;
  final String artist;
  final String image;
  final String musicUrl;
  final String groupName;
  List<Favorite> favorites;
  List<Downloaded> downloaded;

  //final RefreshCallback refreshCallback;
  final VoidCallback favoritesCallback;
  final VoidCallback downloadedCallback;

  SongItem(
      this.mixId,
      this.bpm,
      this.title,
      this.artist,
      this.image,
      this.musicUrl,
      this.groupName,
      this.favorites,
      this.downloaded,
      //{this.refreshCallback}
      {this.favoritesCallback,this.downloadedCallback});

  @override
  _SongItemState createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {
  String localFilePath;
  bool isLocalFileExist = false;

  //RefreshCallback refreshCallback;

  @override
  void initState() {
    super.initState();
    LocalstoreHelper.checkLocalFile(widget.title).then((value) {
      if (value) {
        LocalstoreHelper.getLocalFile(widget.title).then((value) {
          setState(() {
            localFilePath = value;
            isLocalFileExist = true;
          });
        });
      }
    });
    //refreshCallback = widget.refreshCallback;
  }

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
    //refreshCallback();
    widget.favoritesCallback();
  }

  bool isUserDownloaded(String mixId) {
    Downloaded downloaded = widget.downloaded
        .firstWhere((Downloaded d) => (d.mixId == mixId), orElse: () => null);
    if (downloaded == null)
      return false;
    else
      return true;
  }

  toggleDownloaded(String mixId) async {
    if (isUserDownloaded(mixId)) {
      Downloaded downloaded =
      widget.downloaded.firstWhere((Downloaded d) => (d.mixId == mixId));
      String favId = downloaded.id;
      await FirestoreHelper.deleteDownloaded(favId);
    } else {
      await FirestoreHelper.addDownloaded(mixId, Login.getUser().uid);
    }
    List<Downloaded> updatedDownloaded =
    await FirestoreHelper.getUserDownloaded(Login.getUser().uid);
    setState(() {
      widget.downloaded = updatedDownloaded;
      print("Downloaded - " + widget.downloaded.toString());
    });
    //refreshCallback();
    widget.downloadedCallback();
  }

  @override
  Widget build(BuildContext context) {
    //Color starColor = (isUserFavorite(widget.mixId) ? Colors.amber : Colors.grey);
    Icon starIcon = (isUserFavorite(widget.mixId)
        ? Icon(Icons.star_outlined)
        : Icon(Icons.star_border_outlined));
    Icon arrowIcon = isLocalFileExist //(isUserDownloaded(widget.mixId)
        ? Icon(Icons.download_rounded)
        : Icon(Icons.download_outlined); //)

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailedScreen(widget.bpm, widget.musicUrl,
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
                  if (widget.groupName == "Favorites" &&
                      isUserFavorite(widget.mixId)) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: Text(widget.title),
                        content: Text("Töröljük a kedvencekből?"),
                        actions: [
                          CupertinoDialogAction(
                            child: Text("Mégsem"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: Text("Törlés"),
                            onPressed: () {
                              toggleFavorite(widget.mixId);
                              //plandesk.ItemCardFavorite;
                              /*Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => MixList('Favorites')));*/
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    toggleFavorite(widget.mixId);
                    print("MixId - " + widget.mixId);
                  }
                },
              ),
              IconButton(
                icon: arrowIcon,
                color: Colors.white.withOpacity(0.6),
                iconSize: 30.0,
                onPressed: () {
                  if (!isLocalFileExist) {
                    print("Push _loadFile");
                    print(widget.musicUrl);
                    toggleDownloaded(widget.mixId);
                    LocalstoreHelper.loadFile(widget.musicUrl, widget.title)
                        .then((value) => setState(() {
                              localFilePath = value;
                              isLocalFileExist = true;
                              print("Local - " + localFilePath);
                            }));
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: Text(widget.title),
                        content: Text("Töröljük a mentett fájlt?"),
                        actions: [
                          CupertinoDialogAction(
                            child: Text("Mégsem"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: Text("Törlés"),
                            onPressed: () {
                              toggleDownloaded(widget.mixId);
                              LocalstoreHelper.getLocalFile(widget.title).then((value){
                                setState(() {
                                  isLocalFileExist = false;
                                  LocalstoreHelper.deleteFile(value);
                                });
                              });
                              //plandesk.ItemCardFavorite;
                              /*Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => MixList('Favorites')));*/
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//typedef RefreshCallback = void Function();
