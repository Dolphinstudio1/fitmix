import 'package:flutter/material.dart';
import 'dart:io';
//import 'dart:html' as html;
import 'package:path/path.dart' as path;

//Image plugin
import 'package:image_picker/image_picker.dart';

//File picker web plugin
//import 'package:file_picker_web/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';

//Firebase storage plugin
import 'package:firebase_storage/firebase_storage.dart';


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
  File imageFile;
  File musicFile;
  final picker = ImagePicker();
  bool _floatingActionButtonShow = true;
  bool selectContantsFlag = false;
  var imageFileName;
  var musicFileName;
  final firebaseStorage = FirebaseStorage.instance;
  //StorageReference listRef = firebaseStorage.ref().child("files/uid");
  //List<StorageUploadTask> _tasks = <StorageUploadTask>[];

  Future _uploadImageFile() async {
    //final tempImage = await picker.getImage(source: ImageSource.gallery);
    File chosenImage = await FilePicker.getFile(type: FileType.image);
    imageFileName = path.basename(chosenImage.path);
    print("imageFileName - " + imageFileName);
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
      imageFile = File(chosenImage.path);
    });
  }

  Future _uploadMusicFile() async {
    File file = await FilePicker.getFile(type: FileType.audio);
    musicFileName = path.basename(file.path);
    print("musicFileName - " + musicFileName);

    setState(() {
      musicFile = file;
    });
  }

  void selectContentsMethod() {
    _floatingActionButtonShow = false;
    setState(() {
      selectContantsFlag = true;
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

    /*final List<Widget> children = <Widget>[];
    _tasks.forEach((StorageUploadTask task) {
      final Widget tile = UploadTaskListTile(
        task: task,
        onDismissed: () => setState(() => _tasks.remove(task)),
        onDownload: () => _downloadFile(task.lastSnapshot.ref),
      );
      children.add(tile);
    });*/

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
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
          children: <Widget>[
            Text(
              '',
            ),
            /*Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),*/

            if (selectContantsFlag == false) Text('Choose a mix for upload') else selectContents(),
            //imageFile == null? selectContents() : selectContents(), //enableUpload()
            if(imageFile != null && musicFile != null) enableUpload() else Text(''),
            //var dowurl = await (await imageUploadTask.onComplete).firebaseStorageRefImage.getDownloadURL();
          ],
        ),



      ),
      floatingActionButton: Visibility(
        visible: _floatingActionButtonShow,
        child: FloatingActionButton(
            tooltip: 'Upload', child: Icon(Icons.add), onPressed: selectContentsMethod)
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget selectContents() {
    return Container(
      child: Column(
        children: <Widget>[
        if(imageFile != null)
          Image.file(imageFile, height: 300.0, width: 300.0),
        RaisedButton(
          elevation: 7.0,
          child: Text('Choose a cover image'),
          textColor: Colors.white,
          color: Colors.pink,
          onPressed: _uploadImageFile
        ),
        RaisedButton(
          elevation: 7.0,
          child: Text('Choose a music file'),
          textColor: Colors.white,
          color: Colors.pink,
          onPressed: _uploadMusicFile
        )],
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[
          RaisedButton(
            elevation: 7.0,
            child: Text('Upload'),
            textColor: Colors.white,
            color: Colors.pink,
            onPressed: () {
              final StorageReference firebaseStorageRefImage = firebaseStorage.ref().child(imageFileName);
              final StorageReference firebaseStorageRefMusic = firebaseStorage.ref().child(musicFileName);
              final StorageUploadTask imageUploadTask = firebaseStorageRefImage.putFile(imageFile);
              final StorageUploadTask musicUploadTask = firebaseStorageRefMusic.putFile(musicFile);
              setState(() {
                selectContantsFlag = false;
                imageFile = null;
                musicFile = null;
                _floatingActionButtonShow = true;
              });
            },
          )
          //final storageTaskSnapshot = await task.onComplete;
        ],
      ),
    );
  }

  /*Future<String> uploadImage(var imageFile ) async {
    StorageReference ref = storage.ref().child("/photo.jpg");
    StorageUploadTask uploadTask = ref.putFile(imageFile);

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    url = dowurl.toString();

    return url;
  }*/

}