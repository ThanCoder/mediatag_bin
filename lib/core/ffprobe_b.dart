import 'package:mediatag_bin/core/i_binary.dart';
import 'package:mediatag_bin/result_t.dart';
import 'package:mediatag_bin/core/types/file_info_res.dart';

class FFprobeB extends IBinary {
  new(super.libPath);

  /// audio,video file info or null
  Future<FileInfoRes?> getFileInfoOrNull(String path) async {
    final res = await getFileInfo(path);
    return switch (res) {
      Ok(value: final val) => val,
      Err() => null,
    };
  }

  /// audio,video file info or null
  FileInfoRes? getFileInfoOrNullSync(String path) {
    final res = getFileInfoSync(path);
    return switch (res) {
      Ok(value: final val) => val,
      Err() => null,
    };
  }

  /// audio,video file info
  Future<Result<FileInfoRes, String>> getFileInfo(String path) async {
    // ffprobe -v quiet -print_format json -show_format -show_streams
    final res = await run([
      '-v',
      'quiet',
      '-print_format',
      'json',
      '-show_format',
      '-show_streams',
      path,
    ]);
    return res.fold(
      onErr: (err) => Err(err),
      onOk: (val) {
        final err = val.stderr.toString();
        if (err.isNotEmpty) {
          return Err(err);
        }
        return Ok(.new(val.stdout.toString()));
      },
    );
  }

  /// audio,video file info
  Result<FileInfoRes, String> getFileInfoSync(String path) {
    // ffprobe -v quiet -print_format json -show_format -show_streams
    final res = runSync([
      '-v',
      'quiet',
      '-print_format',
      'json',
      '-show_format',
      '-show_streams',
      path,
    ]);
    return res.fold(
      onErr: (err) => Err(err),
      onOk: (val) {
        final err = val.stderr.toString();
        if (err.isNotEmpty) {
          return Err(err);
        }
        return Ok(.new(val.stdout.toString()));
      },
    );
  }
}
