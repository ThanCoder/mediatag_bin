// ignore_for_file: avoid_print

import 'dart:io';

import 'package:android_native_path/android_native_path.dart';
import 'package:mediatag_bin/mediatag_bin.dart';

Future<String> getPlatformLibFullPath(String libName) async {
  if (Platform.isLinux || Platform.isWindows) {
    return getDesktopLibFullPath(libName);
  }
  if (Platform.isAndroid) {
    final path = await AndroidNativePath.instance.getNativeLib(libName);
    return path!;
  }
  throw UnsupportedError('Unsupported ${Platform.operatingSystem}!');
}

String getDesktopLibFullPath(String libName) {
  // 1. App binary ရှိနေသည့် file path ကို ယူခြင်း
  final executablePath = Platform.resolvedExecutable;

  // 2. ၎င်း၏ Parent directory (folder) ကို ဖြတ်ယူခြင်း
  final executableDir = File(executablePath).parent.path;

  // 3. lib folder ထဲရှိ libName ရဲ့ absolute path ကို တည်ဆောက်ခြင်း
  // (ဥပမာ - app တည်ရှိရာ folder အောက်မှ lib/libname.so)

  if (Platform.isWindows) {
    return File(executableDir.join(libName)).absolute.path;
  }
  final libPath = executableDir.join('lib').join(libName);

  return File(libPath).absolute.path;
}

Future<void> makeExecutableAndRun(
  String filePath, {
  bool showDebugLog = true,
}) async {
  try {
    // ၁။ chmod +x ပေးခြင်း
    final chmodResult = await Process.run('chmod', ['+x', filePath]);

    if (chmodResult.exitCode != 0) {
      MediatagBin.instance.showDebugLog(
        'Failed to grant execution permission: ${chmodResult.stderr}',
      );
      return;
    }
    MediatagBin.instance.showDebugLog(
      'Successfully granted execution permission!: ${filePath.nameOnly}',
    );
  } catch (e) {
    MediatagBin.instance.showDebugLog('[makeExecutableAndRun]: $e');
  }
}

String formatFileSizeLable(int size) {
  if (size <= 0) return '0 bytes';
  int i = 0;
  final pow = 1024;
  final list = ['bytes', 'KB', 'MB', 'GB', 'TB'];
  double sizeD = size.toDouble();
  while (sizeD > pow && i < (list.length - 1)) {
    sizeD /= pow;
    i++;
  }
  return '${sizeD.toStringAsFixed(2)} ${list[i]}';
}

extension StringX on String {
  String join(String name) {
    return '$this${Platform.pathSeparator}$name';
  }

  String get nameOnly {
    return split(Platform.pathSeparator).last;
  }
}

extension MapX on Map<String, dynamic> {
  String getStringOr(String key, String def) {
    final val = _getOrNull<String>(key);
    return val ?? def;
  }

  int getIntOr(String key, int def) {
    return _getOr<int>(key, def);
  }

  double getDoubleOr(String key, double def) {
    return _getOr<double>(key, def);
  }

  T _getOr<T>(String key, T def) {
    final val = _getOrNull<T>(key);
    return val ?? def;
  }

  T? _getOrNull<T>(String key) {
    final val = this[key];

    if (val is T) {
      return val;
    }

    if (val == null) return null;

    return switch (T) {
      String => val.toString() as T?,
      int =>
        (val is String ? int.tryParse(val) : int.tryParse(val.toString()))
            as T?,
      double =>
        (val is String ? double.tryParse(val) : double.tryParse(val.toString()))
            as T?,
      bool => (val is String ? bool.tryParse(val) : null) as T?,
      _ => null,
    };
  }
}
