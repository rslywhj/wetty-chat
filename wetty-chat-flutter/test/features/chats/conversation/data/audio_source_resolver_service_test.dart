import 'package:flutter_test/flutter_test.dart';

import 'package:chahua/features/chats/conversation/data/audio_source_resolver_service.dart';
import 'package:chahua/features/chats/models/message_models.dart';

void main() {
  group('audioAttachmentNeedsAppleTranscode', () {
    test('does not transcode mp4 opus attachments on Apple platforms', () {
      final attachment = AttachmentItem(
        id: 'audio-1',
        url: 'https://example.com/audio-1.mp4',
        kind: 'audio/mp4;codecs=opus',
        size: 2048,
        fileName: 'audio-1.mp4',
      );

      final requiresTranscode = audioAttachmentNeedsAppleTranscode(
        attachment,
        isApplePlatform: true,
      );

      expect(requiresTranscode, isFalse);
    });

    test('transcodes ogg attachments on Apple platforms', () {
      final attachment = AttachmentItem(
        id: 'audio-2',
        url: 'https://example.com/audio-2.ogg',
        kind: 'audio/ogg',
        size: 2048,
        fileName: 'audio-2.ogg',
      );

      final requiresTranscode = audioAttachmentNeedsAppleTranscode(
        attachment,
        isApplePlatform: true,
      );

      expect(requiresTranscode, isTrue);
    });

    test('transcodes webm attachments on Apple platforms', () {
      final attachment = AttachmentItem(
        id: 'audio-3',
        url: 'https://example.com/audio-3.webm',
        kind: 'audio/webm;codecs=opus',
        size: 2048,
        fileName: 'audio-3.webm',
      );

      final requiresTranscode = audioAttachmentNeedsAppleTranscode(
        attachment,
        isApplePlatform: true,
      );

      expect(requiresTranscode, isTrue);
    });
  });
}
