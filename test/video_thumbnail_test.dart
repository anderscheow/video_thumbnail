import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel =
      MethodChannel('plugins.justsoft.xyz/video_thumbnail');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      final m = methodCall.method;
      final a = methodCall.arguments as Map;
      if (m == 'data') {
        return Uint8List.fromList([1, 2, 3]);
      }
      return '$m=${a["video"]}:${a["path"]}:${a["format"]}:${a["maxh"]}:${a["maxw"]}:${a["quality"]}';
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('thumbnailFile', () async {
    expect(
        await VideoThumbnail.thumbnailFile(
            video: 'video',
            thumbnailPath: 'path',
            imageFormat: ImageFormat.JPEG,
            maxWidth: 123,
            maxHeight: 456,
            quality: 45),
        'file=video:path:0:456:123:45');
  });

  test('thumbnailData', () async {
    final result = await VideoThumbnail.thumbnailData(
        video: 'video',
        imageFormat: ImageFormat.PNG,
        maxWidth: 100,
        maxHeight: 200,
        quality: 80);
    expect(result, isNotNull);
    expect(result, equals(Uint8List.fromList([1, 2, 3])));
  });
}
