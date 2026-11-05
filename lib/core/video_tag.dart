import 'package:mediatag_bin/core/ffmpeg_b.dart';
import 'package:mediatag_bin/result_t.dart';

enum VideoThumbnailType { jpg, png }

extension DurationX on Duration {
  String toTimeString() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(inHours);
    String minutes = twoDigits(inMinutes.remainder(60));
    String seconds = twoDigits(inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}

class VideoTag {
  final FFmpegB _binary;
  const new(this._binary);

  ///generate video thumbnail
  ///
  /// output-> `'$thumbnailPath.${type.name}'`
  Result<bool, String> genThumbnailSync(
    String input,
    String thumbnailPath, {
    Duration duration = const Duration(seconds: 5),
    VideoThumbnailType type = .jpg,
  }) {
    final args = [
      '-y',
      '-ss',
      duration.toTimeString(),
      '-i',
      input,
      '-vframes',
      '1',
      '-vf',
      'format=yuv420p', // format ကို အတင်းဖိပြောင်းခိုင်းခြင်း
      '$thumbnailPath.${type.name}',
    ];
    //ffmpeg -ss 00:00:05 -i input.mp4 -vframes 1 thumbnail.jpg
    final res = _binary.runSync(args);
    return res.fold(
      onErr: (err) => Err(err),
      onOk: (val) {
        final msg = val.stderr.toString();
        if (msg.isNotEmpty) {
          return Err(msg);
        }
        return Ok(true);
      },
    );
  }

  ///generate video thumbnail
  ///
  /// output-> `'$thumbnailPath.${type.name}'`
  Future<Result<bool, String>> genThumbnail(
    String input,
    String thumbnailPath, {
    Duration duration = const Duration(seconds: 5),
    VideoThumbnailType type = .jpg,
  }) async {
    final args = [
      '-y',
      '-ss',
      duration.toTimeString(),
      '-i',
      input,
      '-vframes',
      '1',
      '-vf',
      'format=yuv420p', // format ကို အတင်းဖိပြောင်းခိုင်းခြင်း
      '$thumbnailPath.${type.name}',
    ];
    //ffmpeg -ss 00:00:05 -i input.mp4 -vframes 1 thumbnail.jpg
    final res = await _binary.run(args);
    return res.fold(
      onErr: (err) => Err(err),
      onOk: (val) {
        final msg = val.stderr.toString();
        if (msg.isNotEmpty) {
          return Err(msg);
        }
        return Ok(true);
      },
    );
  }
}

// ./ffmpeg -ss 00:00:05 -i "/home/thancoder/Videos/Jennifer Body.mp4" -vframes 1 -vf format=yuv420p "/home/thancoder/Videos/Jennifer Body.jpg"
