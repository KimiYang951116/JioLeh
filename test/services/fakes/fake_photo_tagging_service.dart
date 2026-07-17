import 'dart:typed_data';

import 'package:jio_leh/services/photo_tagging_service.dart';

/// A pretend PhotoTaggingService for tests. No network — set [tagsToReturn]
/// from your test to control what tagPhoto() returns.
class FakePhotoTaggingService extends PhotoTaggingService {
  FakePhotoTaggingService({
    this.tagsToReturn = const [],
    this.throwOnTag = false,
  });

  List<String> tagsToReturn;
  bool throwOnTag;

  int tagPhotoCalls = 0;
  Uint8List? lastImageBytes;

  @override
  Future<List<String>> tagPhoto(Uint8List imageBytes) async {
    tagPhotoCalls++;
    lastImageBytes = imageBytes;

    if (throwOnTag) {
      throw const PhotoTaggingException('FakePhotoTaggingService tag failed');
    }

    return tagsToReturn;
  }
}