import 'dart:io';

import 'package:mediatag_bin/core/ffmpeg_b.dart';
import 'package:mediatag_bin/core/ffprobe_b.dart';
import 'package:mediatag_bin/core/keys.dart';
import 'package:mediatag_bin/core/utils.dart';

class MediatagBin {
  static final MediatagBin instance = MediatagBin._();
  MediatagBin._();
  factory MediatagBin() => instance;

  late final FFmpegB ffmpeg = .new(_ffmpegLibPath);
  late final FFprobeB ffprobe = .new(_ffprobeLibPath);

  /// supported platforms
  bool get isSupported =>
      Platform.isAndroid || Platform.isLinux || Platform.isWindows;

  /// ffmpeg binary fullpath
  late String _ffmpegLibPath;
  late String _ffprobeLibPath;

  /// binary initailize
  Future<void> initailize({bool showDebugLog = true}) async {
    _ffmpegLibPath = await getPlatformLibFullPath(ffmpegLibName);
    _ffprobeLibPath = await getPlatformLibFullPath(ffprobeLibName);

    await makeExecutableAndRun(_ffmpegLibPath, showDebugLog: showDebugLog);
    await makeExecutableAndRun(_ffprobeLibPath, showDebugLog: showDebugLog);
  }
}
