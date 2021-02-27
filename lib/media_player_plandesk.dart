import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmix/addmix.dart';
import 'package:fitmix/addmix_new.dart';
import 'package:flutter/material.dart';
import 'media_player_designed.dart';
import 'mix_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmix/login.dart';

class MediaPlayerPlan extends StatefulWidget {
  final String musicUrl;

  MediaPlayerPlan(this.musicUrl);

  @override
  _MediaPlayerPlanState createState() => _MediaPlayerPlanState();
}

class _MediaPlayerPlanState extends State<MediaPlayerPlan> {
  var blueColor = Color(0xFF090e42);
  var pinkColor = Color(0xFFff6b80);

  var mm = '🎵';
  var flume =
      'https://i.scdn.co/image/8d84f7b313ca9bafcefcf37d4e59a8265c7d3fff';
  var martinGarrix =
      'https://c1.staticflickr.com/2/1841/44200429922_d0cbbf22ba_b.jpg';
  var rosieLowe =
      'https://i.scdn.co/image/db8382f6c33134111a26d4bf5a482a1caa5f151c';

  static var adminUser = false;

  void settings() => null;

  _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    // TODO: implement initState
    /*FirebaseFirestore.instance
        .collection('users')
        .where('admins', arrayContainsAny: []).get()
    .then((querySnapshot));*/
    FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        List value = element.data()["admins"];
        print(value);
        for (final i in value) {
          if (adminUser == false) {
            if (i == Login.getUser().uid) {
              setState(() {
                adminUser = true;
              });
              print(adminUser);
            } else {
              setState(() {
                adminUser = false;
              });
            }
          }
        }
        /*Firestore.instance.collection("items").document(value[0]).get().then((value){
          print(value.data);
        });*/
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blueColor,
        /*appBar: new AppBar(
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("First"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Second"),
              ),
            ],
          )
        ],
      ),*/
        endDrawer: adminUser
            ? ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                child: Container(
                  width: 150,
                  child: new Drawer(
                      child: new ListView(
                    children: <Widget>[
                      Container(
                        color: blueColor,
                        child: new DrawerHeader(
                          child: new Text(
                            'Profile',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      new ListTile(
                        title: new Text(
                          'Add mix',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TaskManager())); //AddMix
                        },
                      ),
                      new ListTile(
                        title: new Text(
                          'Help',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {},
                      ),
                      //new Divider(),
                      new ListTile(
                        title: new Text(
                          'Log out',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          _signOut();
                        },
                      ),
                    ],
                  )),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                child: Container(
                  width: 150,
                  child: new Drawer(
                      child: new ListView(
                    children: <Widget>[
                      Container(
                        color: blueColor,
                        child: new DrawerHeader(
                          child: new Text(
                            'Profile',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      new ListTile(
                        title: new Text(
                          'Help',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {},
                      ),
                      //new Divider(),
                      new ListTile(
                        title: new Text(
                          'Log out',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          _signOut();
                        },
                      ),
                    ],
                  )),
                ),
              ),
        body: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 32.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomTextField(),
                    //adminUser
                    //?
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    )
                    /*PopupMenuButton<int>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case 1:
                              break;
                            case 2:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddMix())); //musicUrl
                              break;
                            case 3:
                              break;
                            case 4:
                              _signOut();
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text("Profile"),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Text("Add mix"),
                          ),
                          PopupMenuItem(
                            value: 3,
                            child: Text("Help"),
                          ),
                          PopupMenuItem(
                            value: 4,
                            child: Text("Log out"),
                          ),
                        ],
                      )*/
                    /*: PopupMenuButton<int>(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            onSelected: (value) {
                              switch (value) {
                                case 1:
                                  break;
                                case 2:
                                  break;
                                case 3:
                                  _signOut();
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text("Profile"),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text("Help"),
                              ),
                              PopupMenuItem(
                                value: 3,
                                child: Text("Log out"),
                              ),
                            ],
                          ),*/
                    /*IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    print("PopupMenu");

                  },
                  color: Colors.white,
                ),*/
                  ],
                ),
                SizedBox(
                  height: 32.0,
                ),
                Text(
                  'Collections',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 38.0),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: <Widget>[
                    ItemCardFavorite('Favorites', 'assets/images/favorites.png',
                        'Favorites'),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: <Widget>[
                    ItemCardDownloaded('Downloaded',
                        'assets/images/favorites.png', 'Downloaded'),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: <Widget>[
                    ItemCard('Kangoo', 'assets/images/kangoo.jpg', 'Kangoo'),
                    SizedBox(
                      width: 16.0,
                    ),
                    ItemCard(
                        'Aerobic', 'assets/images/aerobic.jpeg', 'Aerobic'),
                  ],
                ),
                SizedBox(
                  height: 32.0,
                ),
                Row(
                  children: <Widget>[
                    ItemCard('Box', 'assets/images/box.jpeg', 'Box'),
                    SizedBox(
                      width: 16.0,
                    ),
                    ItemCard('Yoga', 'assets/images/yoga.jpeg', 'Yoga'),
                  ],
                ),
                SizedBox(
                  height: 32.0,
                ),
                Text(
                  'Recommend',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 38.0),
                ),
                SizedBox(
                  height: 16.0,
                ),
                SongItem('Ine the name of love', 'Martin Garrix', martinGarrix,
                    widget.musicUrl),
                SongItem('Never be like you', 'Flume', flume, widget.musicUrl),
                SongItem(
                    'Worry bout us', 'Rosie Lowe', rosieLowe, widget.musicUrl),
                SongItem('Ine the name of love', 'Martin Garrix', martinGarrix,
                    widget.musicUrl),
                SongItem('Ine the name of love', 'Martin Garrix', martinGarrix,
                    widget.musicUrl),
              ],
            ),
          ),
        ));
  }
}

