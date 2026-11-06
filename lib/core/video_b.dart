import 'package:mediatag_bin/core/ffmpeg_b.dart';
import 'package:mediatag_bin/result_t.dart';

// enum VideoThumbnailType { jpg, png }

extension DurationX on Duration {
  String toTimeString() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(inHours);
    String minutes = twoDigits(inMinutes.remainder(60));
    String seconds = twoDigits(inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}

class VideoB {
  final FFmpegB _ffmpeg;
  const new(this._ffmpeg);

  /******************genThumbnail********************* */

  ///
  // Future<Result<Uint8List, String>> genThumbnailBytes(
  //   String input, {
  //   Duration duration = const Duration(seconds: 5),
  // }) async {
  //   final args = [
  //     '-v',
  //     'error',
  //     '-ss',
  //     duration.toTimeString(),
  //     '-i',
  //     input,
  //     '-frames:v',
  //     '1',
  //     '-vf',
  //     'format=yuv420p',
  //     '-f',
  //     'image2pipe',
  //     '-vcodec',
  //     'mjpeg',
  //     'pipe:1',
  //   ];
  //   final p = await _ffmpeg.start(args);

  //   return await p.foldAsync(
  //     onErr: (err) async => Err(err),
  //     onOk: (val) async {
  //       try {
  //         final bytesFuture = val.stdout.fold<List<int>>(
  //           <int>[],
  //           (prev, ele) => prev..addAll(ele),
  //         );

  //         final errorFuture = val.stderr
  //             .transform(SystemEncoding().decoder)
  //             .join();

  //         final bytes = await bytesFuture;
  //         final error = await errorFuture;

  //         if (bytes.isEmpty) {
  //           return Err(
  //             error.isNotEmpty ? error : 'Failed to generate thumbnail',
  //           );
  //         }

  //         return Ok(Uint8List.fromList(bytes));
  //       } catch (e) {
  //         return Err(e.toString());
  //       }
  //     },
  //   );
  // }

  ///generate video thumbnail
  ///
  /// output-> `'$thumbnailPath.${type.name}'`
  Result<bool, String> genThumbnailSync(
    String input,
    String thumbnailPath, {
    Duration duration = const Duration(seconds: 5),
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
      thumbnailPath,
    ];
    //ffmpeg -ss 00:00:05 -i input.mp4 -vframes 1 thumbnail.jpg
    final res = _ffmpeg.runSync(args);
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
      thumbnailPath,
    ];
    //ffmpeg -ss 00:00:05 -i input.mp4 -vframes 1 thumbnail.jpg
    final res = await _ffmpeg.run(args);
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

  /******************genSmartThumbnail********************* */

