import 'dart:convert';

import 'package:mediatag_bin/core/types/file_format.dart';
import 'package:mediatag_bin/core/types/file_stream.dart';

/// file info
class FileInfoRes {
  final String _source;
  const new(this._source);

  /// file info streams
  List<FileStream> get streams {
    List<dynamic> list = toMap['streams'] ?? [];

    return list.map((e) {
      final type = StreamCodecType.fromVal(e['codec_type'] ?? '');
      return FileStream(e, type);
    }).toList();
  }

  ///format source
  String get text => _source;

  ///source map
  Map<String, dynamic> get toMap => jsonDecode(_source);

  /// file format
  FileFormat? get formatOrNull {
    final map = toMap['format'];
    if (map == null) return null;
    return .new(map);
  }

  /// file format
  FileFormat get format {
    return formatOrNull!;
  }
}
