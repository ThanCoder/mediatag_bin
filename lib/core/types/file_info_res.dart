import 'dart:convert';

import 'package:mediatag_bin/core/types/file_format.dart';
import 'package:mediatag_bin/core/types/file_stream.dart';
import 'package:mediatag_bin/mediatag_bin.dart';

/// file info
class FileInfoRes {
  final String _source;
  const new(this._source);

  /// file info streams
  List<FileStream> get streams {
    List<dynamic> list = toMap['streams'] ?? [];
    if (list.isEmpty) return [];

    return list.map((e) {
      final type = StreamCodecType.fromVal(e['codec_type'] ?? '');
      return FileStream(e, type);
    }).toList();
  }

  ///format source
  String get text => _source;

  ///source map
  Map<String, dynamic> get toMap {
    try {
      return jsonDecode(_source);
    } catch (e) {
      MediatagBin.instance.showDebugLog('[FileInfoRes:toMap]: $e');
    }
    return {};
  }

  /// file format
  FileFormat? get formatOrNull {
    final map = toMap['format'];
    if (map == null) return null;
    return .new(map);
  }

  // /// file format
  // FileFormat get format {
  //   return formatOrNull!;
  // }
}
