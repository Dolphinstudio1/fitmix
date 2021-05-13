import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

//import 'package:audio_picker/audio_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

//import 'save_as/save_as.dart';

/// Enum representing the upload task types the example app supports.
enum UploadType {
  /// Uploads a randomly generated string (as a file) to Storage.
  string,

  /// Uploads a file from the device.
  file,

  /// Clears any tasks from the list.
  clear,
}

/// A StatefulWidget which keeps track of the current uploaded files.
class TaskManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskManager();
  }
}

class _TaskManager extends State<TaskManager> {
  FilePickerResult _imageFile;
  FilePickerResult _mixFile;
  File _selectedImage;
  File _selectedMix;
  UploadTask _imageTask;
  UploadTask _mixTask;
  List<firebase_storage.UploadTask> _uploadTasks = [];

  bool _floatingActionButtonShow = true;
  bool selectContantsFlag = false;

  int _value = 0;
  String groupName;
  String imageUrl;
  String musicUrl;

  set metadataImage(SettableMetadata metadataImage) {}

  /// The user selects a file, and the task is added to the list.
  Future<firebase_storage.UploadTask> uploadFile(File file) async {
    if (file == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No file was selected")));
      return null;
    }

    print(file);
    print(file.path);
    print(path.extension(file.path));

    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference refImage;
    firebase_storage.Reference refAudio;

    if (path.extension(file.path) == '.jpg' ||
        path.extension(file.path) == '.png') {
      // Create a Reference to the file
      refImage = firebase_storage.FirebaseStorage.instance
          .ref()
          //.child('playground')
          .child('/' +
              path.basenameWithoutExtension(_imageFile.files.single.path) +
              '.jpg');

      final metadataImage = firebase_storage.SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': file.path});
      print('Image file path ' + file.path);

      if (kIsWeb) {
        uploadTask = refImage.putData(await file.readAsBytes(), metadataImage);
      } else {
        uploadTask = refImage.putFile(io.File(file.path), metadataImage);
      }
    } else {
      refAudio = firebase_storage.FirebaseStorage.instance
          .ref()
          //.child('playground')
          .child('/' +
              path.basenameWithoutExtension(_mixFile.files.single.path) +
              '.mp3');

      final metadataAudio = firebase_storage.SettableMetadata(
          contentType: 'audio/mp3',
          customMetadata: {'picked-file-path': file.path});
      print('Audio file path ' + file.path);

      if (kIsWeb) {
        uploadTask = refAudio.putData(await file.readAsBytes(), metadataAudio);
      } else {
        uploadTask = refAudio.putFile(io.File(file.path), metadataAudio);
      }
    }

    return Future.value(uploadTask);
  }

  /// A new string is uploaded to storage.
  firebase_storage.UploadTask uploadString() {
    const String putStringText =
        'This upload has been generated using the putString method! Check the metadata too!';

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        //.child('playground')
        .child('/put-string-example.txt');

    // Start upload of putString
    return ref.putString(putStringText,
        metadata: firebase_storage.SettableMetadata(
            contentLanguage: 'en',
            customMetadata: <String, String>{'example': 'putString'}));
  }

  /// Handles the user pressing the PopupMenuItem item.
  void handleUploadType(UploadType type) async {
    switch (type) {
      /*case UploadType.string:
        setState(() {
          _uploadTasks = [..._uploadTasks, uploadString()];
        });
        break;*/
      case UploadType.file:
        //PickedFile _imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
        //firebase_storage.UploadTask imageTask = await uploadFile(_imageFile);

        /*var mixPath = await AudioPicker.pickAudio();
        _selectedMix = File(mixPath);*/

        if (true) {
          setState(() {
            _uploadTasks = [..._uploadTasks, _imageTask];
            _uploadTasks = [..._uploadTasks, _mixTask];
          });
        }
        break;
      case UploadType.clear:
        setState(() {
          _uploadTasks = [];
        });
        break;
    }
  }

