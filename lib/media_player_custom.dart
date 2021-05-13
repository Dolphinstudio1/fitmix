import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/foundation/constants.dart';

import 'player_widget.dart';

typedef void OnError(Exception exception);

class MediaPlayerApp extends StatefulWidget {
  final String musicUrl;

  MediaPlayerApp(this.musicUrl);

  @override
  _MediaPlayerAppState createState() => _MediaPlayerAppState(musicUrl);
}

class _MediaPlayerAppState extends State<MediaPlayerApp> {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  String localFilePath;
  String musicUrl;

  _MediaPlayerAppState(String musicUrl) {
    this.musicUrl = musicUrl;
  }

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // Calls to Platform.isIOS fails on web
      return;
    }
    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      advancedPlayer.startHeadlessService();
    }
  }

  Future _loadFile() async {
    final bytes = await rootBundle.load(musicUrl);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    if (await file.exists()) {
      setState(() {
        localFilePath = file.path;
      });
    }
  }

  Widget remoteUrl() {
    return SingleChildScrollView(
      child: _Tab(children: [
        Text(
          'Sample 1 ($musicUrl)',
          key: Key('url1'),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ]),
    );
  }

  Widget localFile() {
    return _Tab(children: [
      Text('File: $musicUrl'),
      _Btn(txt: 'Download File to your Device', onPressed: () => _loadFile()),
      Text('Current local file path: $localFilePath'),
      localFilePath == null
          ? Container()
          : PlayerWidget(
              url: localFilePath,
            ),
    ]);
  }

  Widget localAsset() {
    return SingleChildScrollView(
      child: _Tab(children: [
        Text('Play Local Asset \'audio.mp3\':'),
        _Btn(txt: 'Play', onPressed: () => audioCache.play('audio.mp3')),
        getLocalFileDuration(),
      ]),
    );
  }

  Future<int> _getDuration() async {
    File audiofile = await audioCache.load('audio2.mp3');
    await advancedPlayer.setUrl(
      audiofile.path,
    );
    int duration = await Future.delayed(
        Duration(seconds: 2), () => advancedPlayer.getDuration());
    return duration;
  }

  getLocalFileDuration() {
    return FutureBuilder<int>(
      future: _getDuration(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('No Connection...');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('Awaiting result...');
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return Text(
                'audio2.mp3 duration is: ${Duration(milliseconds: snapshot.data)}');
        }
        return null; // unreachable
      },
    );
  }

  Widget notification() {
    return _Tab(children: [
      Text('Play notification sound: \'messenger.mp3\':'),
      _Btn(
          txt: 'Play',
          onPressed: () =>
              audioCache.play('messenger.mp3', isNotification: true)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Duration>.value(
            initialData: Duration(),
            value: advancedPlayer.onAudioPositionChanged),
      ],
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                //Tab(text: 'Remote Url'),
                //Tab(text: 'Local File'),
                //Tab(text: 'Local Asset'),
                //Tab(text: 'Notification'),
                Tab(text: 'Advanced'),
              ],
            ),
            title: Text('audioplayers Example'),
          ),
          body: TabBarView(
            children: [
              //remoteUrl(),
              //localFile(),
              //localAsset(),
              //notification(),
              Advanced(
                advancedPlayer: advancedPlayer,
                musicUrl: musicUrl,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Advanced extends StatefulWidget {
  final AudioPlayer advancedPlayer;
  final String musicUrl;

  const Advanced({Key key, this.advancedPlayer, this.musicUrl})
      : super(key: key);

  @override
  _AdvancedState createState() => _AdvancedState(musicUrl);
}

class _AdvancedState extends State<Advanced> {
  bool seekDone;
  final String musicUrl;

  _AdvancedState(this.musicUrl);

  /*@override
  void initState() {
    widget.advancedPlayer.seekCompleteHandler =
        (finished) => setState(() => seekDone = finished);
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    final audioPosition = Provider.of<Duration>(context);
    return SingleChildScrollView(
      child: _Tab(
        children: [
          Column(children: [
            PlayerWidget(url: musicUrl),
          ]),
          Column(children: [
            Text('Source Url'),
            Row(children: [
              _Btn(
                  txt: 'Audio 1',
                  onPressed: () {
                    widget.advancedPlayer.setUrl(musicUrl);
                    print(musicUrl);
                  }), //=>
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          ]),
          Column(children: [
            Text('Control'),
            Row(children: [
              _Btn(
                  txt: 'resume',
                  onPressed: () => widget.advancedPlayer.resume()),
              _Btn(
                  txt: 'pause', onPressed: () => widget.advancedPlayer.pause()),
              _Btn(txt: 'stop', onPressed: () => widget.advancedPlayer.stop()),
              _Btn(
                  txt: 'release',
                  onPressed: () => widget.advancedPlayer.release()),
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          ]),
          Column(children: [
            Text('Rate'),
            Row(children: [
              _Btn(
                  txt: '0.5',
                  onPressed: () =>
                      widget.advancedPlayer.setPlaybackRate(playbackRate: 0.5)),
              _Btn(
                  txt: '1.0',
                  onPressed: () =>
                      widget.advancedPlayer.setPlaybackRate(playbackRate: 1.0)),
              _Btn(
                  txt: '1.5',
                  onPressed: () =>
                      widget.advancedPlayer.setPlaybackRate(playbackRate: 1.5)),
              _Btn(
                  txt: '2.0',
                  onPressed: () =>
                      widget.advancedPlayer.setPlaybackRate(playbackRate: 2.0)),
            ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          ]),
          Text('Audio Position: ${audioPosition}'),
          seekDone == null
              ? SizedBox(
                  width: 0,
                  height: 0,
                )
              : Text(seekDone ? "Seek Done" : "Seeking..."),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final List<Widget> children;

  const _Tab({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: children
                .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String txt;
  final VoidCallback onPressed;

  const _Btn({Key key, this.txt, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        minWidth: 48.0,
        child: RaisedButton(child: Text(txt), onPressed: onPressed));
  }
}
