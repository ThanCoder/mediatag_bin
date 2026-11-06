import 'dart:convert';
import 'dart:io';

import 'package:mediatag_bin/result_t.dart';

abstract class IBinary {
  final String libPath;
  const new(this.libPath);

  /// run commands
  Future<Result<ProcessResult, String>> run(
    List<String> args, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    Encoding? stdoutEncoding = systemEncoding,
    Encoding? stderrEncoding = systemEncoding,
  }) async {
    try {
      final p = await Process.run(
        libPath,
        args,
        workingDirectory: workingDirectory,
        environment: environment,
        includeParentEnvironment: includeParentEnvironment,
        runInShell: runInShell,
        stdoutEncoding: stdoutEncoding,
        stderrEncoding: stderrEncoding,
      );
      // print('exitCode: ${p.exitCode}');
      final err = p.stderr.toString();
      if (err.isNotEmpty) {
        return Err(err);
      }
      return Ok(p);
    } catch (e) {
      return Err(e.toString());
    }
  }

  /// run commands
  Result<ProcessResult, String> runSync(
    List<String> args, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    Encoding? stdoutEncoding = systemEncoding,
    Encoding? stderrEncoding = systemEncoding,
  }) {
    try {
      final p = Process.runSync(
        libPath,
        args,
        workingDirectory: workingDirectory,
        environment: environment,
        includeParentEnvironment: includeParentEnvironment,
        runInShell: runInShell,
        stdoutEncoding: stdoutEncoding,
        stderrEncoding: stderrEncoding,
      );
      final err = p.stderr.toString();
      if (err.isNotEmpty) {
        return Err(err);
      }
      return Ok(p);
    } catch (e) {
      return Err(e.toString());
    }
  }

  /// start commands
  Future<Result<Process, String>> start(
    List<String> args, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    ProcessStartMode mode = ProcessStartMode.normal,
  }) async {
    try {
      final p = await Process.start(
        libPath,
        args,
        workingDirectory: workingDirectory,
        environment: environment,
        includeParentEnvironment: includeParentEnvironment,
        runInShell: runInShell,
        mode: mode,
      );
      return Ok(p);
    } catch (e) {
      return Err(e.toString());
    }
  }

  /// get version or null
  Future<String?> getVersionOrNull() async {
    final res = await getVersion();
    return switch (res) {
      Ok(value: final val) => val,
      Err() => null,
    };
  }

  /// get version or null
  String? getVersionOrNullSync() {
    final res = getVersionSync();
    return switch (res) {
      Ok(value: final val) => val,
      Err() => null,
    };
  }

  /// get version
  Future<Result<String, String>> getVersion() async {
    try {
      final p = await Process.run(libPath, ['-version']);
      final err = p.stderr.toString();
      if (err.isNotEmpty) {
        return Err(err);
      }
      return Ok(p.stdout);
    } catch (e) {
      return Err(e.toString());
    }
  }

  /// get version
  Result<String, String> getVersionSync() {
    try {
      final p = Process.runSync(libPath, ['-version']);
      final err = p.stderr.toString();
      if (err.isNotEmpty) {
        return Err(err);
      }
      return Ok(p.stdout);
    } catch (e) {
      return Err(e.toString());
    }
  }
}
