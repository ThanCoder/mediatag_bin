import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:mediatag_bin/mediatag_bin.dart';
import 'package:than_pkg_android/than_pkg_android.dart';

class VThumbnailPage extends StatefulWidget {
  const new({super.key, required this.dir});
  final Directory dir;

  @override
  State<VThumbnailPage> createState() => _VThumbnailPageState();
}

class _VThumbnailPageState extends State<VThumbnailPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  late String _androidCache;

  List<File> entList = [];
  Directory get cacheFolder {
    if (Platform.isAndroid) {
      return Directory(_androidCache);
    }
    return Directory('/home/thancoder/Videos/thumbanil-cache');
  }

  final pkg = MediatagBin.instance.ffmpeg;
  final tpkg = ThanPkgAndroid.getInstance.storagePermissionHandler;

  Future<void> init() async {
    if (Platform.isAndroid) {
      if (!await tpkg.isStoragePermissionGranted()) {
        await tpkg.requestStoragePermission();
        return;
      }
    }
    _androidCache = (await ThanPkgAndroid.getInstance.pathHandler
        .getCachePath())!;
    if (!cacheFolder.existsSync()) {
      cacheFolder.createSync(recursive: true);
    }
    if (!widget.dir.existsSync()) return;
    entList.clear();
    for (var ent in widget.dir.listSync()) {
      if (!ent.isFile) continue;
      final name = ent.name;
      if (!name.endsWith('.mp4')) continue;
      entList.add(ent.file);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thumbnail')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator.adaptive(
          onRefresh: init,
          child: ListView.builder(
            itemCount: entList.length,
            itemBuilder: (context, index) => listItem(entList[index]),
          ),
        ),
      ),
    );
  }

  Widget listItem(File file) {
    final name = file.name;
    return Row(
      spacing: 10,
      children: [
        SizedBox(width: 100, height: 100, child: _coverFileWidget(file)),
        Expanded(
          child: Column(
            spacing: 5,
            crossAxisAlignment: .start,
            children: [Text(name), Text(file.toFileSizeLabel())],
          ),
        ),
      ],
    );
  }

  // Widget _coverMemWidget(File file) {
  //   return FutureBuilder(
  //     future: pkg.video.genThumbnailBytes(file.path),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == .waiting) {
  //         return Center(child: CircularProgressIndicator.adaptive());
  //       }
  //       final res = snapshot.data;
  //       if (res != null && res.isErr) {
  //         print('${res.unwrapError()}');
  //         return Text('Error:');
  //       }
  //       return Image.memory(
  //         res!.unwrap(),
  //         errorBuilder: (context, error, stackTrace) => Placeholder(),
  //       );
  //     },
  //   );
  // }

  Widget _coverFileWidget(File file) {
    final f = File(cacheFolder.join('${file.onlyName}.jpg'));
    if (f.existsSync()) {
      return Image.file(
        f,
        errorBuilder: (context, error, stackTrace) => Placeholder(),
      );
    }
    return FutureBuilder(
      future: pkg.video.genThumbnail(file.path, f.absolutePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        return Image.file(
          f,
          errorBuilder: (context, error, stackTrace) => Placeholder(),
        );
      },
    );
  }
}