  Future _selectImageFile() async {
    _imageFile = await FilePicker.platform.pickFiles(type: FileType.image);
    print('_imageFile ' + _imageFile.toString());
    _imageTask = await uploadFile(File(_imageFile.files.single.path));
    print(_imageTask.toString());

    var downUrl = await _imageTask.snapshot.ref.getDownloadURL();
    imageUrl = downUrl.toString();

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      //_counter++;
      _selectedImage = File(_imageFile.files.single.path);
      print('_selectedImage ' + _selectedImage.toString());
      print('_selectedMix ' +
          path
              .basenameWithoutExtension(_imageFile.files.single.path)
              .toString());
    });
  }

  Future _selectMusicFile() async {
    _mixFile = await FilePicker.platform.pickFiles(type: FileType.audio);
    print('_mixFile ' + _mixFile.toString());
    _mixTask = await uploadFile(File(_mixFile.files.single.path));
    print(_mixTask);

    var downUrl = await _mixTask.snapshot.ref.getDownloadURL();
    musicUrl = downUrl.toString();

    setState(() {
      _selectedMix =
          File(path.basenameWithoutExtension(_mixFile.files.single.path));
      print('_selectedMix ' + _selectedMix.toString());
      print('_selectedMix ' +
          path.basenameWithoutExtension(_mixFile.files.single.path).toString());
    });
  }

  CollectionReference mixes = FirebaseFirestore.instance.collection('mixes');

  Future<void> addMix() {
    // Call the user's CollectionReference to add a new user
    return mixes
        .add({
          'group_name': groupName,
          'image_name': path
              .basenameWithoutExtension(_imageFile.files.single.path)
              .toString(), // John Doe
          'iamge_url': imageUrl, // Stokes and Sons
          'mix_name': path
              .basenameWithoutExtension(_mixFile.files.single.path)
              .toString(),
          'mix_url': musicUrl,
          //'upload_date': uploadDate // 42
        })
        .then((value) => print("Mix Added"))
        .catchError((error) => print("Failed to add mix: $error"));
  }

  _removeTaskAtIndex(int index) {
    setState(() {
      _uploadTasks = _uploadTasks..removeAt(index);
    });
  }

  Future<void> _downloadBytes(firebase_storage.Reference ref) async {
    final bytes = await ref.getData();
    // Download...
    //await saveAsBytes(bytes, 'some-image.jpg');
  }

  Future<void> _downloadLink(firebase_storage.Reference ref) async {
    final link = await ref.getDownloadURL();

    await Clipboard.setData(ClipboardData(
      text: link,
    ));

    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
      'Success!\n Copied download URL to Clipboard!',
    )));
  }

  Future<void> _downloadFile(firebase_storage.Reference ref) async {
    final io.Directory systemTempDir = io.Directory.systemTemp;
    final io.File tempFile = io.File('${systemTempDir.path}/temp-${ref.name}');
    if (tempFile.existsSync()) await tempFile.delete();

    await ref.writeToFile(tempFile);

    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
      'Success!\n Downloaded ${ref.name} \n from bucket: ${ref.bucket}\n '
      'at path: ${ref.fullPath} \n'
      'Wrote "${ref.fullPath}" to tmp-${ref.name}.txt',
    )));
  }

  List<String> elements = ['Kangoo', 'Aerobic', 'Box', 'Yoga'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Storage Example App'),
          actions: [
            PopupMenuButton<UploadType>(
                onSelected: handleUploadType,
                icon: Icon(Icons.add),
                itemBuilder: (context) => [
                      const PopupMenuItem(
                          child: Text("Upload string"),
                          value: UploadType.string),
                      const PopupMenuItem(
                          child: Text("Upload local file"),
                          value: UploadType.file),
                      if (_uploadTasks.isNotEmpty)
                        PopupMenuItem(
                            child: Text("Clear list"), value: UploadType.clear)
                    ])
          ],
        ),
        body: _uploadTasks.isEmpty
            ? //Center(child: Text("Press the '+' button to add a new file."))
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (true)
                    Container(
                      alignment: Alignment.center,
                      child: new DropdownButton<int>(
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
                    ),
                  if (_selectedImage != null)
                    Image.file(_selectedImage, height: 300.0, width: 300.0),
                  if (_imageTask == null)
                    ElevatedButton(
                        child: Text('Choose a cover image'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.pink,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: _selectImageFile),
                  if (_mixTask == null)
                    ElevatedButton(
                        child: Text('Choose a music file'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.pink,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: _selectMusicFile),
                  if (_selectedImage != null && _selectedMix != null)
                    ElevatedButton(
                      child: Text('Upload'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.pink,
                          textStyle: TextStyle(color: Colors.white)),
                      onPressed: () {
                        addMix();
                        handleUploadType(UploadType.file);
                      },
                    ),
                ],
              )
            : ListView.builder(
                itemCount: _uploadTasks.length,
                itemBuilder: (context, index) => UploadTaskListTile(
                    task: _uploadTasks[index],
                    onDismissed: () => _removeTaskAtIndex(index),
                    onDownloadLink: () {
                      return _downloadLink(_uploadTasks[index].snapshot.ref);
                    },
                    onDownload: () {
                      if (kIsWeb) {
                        return _downloadBytes(_uploadTasks[index].snapshot.ref);
                      } else {
                        return _downloadFile(_uploadTasks[index].snapshot.ref);
                      }
                    })),
        /*floatingActionButton: Visibility(
            visible: _floatingActionButtonShow,
            child: FloatingActionButton(
                tooltip: 'Upload',
                child: Icon(Icons.add),
                onPressed: _selectImageFile))*/);
  }
}

