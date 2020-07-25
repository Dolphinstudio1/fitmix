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

import 'package:fittmix/imageviewer.dart';


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
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
  StorageUploadTask imageUploadTask;
  StorageUploadTask musicUploadTask;
  var uploadComplete = false;

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

    final List<Widget> children = <Widget>[
      if (selectContantsFlag == false) Text('Choose a mix for upload') else selectContents(),

      //if (imageFile != null && musicFile != null) enableUpload() else Text(''),
      //if (_tasks.length == uploadCounter) Text('Jeee')
      ];

    if (selectContantsFlag == false) _floatingActionButtonShow = true;

      _tasks.forEach((StorageUploadTask task) {
        final Widget tile = UploadTaskListTile(
          task: task,
          onDismissed: () => setState(() => _tasks.remove(task)),
          //onDownload: () => _downloadFile(task.lastSnapshot.ref),
          //onComplete: () => setState(() => ), //
        );
        if(selectContantsFlag == true)
          children.add(tile);
      });

    return Scaffold(
      //backgroundColor: Colors.blue,
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
            onPressed: selectContentsMethod)
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                  Icons.cloud_upload
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                  Icons.view_list
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImageViewer())
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget selectContents() {
    return Container(
      color: Colors.redAccent,
      child: Column(
        children: <Widget>[
        if(imageFile != null)
          Image.file(imageFile, height: 300.0, width: 300.0),
        if(imageUploadTask == null)
          RaisedButton(
            elevation: 7.0,
            child: Text('Choose a cover image'),
            textColor: Colors.white,
            color: Colors.pink,
            onPressed: _uploadImageFile
          ),
        if(musicUploadTask == null)
          RaisedButton(
            elevation: 7.0,
            child: Text('Choose a music file'),
            textColor: Colors.white,
            color: Colors.pink,
            onPressed: _uploadMusicFile
          ),
        if (imageFile != null && musicFile != null)
          RaisedButton(
            elevation: 7.0,
            child: Text('Upload'),
            textColor: Colors.white,
            color: Colors.pink,
            onPressed: () {
              _uploadFiles();
              setState(() {
                _tasks.add(imageUploadTask);
                _tasks.add(musicUploadTask);
                imageFile = null;
                musicFile = null;
              });
            },
          ),
        if(uploadComplete)
          RaisedButton(
              elevation: 7.0,
              child: Text('Done'),
              textColor: Colors.white,
              color: Colors.pink,
              onPressed:  () {
                _uploadFiles();
                setState(() {
                  uploadComplete = false;
                  selectContantsFlag = false;
                  imageUploadTask = null;
                  musicUploadTask = null;
                  _tasks.clear();
                });
              }
          )],
      ),
    );
  }

  Future _uploadFiles() async {
    final StorageReference firebaseStorageRefImage = firebaseStorage.ref().child(imageFileName);
    final StorageReference firebaseStorageRefMusic = firebaseStorage.ref().child(musicFileName);
    imageUploadTask = firebaseStorageRefImage.putFile(imageFile);
    musicUploadTask = firebaseStorageRefMusic.putFile(musicFile);

    var dowurl = await (await imageUploadTask.onComplete).ref.getDownloadURL();
    var imageUrl = dowurl.toString();
    print("Image URL is $imageUrl");
    final StorageTaskSnapshot downloadUrl = (await musicUploadTask.onComplete);
    final String musicUrl = (await downloadUrl.ref.getDownloadURL());
    print("Music URL is $musicUrl");

    if(imageUploadTask.isSuccessful && musicUploadTask.isSuccessful)
      setState(() {
        uploadComplete = true;
      });

    //eturn url;
  }

}

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed, this.onDownload, this.onComplete})
      : super(key: key);

  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;
  final VoidCallback onComplete;

  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status: ${_bytesTransferred(snapshot)} bytes sent');
        } else {
          subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task #${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                ),
              ],
            ),
          ),
          background: Container(
            color: Colors.greenAccent,
          ),
        );
      },
    );
  }
}