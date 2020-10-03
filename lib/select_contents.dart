import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SelectContents extends StatelessWidget {
  File _imageFile;
  File _musicFile;
  StorageUploadTask _imageUploadTask;
  StorageUploadTask _musicUploadTask;
  Function _selectImageFile;
  Function _selectMusicFile;
  Function _uploadFiles;

  SelectContents(
    this._imageFile,
    this._musicFile,
    this._imageUploadTask,
    this._musicUploadTask,
    this._selectImageFile,
    this._selectMusicFile,
    this._uploadFiles,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: Column(
        children: <Widget>[
          if (_imageFile != null)
            Image.file(_imageFile, height: 300.0, width: 300.0),
          if (_imageUploadTask == null)
            RaisedButton(
                elevation: 7.0,
                child: Text('Choose a cover image'),
                textColor: Colors.white,
                color: Colors.pink,
                onPressed: _selectImageFile),
          if (_musicUploadTask == null)
            RaisedButton(
                elevation: 7.0,
                child: Text('Choose a music file'),
                textColor: Colors.white,
                color: Colors.pink,
                onPressed: _selectMusicFile),
          if (_imageFile != null && _musicFile != null)
            RaisedButton(
              elevation: 7.0,
              child: Text('Upload'),
              textColor: Colors.white,
              color: Colors.pink,
              onPressed: _uploadFiles,
            ),
        ],
      ),
    );
  }
}
