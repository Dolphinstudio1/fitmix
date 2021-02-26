import 'package:fitmix/add_mix_to_database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitmix/imageviewer.dart';
import 'mix_list.dart';
import 'select_contents.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMix extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<AddMix> {
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
  int _value = 0;
  String groupName;

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
    _musicFileName = path.basenameWithoutExtension(file.path);
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

  CollectionReference mixes = FirebaseFirestore.instance.collection('mixes');

  Future<void> addMix() {
    // Call the user's CollectionReference to add a new user
    return mixes
        .add({
          'group_name': groupName,
          'image_name': _imageFileName, // John Doe
          'iamge_url': imageUrl, // Stokes and Sons
          'mix_name': _musicFileName,
          'mix_url': musicUrl,
          //'upload_date': uploadDate // 42
        })
        .then((value) => print("Mix Added"))
        .catchError((error) => print("Failed to add mix: $error"));
  }

  @override
  Widget build(BuildContext context) {
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

      //PaypalapploginWidget(),
      //PaypalappwalletWidget(),
      //PayPalLogin(),
      //MusicPlayerFreebie(),

      /*RaisedButton(onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                MediaPlayerPlan(
                    'https://firebasestorage.googleapis.com/v0/b/fitt-mix.appspot.com/o/13443305_Money_EXTENDED_VERSION.mp3?alt=media&token=610463aa-f77b-47ae-8f78-07186ef45893'))); //musicUrl
      }, child: Text('Designed'),),

      RaisedButton(onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => PlayerWidget(url: musicUrl)));
      }, child: Text('Default'),),*/

      //if (imageFile != null && musicFile != null) enableUpload() else Text(''),
      //if (_tasks.length == uploadCounter) Text('Jeee')
    ];

    List<String> elements = ['Kangoo', 'Aerobic', 'Box', 'Yoga'];

    if (selectContantsFlag == true) {
      children.add(
        new DropdownButton<int>(
          value: _value,
          items: <int>[0, 1, 2, 3].map((int value) {
            return new DropdownMenuItem<int>(
              value: value,
              child: new Text(elements[value]),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _value = value;
              groupName = elements[value];
            });
          },
        ),
      );
      children.add(SelectContents(
        _imageFile,
        _musicFile,
        _imageUploadTask,
        _musicUploadTask,
        _selectImageFile,
        _selectMusicFile,
        _uploadFiles,
      ));
    } else if (_uploadComplete)
      children.add(RaisedButton(
          elevation: 7.0,
          child: Text('Done'),
          textColor: Colors.white,
          color: Colors.pink,
          onPressed: _uploadDone));
    else
      children.add(Text('Choose a mix for upload'));

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
      /*WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayerWidget(url: musicUrl)));
        //final Widget tile1 =
        //children.add(tile1);
      });*/
      addMix();
      //children.add(AddMixDatabase(groupName, _imageFileName, imageUrl, _musicFileName, musicUrl));
      //children.add(PaypalapploginWidget);
      //Navigator.pop(context);
    }

    //AudioPlayer audioPlugin = AudioPlayer();
    //audioPlugin.play(musicUrl);

    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: children),
      ),
      floatingActionButton: Visibility(
          visible: _floatingActionButtonShow,
          child: FloatingActionButton(
              tooltip: 'Upload',
              child: Icon(Icons.add),
              onPressed: selectContentsMethod)),
    );
  }
}
