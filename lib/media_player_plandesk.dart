import 'package:flutter/material.dart';

class MediaPlayerPlan extends StatelessWidget {
  var blueColor = Color(0xFF090e42);
  var pinkColor = Color(0xFFff6b80);

  var mm = '🎵';

  var flume =
      'https://i.scdn.co/image/8d84f7b313ca9bafcefcf37d4e59a8265c7d3fff';
  var martinGarrix =
      'https://c1.staticflickr.com/2/1841/44200429922_d0cbbf22ba_b.jpg';
  var rosieLowe =
      'https://i.scdn.co/image/db8382f6c33134111a26d4bf5a482a1caa5f151c';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 32.0,
            ),
            CustomTextField(),
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
                ItemCard(
                    'assets/images/apple-music-note.jpg', 'Extremely loud'),
                SizedBox(
                  width: 16.0,
                ),
                ItemCard('assets/images/Rectangle13.png', 'Extremely loud'),
              ],
            ),
            SizedBox(
              height: 32.0,
            ),
            Row(
              children: <Widget>[
                ItemCard(
                    'assets/images/apple-music-note.jpg', 'Extremely loud'),
                SizedBox(
                  width: 16.0,
                ),
                ItemCard(
                    'assets/images/apple-music-note.jpg', 'Extremely loud'),
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
            SongItem('Ine the name of love', 'Martin Garrix', martinGarrix),
            SongItem('Never be like you', 'Flume', flume),
            SongItem('Worry bout us', 'Rosie Lowe', rosieLowe),
            SongItem('Ine the name of love', 'Martin Garrix', martinGarrix),
            SongItem('Ine the name of love', 'Martin Garrix', martinGarrix),
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

  SongItem(this.title, this.artist, this.image);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailedScreen(title, artist, image)));
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
  final image;
  final title;

  ItemCard(this.image, this.title);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
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
  const CustomTextField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class DetailedScreen extends StatelessWidget {
  var blueColor = Color(0xFF090e42);
  var pinkColor = Color(0xFFff6b80);

  final title;
  final artist;
  final image;

  DetailedScreen(this.title, this.artist, this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      body: Column(
        children: <Widget>[
          Container(
              height: 400.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(image), fit: BoxFit.cover)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [blueColor.withOpacity(0.4), blueColor],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 52.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(50.0)),
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  'Playlist',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.6)),
                                ),
                                Text(
                                  'Best vibes of the week',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.playlist_add,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          title,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 32.0),
                        ),
                        SizedBox(height: 6.0,),
                        Text(
                          artist,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 18.0),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                      ],
                    ),
                  )
                ],
              )),
          SizedBox(
            height: 42.0,
          ),
          Slider(
            value: 0.2,
            onChanged: (double value) {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '2:10',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                Text(
                  '-3:56',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              ],
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.fast_rewind,
                color: Colors.white54,
                size: 42,
              ),
              SizedBox(
                width: 32.0,
              ),
              Container(
                decoration: BoxDecoration(
                    color: pinkColor,
                    borderRadius: BorderRadius.circular(50.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.play_arrow,
                    size: 58.0,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 32.0,
              ),
              Icon(
                Icons.fast_forward,
                color: Colors.white54,
                size: 42,
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                Icons.bookmark_border,
                color: pinkColor,
              ),
              Icon(
                Icons.shuffle,
                color: pinkColor,
              ),
              Icon(
                Icons.repeat,
                color: pinkColor,
              ),
            ],
          ),
          SizedBox(height: 58.0,)
        ],
      ),
    );
  }
}