class SongItem extends StatelessWidget {
  final String title;
  final String artist;
  final image;
  String musicUrl;

  SongItem(this.title, this.artist, this.image, this.musicUrl);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetailedScreen(musicUrl, title, artist, image)));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 26.0),
        child: Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 80.0,
                  width: 80.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      image,
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
                )
              ],
            ),
            SizedBox(
              width: 16.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  artist,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 18.0),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.more_horiz,
              color: Colors.white.withOpacity(0.6),
              size: 32.0,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemCardFavorite extends StatelessWidget {
  final groupName;
  final image;
  final title;
  MixList mixList;

  ItemCardFavorite(this.groupName, this.image, this.title);

  @override
  Widget build(BuildContext context) {
    mixList = new MixList(groupName);
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => mixList));
            },
            child: Container(
              height: 60.0,
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      height: 140,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    right: 16.0,
                    top: 16.0,
                    child: Icon(
                      Icons.bookmark,
                      color: Colors.white.withOpacity(0.6),
                      size: 24.0,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

class ItemCardDownloaded extends StatelessWidget {
  final groupName;
  final image;
  final title;
  MixList mixList;

  ItemCardDownloaded(this.groupName, this.image, this.title);

  @override
  Widget build(BuildContext context) {
    mixList = new MixList(groupName);
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => mixList));
            },
            child: Container(
              height: 60.0,
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      height: 140,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    right: 16.0,
                    top: 16.0,
                    child: Icon(
                      Icons.bookmark,
                      color: Colors.white.withOpacity(0.6),
                      size: 24.0,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final groupName;
  final image;
  final title;

  ItemCard(this.groupName, this.image, this.title);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MixList(groupName)));
            },
            child: Container(
              height: 120.0,
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      height: 140,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    right: 16.0,
                    top: 16.0,
                    child: Icon(
                      Icons.bookmark,
                      color: Colors.white.withOpacity(0.6),
                      size: 24.0,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.grey.withOpacity(0.16),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 8.0,
            ),
            Icon(
              Icons.search,
              color: Colors.white,
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
                child: TextField(
              decoration: InputDecoration(
                  hintText: 'Search music...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
            )),
            SizedBox(
              width: 8.0,
            ),
            Icon(
              Icons.mic,
              color: Colors.white,
            ),
            SizedBox(
              width: 8.0,
            ),
          ],
        ),
      ),
    );
  }
}
