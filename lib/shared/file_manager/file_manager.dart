import 'dart:async';
import 'dart:io';

class FileManager {
  static String wordsPath = 'words';

  static Future<String?> read(String fileName) async {
    final file = File(fileName);

    if (await file.exists()) {
      return await file.readAsString();
    }

    return null;
  }

  static Future<void> write(
      String dirName, String fileName, String data) async {
    // so, it`s very bad realization

    var dir = Directory(dirName);
    var file = File('$dirName/$fileName');

    if (await dir.exists()) {
      await file.writeAsString(data);
    } else {
      await dir.create();
      await file.writeAsString(data);
    }
  }

  static Future<List<FileSystemEntity>> ls() async {
    List<FileSystemEntity> files = [];

    var completer = Completer<List<FileSystemEntity>>();
    var lister = Directory(wordsPath).list(recursive: false);

    lister.listen((file) => files.add(file),
        // should also register onError
        onDone: () => completer.complete(files));

    var result = await completer.future;
    result.sort((a, b) {
      final aS = a.path.split('/')[1];
      final bS = b.path.split('/')[1];

      return aS.toLowerCase().compareTo(bS.toLowerCase());
    });

    return result;
  }
}
