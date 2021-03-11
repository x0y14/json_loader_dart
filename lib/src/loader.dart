import 'dart:io' as io;
import 'dart:async';
import 'dart:io';

import 'package:json_loader/src/type.dart';

import 'type.dart';


class Loader {

  Future<bool> isFile(String path) async {
    return await io.File(path).exists();
  }

  Future<bool> isDir(String path) async {
    return await io.Directory(path).exists();
  }

  Future<PathType> existPath(String path) async {
    if (await isFile(path)) {
      return PathType.FILE;
    }
    if (await isDir(path)) {
      return PathType.DIR;
    }
    return PathType.NOTFOUND;
  }

  Future<String> readFile(String path) async {
    var pathType = await existPath(path);
    if (pathType == PathType.DIR) {
      throw Exception('This is Directory.');
    }
    if (pathType == PathType.NOTFOUND) {
      throw Exception('Not found.');
    }
    return await File(path).readAsString();
  }

}