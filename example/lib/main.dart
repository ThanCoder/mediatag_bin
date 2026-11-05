// ignore_for_file: avoid_print

import 'dart:io';

import 'package:android_native_path/android_native_path.dart';
import 'package:flutter/material.dart';
import 'package:mediatag_bin/mediatag_bin.dart';
import 'package:mediatag_bin/result_t.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MediatagBin.instance.initailize();

  if (MediatagBin.instance.isSupported) {
    //check platforms
  }

  if (Platform.isAndroid) {
    print('[:Dev]: ${await AndroidNativePath.instance.nativeLibraries}');
  }

  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const new({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final pkg = MediatagBin.instance;

  String infoText = '';

  void fetchFFmpeg() async {
    final res = await pkg.ffmpeg.getVersionOrNull();
    if (res != null) {
      infoText = res;
      setState(() {});
    }
  }

  void fetchProb() async {
    final res = await pkg.ffprobe.getVersionOrNull();
    if (res != null) {
      infoText = res;
      setState(() {});
    }
  }

  void showInfo(String path) async {
    final res = await pkg.ffprobe.getFileInfo(path);
    switch (res) {
      case Ok(value: final val):
        infoText = val.text;
        break;
      case Err(value: final err):
        infoText = err;
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Column(
        mainAxisSize: .min,
        spacing: 10,
        children: [
          FloatingActionButton(
            heroTag: 'ffmeg',
            onPressed: fetchFFmpeg,
            child: Text('FFmpeg Version'),
          ),
          FloatingActionButton(
            heroTag: 'FFprob',
            onPressed: fetchProb,
            child: Text('FFprob Version'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _btns),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(infoText),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _btns {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        FilledButton(
          onPressed: () => showInfo('/home/thancoder/Videos/Jennifer Body.mp4'),
          child: Text('Video Info'),
        ),
        FilledButton(
          onPressed: () => showInfo(
            '/home/thancoder/Music/The Crew - Get Low [GMV] [oQ6KD_FTix0].m4a',
          ),
          child: Text('Audio Info'),
        ),
        FilledButton(
          onPressed: () async {
            final res = await pkg.ffmpeg.video.genThumbnail(
              '/home/thancoder/Videos/Jennifer Body.mp4',
              '/home/thancoder/Videos/Jennifer Body',
            );
            switch (res) {
              case Ok(value: final val):
                print(val);
                break;
              case Err(value: final err):
                print(err);
                break;
            }
          },
          child: Text('Gen Video Thumbnail'),
        ),
      ],
    );
  }
}
