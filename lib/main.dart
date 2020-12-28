import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmix/login.dart';
import 'package:fitmix/media_player_plandesk.dart';
import 'package:fitmix/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

//import 'dart:html' as html;
//Image plugin

//File picker web plugin
//import 'package:file_picker_web/file_picker_web.dart';
//Firebase storage plugin

import 'package:audioplayer/audioplayer.dart';
import 'media_player.dart';

import 'media_player_adv.dart';
import 'media_player_custom.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'add_mix_to_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
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
  //upload

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
  }*/

  /*@override
  void initState() {
    //initializeFlutterFire();
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  User user = snapshot.data;

                  if (user == null) {
                    return Login();
                  } else {
                    return MediaPlayerPlan(
                        'https://firebasestorage.googleapis.com/v0/b/fitt-mix.appspot.com/o/13443305_Money_EXTENDED_VERSION.mp3?alt=media&token=610463aa-f77b-47ae-8f78-07186ef45893');
                  }
                }

                return Scaffold(
                  body: Center(
                    child: Text("Checking Authentication"),
                  ),
                );
              },
            );
          }

          return Scaffold(
            body: Center(
              child: Text("Checking Authentication"),
            ),
          );
        });

    //AudioApp('https://firebasestorage.googleapis.com/v0/b/fitt-mix.appspot.com/o/13443305_Money_EXTENDED_VERSION.mp3?alt=media&token=610463aa-f77b-47ae-8f78-07186ef45893');
    //ExampleApp('https://firebasestorage.googleapis.com/v0/b/fitt-mix.appspot.com/o/13443305_Money_EXTENDED_VERSION.mp3?alt=media&token=610463aa-f77b-47ae-8f78-07186ef45893');
    /*Scaffold(
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
            children: , //if ()
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
    );*/
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
