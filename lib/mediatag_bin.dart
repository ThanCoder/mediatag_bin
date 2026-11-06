import 'dart:io';

import 'package:mediatag_bin/core/ffmpeg_b.dart';
import 'package:mediatag_bin/core/ffprobe_b.dart';
import 'package:mediatag_bin/core/keys.dart';
import 'package:mediatag_bin/core/utils.dart';

abstract class IMediatagBin {
  FFmpegB get ffmpeg;
  FFprobeB get ffprobe;
  bool get isSupported;
}

class MediatagBin implements IMediatagBin {
  static final MediatagBin instance = MediatagBin._();
  MediatagBin._();
  factory MediatagBin() => instance;

  @override
  late final FFmpegB ffmpeg = .new(_ffmpegLibPath);
  @override
  late final FFprobeB ffprobe = .new(_ffprobeLibPath);

  /// supported platforms
  @override
  bool get isSupported =>
      Platform.isAndroid || Platform.isLinux || Platform.isWindows;

  /// ffmpeg binary fullpath
  late String _ffmpegLibPath;
  late String _ffprobeLibPath;
  bool _debugLog = true;

  /// binary initailize
  Future<void> initailize({bool showDebugLog = true}) async {
    _debugLog = showDebugLog;
    _ffmpegLibPath = await getPlatformLibFullPath(ffmpegLibName);
    _ffprobeLibPath = await getPlatformLibFullPath(ffprobeLibName);

    if (Platform.isAndroid) return;

    await makeExecutableAndRun(_ffmpegLibPath);
    await makeExecutableAndRun(_ffprobeLibPath);
  }

  // show debug log
  void showDebugLog(String msg) {
    if (!_debugLog) return;
    // ignore: avoid_print
    print(msg);
  }
}
