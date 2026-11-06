import 'package:mediatag_bin/core/audio_b.dart';
import 'package:mediatag_bin/core/i_binary.dart';
import 'package:mediatag_bin/core/video_b.dart';

class FFmpegB extends IBinary {
  new(super.libPath);

  ///video commands
  late final VideoB video = VideoB(this);

  /// audio commands
  late final AudioB audio = AudioB(this);
}
