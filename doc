# mediatag_b

A Flutter/Dart package that provides FFmpeg and FFprobe binaries for media processing, metadata extraction, and thumbnail generation.

## Supported Platforms

- Linux
- Android
- Windows

## Example List

- [Initialization](#example)
- [Android Configuration](#for-android)
- [FFmpeg Example](#ffmpeg-example)
- [FFprobe Example](#ffprobe-example)

---

## FFprobe Example

FFprobe provides tools for retrieving media information, including file metadata, format details, and audio/video stream information.

```dart
final ffprobe = MediatagBin.instance.ffprobe;

// Version
ffprobe.getVersion();
ffprobe.getVersionOrNull();
ffprobe.getVersionOrNullSync();
ffprobe.getVersionSync();

// Execute commands
ffprobe.run([args]);
ffprobe.runSync([args]);
ffprobe.start([args]);

// Extract media information
ffprobe.getFileInfo(path);
ffprobe.getFileInfoOrNull(path);
ffprobe.getFileInfoOrNullSync(path);
ffprobe.getFileInfoSync(path);
```

[Back to Example List](#example-list)

---

## FFmpeg Example

FFmpeg provides tools for audio and video processing.

```dart
final ffmpeg = MediatagBin.instance.ffmpeg;

// Version
ffmpeg.getVersion();
ffmpeg.getVersionOrNull();
ffmpeg.getVersionOrNullSync();
ffmpeg.getVersionSync();

// Execute commands
ffmpeg.run([args]);
ffmpeg.runSync([args]);
ffmpeg.start([args]);

// Audio processing
ffmpeg.audio.getCoverArtBytes(path);
ffmpeg.audio.getCoverArtBytesOrNull(path);

ffmpeg.audio.writeCoverArt(
  path,
  outpath,
  coverArtPath: coverArtPath,
);

ffmpeg.audio.writeTags(
  path,
  outpath,
  title: title,
  artist: artist,
  album: album,
  genre: genre,
  date: date,
);

// Video processing
ffmpeg.video.genThumbnail(input, thumbnailPath);
ffmpeg.video.genThumbnailSync(input, thumbnailPath);
```

[Back to Example List](#example-list)

---

## Example

### Initialization

Initialize the package before accessing FFmpeg or FFprobe.

```dart
import 'package:flutter/material.dart';
import 'package:mediatag_b/mediatag_b.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MediatagBin.instance.initailize();

  final pkg = MediatagBin.instance;

  if (pkg.isSupported) {
    // The current platform is supported.
  }

  await pkg.ffmpeg.getVersionOrNull();
  await pkg.ffprobe.getVersionOrNull();
}
```

### FFprobe - Extract Media Information

Use FFprobe to retrieve media metadata and stream information.

```dart
final res = await pkg.ffprobe.getFileInfo(path);

switch (res) {
  case Ok(value: final val):
    infoText = val.text;

    // Format information
    print(val.format.filename);
    print(val.format.duration);
    print(val.format.szieLable);

    // Metadata tags
    print(val.format.tag.titleOrNull);
    print(val.format.tag.artistOrNull);
    print(val.format.tag.genreOrNull);
    print(val.format.tag.dateOrNull);

    // Audio and video streams
    for (final stm in val.streams) {
      print(stm.codecType);
      print(stm.codecName);
      print(stm.bitRate);
      print(stm.channels);
      print(stm.durationTs);
      print(stm.duration);
    }

  case Err(value: final err):
    infoText = err;
}
```

### FFmpeg - Generate Video Thumbnail

Generate a thumbnail from a video file.

```dart
final res = await pkg.ffmpeg.video.genThumbnail(
  '/home/thancoder/Videos/Jennifer Body.mp4',
  '/home/thancoder/Videos/Jennifer Body',
);

switch (res) {
  case Ok(value: final val):
    print(val);

  case Err(value: final err):
    print(err);
}
```

### FFmpeg - Audio Processing

Extract cover art as bytes:

```dart
await pkg.ffmpeg.audio.getCoverArtBytes(path);
```

Replace existing cover art:

```dart
await pkg.ffmpeg.audio.writeCoverArt(
  path,
  outpath,
  coverArtPath: coverArtPath,
);
```

Update audio metadata tags:

```dart
await pkg.ffmpeg.audio.writeTags(
  path,
  outpath,
  title: title,
  artist: artist,
  album: album,
  genre: genre,
  date: date,
);
```

[Back to Example List](#example-list)

---

## For Android

For Android builds, enable legacy JNI library packaging in your app's Gradle configuration.

Open:

`android/app/build.gradle.kts`

Add the following configuration inside the existing `android` block:

```kotlin
android {
    // Keep your existing Android configuration.

    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }
}
```

**Important:** Do not remove your existing Android configuration. Only add the `packaging` section if it is not already configured.

[Back to Example List](#example-list)

---

## Notes

- Call `initailize()` before using FFmpeg or FFprobe.
- Check `isSupported` before executing commands.
- Use asynchronous methods when running potentially long operations.
- Use synchronous methods only when blocking execution is acceptable.

