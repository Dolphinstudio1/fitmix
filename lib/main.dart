import 'package:fittmix/media_player_plandesk.dart';
import 'package:fittmix/music_player_freebie.dart';
import 'package:fittmix/paypal_login1.dart';
import 'package:fittmix/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:io';

//import 'dart:html' as html;
//Image plugin
import 'package:image_picker/image_picker.dart';

//File picker web plugin
//import 'package:file_picker_web/file_picker_web.dart';
//Firebase storage plugin
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fittmix/imageviewer.dart';
import 'mix_list.dart';
import 'package:audioplayer/audioplayer.dart';
import 'media_player.dart';
import 'music_player_freebie1.dart';
import 'paypal_profile.dart';
import 'select_contents.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

import 'upload.dart';

import 'media_player_adv.dart';
import 'media_player_custom.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_mix_to_database.dart';
import 'paypal_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitt mix',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Fitt Mix'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  final picker = ImagePicker();
  bool _floatingActionButtonShow = true;
  bool selectContantsFlag = false;

  //StorageReference listRef = firebaseStorage.ref().child("files/uid");
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
  bool _uploadComplete = false;
  String musicUrl;
  String imageUrl;
  var listResult;
  final musicUrlTest =
      'https://firebasestorage.googleapis.com/v0/b/fitt-mix.appspot.com/o/13443305_Money_EXTENDED_VERSION.mp3?alt=media&token=b0331efb-f128-41f1-9327-44441b4ecc74';
  var startPlayer = false;
  var startUpload = false;

  File _imageFile;
  File _musicFile;
  String _imageFileName;
  String _musicFileName;

  final firebaseStorage = FirebaseStorage.instance;
  StorageUploadTask _imageUploadTask;
  StorageUploadTask _musicUploadTask;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Define an async function to initialize FlutterFire
  /*void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }*/

  void selectContentsMethod() {
    _floatingActionButtonShow = false;
    setState(() {
      selectContantsFlag = true;
    });
  }

  Future _selectImageFile() async {
    //final tempImage = await picker.getImage(source: ImageSource.gallery);
    File chosenImage = await FilePicker.getFile(type: FileType.image);
    _imageFileName = path.basename(chosenImage.path);
    print("imageFileName - " + _imageFileName);
    /*floatingActionButton: Visibility(
      child: FloatingActionButton(onPressed: ),
      visible: false, // set it to false
    )*/

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      //_counter++;
      _imageFile = File(chosenImage.path);
    });
  }

  Future _selectMusicFile() async {
    File file = await FilePicker.getFile(type: FileType.audio);
    _musicFileName = path.basename(file.path);
    print("musicFileName - " + _musicFileName);

    setState(() {
      _musicFile = file;
    });
  }

  Future _uploadFiles() async {
    final StorageReference firebaseStorageRefImage =
        firebaseStorage.ref().child(_imageFileName);
    final StorageReference firebaseStorageRefMusic =
        firebaseStorage.ref().child(_musicFileName);
    _imageUploadTask = firebaseStorageRefImage.putFile(_imageFile);
    _musicUploadTask = firebaseStorageRefMusic.putFile(_musicFile);

    var downUrl =
        await (await _imageUploadTask.onComplete).ref.getDownloadURL();
    imageUrl = downUrl.toString();
    print("Image URL is $imageUrl");

    final StorageTaskSnapshot downloadUrl = (await _musicUploadTask.onComplete);
    musicUrl = (await downloadUrl.ref.getDownloadURL());
    print("Music URL is $musicUrl");

    //if (_imageUploadTask.isSuccessful && _musicUploadTask.isSuccessful)

    setState(() {
      _uploadComplete = true;
      _tasks.add(_imageUploadTask);
      _tasks.add(_musicUploadTask);
      _imageFile = null;
      _musicFile = null;
      startUpload = true;
      selectContantsFlag = false;
    });

    //eturn url;
  }

  void _uploadDone() {
    setState(() {
      startUpload = false;
      _uploadComplete = false;
      _imageUploadTask = null;
      _musicUploadTask = null;
      _tasks.clear();
      //getFirebaseImageFolder();
      startPlayer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    // Show error message if initialization failed
    if (_error) {
      //return SomethingWentWrong();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      //return Loading();
    }

    final List<Widget> children = <Widget>[
      //Text(listResult.toString()),

      if (selectContantsFlag == true)
        SelectContents(
          _imageFile,
          _musicFile,
          _imageUploadTask,
          _musicUploadTask,
          _selectImageFile,
          _selectMusicFile,
          _uploadFiles,
        )
      else if (_uploadComplete)
        RaisedButton(
            elevation: 7.0,
            child: Text('Done'),
            textColor: Colors.white,
            color: Colors.pink,
            onPressed: _uploadDone)
      else
        Text('Choose a mix for upload'),
      //PaypalapploginWidget(),
      //PaypalappwalletWidget(),
      //PayPalLogin(),
      //MusicPlayerFreebie(),

      RaisedButton(onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MediaPlayerPlan()));
      }, child: Text('Designed'),),

      RaisedButton(onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PlayerWidget(url: musicUrl)));
      }, child: Text('Default'),),

      //if (imageFile != null && musicFile != null) enableUpload() else Text(''),
      //if (_tasks.length == uploadCounter) Text('Jeee')
    ];

    if (selectContantsFlag == false) _floatingActionButtonShow = true;

    if (startUpload) {
      _tasks.forEach((StorageUploadTask task) {
        final Widget tile = UploadTaskListTile(
          task: task,
          onDismissed: () => setState(() => _tasks.remove(task)),
          //onDownload: () => _downloadFile(task.lastSnapshot.ref),
          //onComplete: () => setState(() => ), //
        );
        children.add(tile);
      });
    }

    if (startPlayer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayerWidget(url: musicUrl)));
        //final Widget tile1 =
        //children.add(tile1);
      });
      children
          .add(AddMix(1, _imageFileName, imageUrl, _musicFileName, musicUrl));
      //children.add(PaypalapploginWidget);
    }

    //AudioPlayer audioPlugin = AudioPlayer();
    //audioPlugin.play(musicUrl);

    return Scaffold(
      //backgroundColor: Colors.blue,
      /*appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),*/
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
          /*<Widget>[
            ,
            /*Expanded(
                child: ListView(
                  children: ,
                )),*/
            /*Text(
              '',
            ),*/
            /*Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),*/


            //imageFile == null? selectContents() : selectContents(), //enableUpload()

            //var dowurl = await (await imageUploadTask.onComplete).firebaseStorageRefImage.getDownloadURL();
          ],*/
        ),
      ),
      floatingActionButton: Visibility(
          visible: _floatingActionButtonShow,
          child: FloatingActionButton(
              tooltip: 'Upload',
              child: Icon(Icons.add),
              onPressed: selectContentsMethod)),
      // This trailing comma makes auto-formatting nicer for build methods.
      /*bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.cloud_upload),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlayerWidget(
                            url:
                                'https://firebasestorage.googleapis.com/v0/b/fitt-mix.appspot.com/o/13443305_Money_EXTENDED_VERSION.mp3?alt=media&token=5c29f319-fe84-4664-adbd-ed4a042f09c3'))); //ImageViewer()
                //getFirebaseImageFolder;
              },
            ),
            IconButton(
              icon: Icon(Icons.view_list),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MixList(imageUrl)));
              },
            )
          ],
        ),
      ),*/
    );
    //home: AudioApp,
  }

/*void getFirebaseImageFolder() {
    final StorageReference storageRef = FirebaseStorage.instance
        .ref()
        .child('/'); //.child('Gallery').child('Images')
    storageRef.listAll().then((result) {
      //print("result is $result");
      listResult = result;
      //print(listResult);
      print(listResult.values.toList()[2].values.toList()[0].values.toList());
      print(listResult.values.toList()[2].values.toList()[0]);
      print(listResult.values.toList()[2]);
      print(listResult);
    });
  }*/
}
