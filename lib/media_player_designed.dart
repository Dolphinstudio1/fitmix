import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'localstore_helper.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }
enum PlayingRouteState { speakers, earpiece }

class DetailedScreen extends StatefulWidget {
  final bpm;
  final String url;
  final title;
  final artist;
  final image;

  DetailedScreen(this.bpm, this.url, this.title, this.artist, this.image);

  @override
  State<StatefulWidget> createState() {
    return _DetailedScreen(bpm, url, title, artist, image);
  }
}

class _DetailedScreen extends State<DetailedScreen> {
  var blueColor = Color(0xFF090e42);
  var pinkColor = Color(0xFFff6b80);

  final bpm;
  String url;
  PlayerMode mode = PlayerMode.MEDIA_PLAYER;
  final title;
  final artist;
  final image;

  int currentBpm; //126

  AudioPlayer _audioPlayer;

  String localFilePath;
  bool isLocalFileExist = false;

  AudioPlayerState _audioPlayerState;
  Duration _duration = Duration(seconds: 0);
  Duration _position = Duration(seconds: 0);

  PlayerState _playerState = PlayerState.stopped;
  PlayingRouteState _playingRouteState = PlayingRouteState.speakers;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;
  StreamSubscription<PlayerControlCommand> _playerControlCommandSubscription;

  double playbackRate = 1.0;

  _DetailedScreen(this.bpm, this.url, this.title, this.artist, this.image);

  get _isPlaying => _playerState == PlayerState.playing;

  get _isPaused => _playerState == PlayerState.paused;

  //get _durationText => _duration?.toString()?.split('.')?.first ?? '';

  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  get _positionNegativeText =>
      (_duration - _position)?.toString()?.split('.')?.first ?? '';

  get _isPlayingThroughEarpiece =>
      _playingRouteState == PlayingRouteState.earpiece;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    selectPlayMethod();
    currentBpm = bpm;
  }

  void selectPlayMethod() {
    LocalstoreHelper.checkLocalFile(title).then((value) {
      if (value) {
        LocalstoreHelper.getLocalFile(title).then((value) {
          localFilePath = value;
          isLocalFileExist = true;
          _playLocal();
        });
      } else {
        _play();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerControlCommandSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Icon arrowIcon = isLocalFileExist
        ? Icon(Icons.download_rounded)
        : Icon(Icons.download_outlined);

    return Scaffold(
      //appBar: AppBar(title: Text('')),
      backgroundColor: blueColor,
      body: Column(
        children: <Widget>[
          Container(
              height: 382.0,
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
                          colors: [blueColor, blueColor.withOpacity(0)], //0.4
                          begin: Alignment.topCenter,
                          end: Alignment.center),
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
                              child: IconButton(
                                icon: Icon(Icons.arrow_back),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Container(
                              /*decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(50.0)),*/
                              child: IconButton(
                                icon: arrowIcon,
                                //arrow_drop_down
                                color: Colors.white,
                                onPressed: () {
                                  if (!isLocalFileExist) {
                                    print("Push _loadFile");
                                    LocalstoreHelper.loadFile(url, title)
                                        .then((value) => setState(() {
                                              localFilePath = value;
                                              isLocalFileExist = true;
                                              print("Local - " + localFilePath);
                                            }));
                                  }
                                },
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
                        /*Text(
                          title,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 32.0),
                        ),*/
                        SizedBox(
                          height: 6.0,
                        ),
                        /*Text(
                          artist,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 18.0),
                        ),*/
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
            value: (_position != null &&
                    _duration != null &&
                    _position.inMilliseconds > 0 &&
                    _position.inMilliseconds < _duration.inMilliseconds)
                ? _position.inMilliseconds / _duration.inMilliseconds
                : 0.0,
            onChanged: (v) {
              final Position = v * _duration.inMilliseconds;
              _audioPlayer.seek(Duration(milliseconds: Position.round()));
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _position != null ? '${_positionText ?? ''}' : '',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                Text(
                  _duration != null ? '${_positionNegativeText ?? ''}' : '',
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
                Icons.skip_previous, //fast_rewind
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
                  child: !_isPlaying
                      ? IconButton(
                          icon: Icon(Icons.play_arrow),
                          iconSize: 40.0,
                          color: Colors.white,
                          onPressed: () {
                            selectPlayMethod();
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.pause),
                          iconSize: 40.0,
                          color: Colors.white,
                          onPressed: _pause,
                        ),
                ),
              ),
              SizedBox(
                width: 32.0,
              ),
              Icon(
                Icons.skip_next, //fast_forward
                color: Colors.white54,
                size: 42,
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.remove),
                  color: pinkColor,
                  onPressed: () => _bpmCalculator('-')),
              Container(
                  /*decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50.0)),*/
                  child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  currentBpm.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24),
                ),
              )),
              IconButton(
                  icon: Icon(Icons.add),
                  color: pinkColor,
                  onPressed: () => _bpmCalculator('+')),
            ],
          ),
          Spacer(),
          /*Row(
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
          ),*/
          SizedBox(
            height: 58.0,
          )
        ],
      ),
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      // TODO implemented for iOS, waiting for android impl
      /*if (Theme.of(context).platform == TargetPlatform.iOS) {
        // (Optional) listen for notification updates in the background
        _audioPlayer.startHeadlessService();

        // set at least title to see the notification bar on ios.
        _audioPlayer.setNotification(
          title: 'App Name',
          artist: 'Artist or blank',
          albumTitle: 'Name or blank',
          imageUrl: 'url or blank',
          // forwardSkipInterval: const Duration(seconds: 30), // default is 30s
          // backwardSkipInterval: const Duration(seconds: 30), // default is 30s
          duration: duration,
          elapsedTime: Duration(seconds: 0),
          hasNextTrack: true,
          hasPreviousTrack: false,
        );
      }*/
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _playerControlCommandSubscription =
        _audioPlayer.onPlayerCommand.listen((command) {
      print('command');
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _audioPlayerState = state);
    });

    _playingRouteState = PlayingRouteState.speakers;
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(url, position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(playbackRate: playbackRate);

    return result;
  }

  Future _playLocal() async {
    await _audioPlayer.play(localFilePath, isLocal: true);
    setState(() => _playerState = PlayerState.playing);
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _earpieceOrSpeakersToggle() async {
    final result = await _audioPlayer.earpieceOrSpeakersToggle();
    if (result == 1)
      setState(() => _playingRouteState =
          _playingRouteState == PlayingRouteState.speakers
              ? PlayingRouteState.earpiece
              : PlayingRouteState.speakers);
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }

  void _bpmCalculator(String setBpmSignal) {

    setState(() {
      if (setBpmSignal == '+') {
        currentBpm++;
      } else if (setBpmSignal == '-') {
        currentBpm--;
      }

      playbackRate = currentBpm / bpm;
      print(playbackRate.toString());
      _audioPlayer.setPlaybackRate(playbackRate: playbackRate);
    });
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('bpm', currentBpm));
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
