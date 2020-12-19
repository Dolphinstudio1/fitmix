import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import 'media_player_designed.dart';

class LocalstoreHelper {
  static Future<bool> checkLocalFile(String title) async {
    Directory dir = await getApplicationDocumentsDirectory();
    /*String mp3Path = dir.toString();
    print(mp3Path);
    print(url);
    List<FileSystemEntity> _files;
    List<FileSystemEntity> _songs = [];
    _files = dir.listSync(recursive: true, followLinks: false);
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      print(title);
      if (path.endsWith('$title.mp3')) _songs.add(entity);
    }
    print(_songs);
    print(_songs.length);
    if (_songs.length == 1) {
      isLocalFileExist = true;
      localFilePath = _songs[0].toString();
      //final file = new File('${(await getTemporaryDirectory()).path}/$title.mp3');
      //localFilePath = file.path;
      print("Local "+localFilePath);
    }*/

    final file = File('${dir.path}/$title.mp3');
    if (await file.exists()) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getLocalFile(String title) async {
    Directory dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$title.mp3');
    return file.path;
  }

  static Future<Uint8List> _loadFileBytes(String url, {OnError onError}) async {
    Uint8List bytes;
    try {
      bytes = await readBytes(url);
    } on ClientException {
      rethrow;
    }
    return bytes;
  }

  static Future<String> loadFile(String url, String title) async {
    final bytes = await _loadFileBytes(url,
        onError: (Exception exception) =>
            print('_loadFile => exception $exception')); //kUrl

    final dir = await getApplicationDocumentsDirectory();
    print(dir.path);
    print(dir.parent);
    final file = File('${dir.path}/$title.mp3');
    print(file);

    await file.writeAsBytes(bytes);
    return file.path;
  }
}
