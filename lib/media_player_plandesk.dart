import 'package:fittmix/addmix.dart';
import 'package:flutter/material.dart';
import 'media_player_designed.dart';
import 'mix_list.dart';

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

  void settings() => null;

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
      body: Padding(
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
                PopupMenuButton<int>(
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
                                builder: (context) => AddMix())); //musicUrl
                        break;
                      case 3:
                        break;
                      case 4:
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
                ),
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
                ItemCard('Kangoo', 'assets/images/kangoo.jpg', 'Kangoo'),
                SizedBox(
                  width: 16.0,
                ),
                ItemCard('Aerobic', 'assets/images/aerobic.jpeg', 'Aerobic'),
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
            SongItem('Worry bout us', 'Rosie Lowe', rosieLowe, widget.musicUrl),
            SongItem('Ine the name of love', 'Martin Garrix', martinGarrix,
                widget.musicUrl),
            SongItem('Ine the name of love', 'Martin Garrix', martinGarrix,
                widget.musicUrl),
          ],
        ),
      ),
    );
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
