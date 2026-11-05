import 'package:mediatag_bin/core/audio_b.dart';
import 'package:mediatag_bin/core/i_binary.dart';
import 'package:mediatag_bin/core/video_tag.dart';

class FFmpegB extends IBinary {
  new(super.libPath);

  ///video commands
  late final VideoTag video = VideoTag(this);

  /// audio command
  late final AudioB audio = AudioB(this);
}
