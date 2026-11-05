/* {
filename: /home/thancoder/Videos/Jennifer Body.mp4, 
nb_streams: 2, 
nb_programs: 0, 
nb_stream_groups: 0, 
format_name: mov,mp4,m4a,3gp,3g2,mj2, 
start_time: 0.000000, 
duration: 6449.621333, 
size: 1127995081, 
bit_rate: 1399145, 
probe_score: 100, 

tags: {major_brand: isom, minor_version: 512, compatible_brands: isomiso2avc1mp41, encoder: Lavf58.29.100}}

*/
import 'package:mediatag_bin/core/types/file_tag.dart';
import 'package:mediatag_bin/core/utils.dart';

class FileFormat {
  final Map<String, dynamic> _map;
  const new(this._map);

  /// source map
  Map<String, dynamic> get sourceMap => _map;

  /// file tag
  FileTag? get tagOrNull {
    final map = _map['tags'];
    if (map == null) return null;
    return .new(map);
  }

  /// file tag
  FileTag get tag {
    return tagOrNull!;
  }

  String get filename => _map['filename'];
  int get nbStreams => .parse(_map['nb_streams']);
  int get nbPrograms => .parse(_map['nb_programs']);
  int get nbStreamGroups => .parse(_map['nb_stream_groups']);
  String get formatName => _map['format_name'];
  double get startTime => .parse(_map['start_time']);

  /// seconds
  double get durationSecs => .parse(_map['duration']);
  int get size => int.parse(_map['size']);
  int get bitRate => .parse(_map['bit_rate']);
  int get probeScore => .parse(_map['probe_score']);

  /// duration
  Duration get duration {
    return Duration(seconds: durationSecs.toInt());
  }

  /// size lable
  String get szieLable => formatFileSizeLable(size);
}