  ///generate video thumbnail
  ///
  /// output-> `'$thumbnailPath.${type.name}'`
  /// ```bash
  /// ffmpeg -y \
  /// -i "Jennifer Body.mp4" \
  /// -vf "signalstats,metadata=mode=select:key=lavfi.signalstats.YAVG:value=20:function=greater,metadata=mode=select:key=lavfi.signalstats.YAVG:value=235:function=less,scale=320:-2" \
  /// -frames:v 1 \
  /// "Jennifer Body.jpg"
  /// ```
  Future<Result<bool, String>> genSmartThumbnail(
    String input,
    String thumbnailPath, {

    // Thumbnail size
    int width = 320,

    // Brightness thresholds (YAVG: 0–255)
    double minBrightness = 45,
    double maxBrightness = 230,

    // Color saturation threshold
    double minSaturation = 15,

    // Starting position in seconds
    Duration seekPosition = Duration.zero,

    // Output quality (lower = better quality for JPEG)
    int quality = 3,
  }) async {
    if (width <= 0) {
      return Err('Width must be greater than 0');
    }

    if (minBrightness < 0 ||
        maxBrightness > 255 ||
        minBrightness >= maxBrightness) {
      return Err('Invalid brightness range');
    }

    if (minSaturation < 0 || minSaturation > 255) {
      return Err('Invalid saturation threshold');
    }

    if (quality < 2 || quality > 31) {
      return Err('Quality must be between 2 and 31');
    }

    final filter = [
      'signalstats',
      'metadata=mode=select:key=lavfi.signalstats.YAVG:value=$minBrightness:function=greater',
      'metadata=mode=select:key=lavfi.signalstats.YAVG:value=$maxBrightness:function=less',
      'metadata=mode=select:key=lavfi.signalstats.SATAVG:value=$minSaturation:function=greater',
      'scale=$width:-2',
    ].join(',');

    final args = [
      '-y',
      if (seekPosition > Duration.zero) ...[
        '-ss',
        (seekPosition.inMilliseconds / 1000).toStringAsFixed(3),
      ],
      '-i',
      input,
      '-vf',
      filter,
      '-frames:v',
      '1',
      '-q:v',
      '$quality',
      '-update',
      '1',
      thumbnailPath,
    ];

    final res = await _ffmpeg.run(args);

    return res.fold(
      onErr: (err) => Err(err),
      onOk: (val) {
        final msg = val.stderr.toString();

        // FFmpeg may write warnings to stderr even on success.
        if (val.exitCode != 0) {
          return Err(msg.isNotEmpty ? msg : 'FFmpeg failed');
        }

        return Ok(true);
      },
    );
  }

  ///generate video thumbnail
  ///
  /// output-> `'$thumbnailPath.${type.name}'`
  /// ```bash
  /// ffmpeg -y \
  /// -i "Jennifer Body.mp4" \
  /// -vf "signalstats,metadata=mode=select:key=lavfi.signalstats.YAVG:value=20:function=greater,metadata=mode=select:key=lavfi.signalstats.YAVG:value=235:function=less,scale=320:-2" \
  /// -frames:v 1 \
  /// "Jennifer Body.jpg"
  /// ```
  Result<bool, String> genSmartThumbnailSync(
    String input,
    String thumbnailPath, {

    // Thumbnail size
    int width = 320,

    // Brightness thresholds (YAVG: 0–255)
    double minBrightness = 45,
    double maxBrightness = 230,

    // Color saturation threshold
    double minSaturation = 15,

    // Starting position in seconds
    Duration seekPosition = Duration.zero,

    // Output quality (lower = better quality for JPEG)
    int quality = 3,
  }) {
    if (width <= 0) {
      return Err('Width must be greater than 0');
    }

    if (minBrightness < 0 ||
        maxBrightness > 255 ||
        minBrightness >= maxBrightness) {
      return Err('Invalid brightness range');
    }

    if (minSaturation < 0 || minSaturation > 255) {
      return Err('Invalid saturation threshold');
    }

    if (quality < 2 || quality > 31) {
      return Err('Quality must be between 2 and 31');
    }

    final filter = [
      'signalstats',
      'metadata=mode=select:key=lavfi.signalstats.YAVG:value=$minBrightness:function=greater',
      'metadata=mode=select:key=lavfi.signalstats.YAVG:value=$maxBrightness:function=less',
      'metadata=mode=select:key=lavfi.signalstats.SATAVG:value=$minSaturation:function=greater',
      'scale=$width:-2',
    ].join(',');

    final args = [
      '-y',
      if (seekPosition > Duration.zero) ...[
        '-ss',
        (seekPosition.inMilliseconds / 1000).toStringAsFixed(3),
      ],
      '-i',
      input,
      '-vf',
      filter,
      '-frames:v',
      '1',
      '-q:v',
      '$quality',
      '-update',
      '1',
      thumbnailPath,
    ];

    final res = _ffmpeg.runSync(args);

    return res.fold(
      onErr: (err) => Err(err),
      onOk: (val) {
        final msg = val.stderr.toString();

        // FFmpeg may write warnings to stderr even on success.
        if (val.exitCode != 0) {
          return Err(msg.isNotEmpty ? msg : 'FFmpeg failed');
        }

        return Ok(true);
      },
    );
  }
}
