# mediatag_b

## Example List

- [x][Example](#example)
- [x][for-android](#for-android)

### Supported

- Linux
- Android
- Window

### Example

[Example List](#example-list)

```dart
WidgetsFlutterBinding.ensureInitialized();

await MediatagBin.instance.initailize();

if (MediatagBin.instance.isSupported) {
//check platforms
}

final pkg = MediatagBin.instance;
await pkg.ffmpeg.getVersionOrNull();
await pkg.ffprobe.getVersionOrNull();

// ffprobe
final res = await pkg.ffprobe.getFileInfo(path);
switch (res) {
    case Ok(value: final val):
    infoText = val.text;
    print(val.format.filename);

    print(val.format.duration);
    print(val.format.szieLable);
    print('tag');
    print(val.format.tag.titleOrNull);
    print(val.format.tag.artistOrNull);
    print(val.format.tag.genreOrNull);
    print(val.format.tag.dateOrNull);

    for (var stm in val.streams) {
        print(stm.codecType);
        print(stm.codecName);
        print(stm.bitRate);
        print(stm.channels);
        print(stm.durationTs);
        print(stm.duration);
    }
    break;
    case Err(value: final err):
    infoText = err;
    break;
}

// video
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

// audio
await pkg.ffmpeg.audio.getCoverArtBytes(path);
await pkg.ffmpeg.audio.writeCoverArt(
    path,
    outpath,
    coverArtPath: coverArtPath,
);
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

### For Android

[Example List](#example-list)

```kts

### android/app/build.gradle.kts

android {
    // ရှိပြီးသား configuration တွေကို မဖျက်ပါနဲ့။

    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }
}
```