/// Displays the current state of a single UploadTask.
class UploadTaskListTile extends StatelessWidget {
  // ignore: public_member_api_docs
  const UploadTaskListTile(
      {Key key,
      this.task,
      this.onDismissed,
      this.onDownload,
      this.onDownloadLink})
      : super(key: key);

  /// The [UploadTask].
  final firebase_storage.UploadTask /*!*/ task;

  /// Triggered when the user dismisses the task from the list.
  final VoidCallback /*!*/ onDismissed;

  /// Triggered when the user presses the download button on a completed upload task.
  final VoidCallback /*!*/ onDownload;

  /// Triggered when the user presses the "link" button on a completed upload task.
  final VoidCallback /*!*/ onDownloadLink;

  /// Displays the current transferred bytes of the task.
  String _bytesTransferred(firebase_storage.TaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalBytes}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<firebase_storage.TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (BuildContext context,
            AsyncSnapshot<firebase_storage.TaskSnapshot> asyncSnapshot) {
          Widget subtitle = Text('---');
          firebase_storage.TaskSnapshot snapshot = asyncSnapshot.data;
          firebase_storage.TaskState state = snapshot?.state;

          if (asyncSnapshot.hasError) {
            if (asyncSnapshot.error is firebase_core.FirebaseException &&
                (asyncSnapshot.error as firebase_core.FirebaseException).code ==
                    'canceled') {
              subtitle = Text('Upload canceled.');
            } else {
              print(asyncSnapshot.error);
              subtitle = Text('Something went wrong.');
            }
          } else if (snapshot != null) {
            subtitle =
                Text('${state}: ${_bytesTransferred(snapshot)} bytes sent');
          }

          return Dismissible(
            key: Key(task.hashCode.toString()),
            onDismissed: ($) => onDismissed(),
            child: ListTile(
              title: Text('Upload Task #${task.hashCode}'),
              subtitle: subtitle,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (state == firebase_storage.TaskState.running)
                    IconButton(
                      icon: Icon(Icons.pause),
                      onPressed: () => task.pause(),
                    ),
                  if (state == firebase_storage.TaskState.running)
                    IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () => task.cancel(),
                    ),
                  if (state == firebase_storage.TaskState.paused)
                    IconButton(
                      icon: Icon(Icons.file_upload),
                      onPressed: () => task.resume(),
                    ),
                  if (state == firebase_storage.TaskState.success)
                    IconButton(
                      icon: Icon(Icons.file_download),
                      onPressed: () => onDownload(),
                    ),
                  if (state == firebase_storage.TaskState.success)
                    IconButton(
                      icon: Icon(Icons.link),
                      onPressed: () => onDownloadLink(),
                    ),
                ],
              ),
            ),
          );
        });
  }
}
