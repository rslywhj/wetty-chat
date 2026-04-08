import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';

enum ComposerAttachmentKind { image, gif, video, file }

enum ComposerAttachmentSource { photos, gifs, videos, files }

class PickedComposerAttachment {
  const PickedComposerAttachment({
    required this.localId,
    required this.file,
    required this.name,
    required this.mimeType,
    required this.kind,
    required this.sizeBytes,
    this.previewBytes,
    this.width,
    this.height,
  });

  final String localId;
  final PlatformFile file;
  final String name;
  final String mimeType;
  final ComposerAttachmentKind kind;
  final int sizeBytes;
  final Uint8List? previewBytes;
  final int? width;
  final int? height;
}

class AttachmentPickerService {
  static const List<String> _gifExtensions = <String>['gif'];

  Future<List<PickedComposerAttachment>> pick(
    ComposerAttachmentSource source,
  ) async {
    final result = await FilePicker.pickFiles(
      allowMultiple: true,
      withData: _needsPreviewBytes(source),
      withReadStream: true,
      type: switch (source) {
        ComposerAttachmentSource.photos => FileType.image,
        ComposerAttachmentSource.gifs => FileType.custom,
        ComposerAttachmentSource.videos => FileType.video,
        ComposerAttachmentSource.files => FileType.any,
      },
      allowedExtensions: switch (source) {
        ComposerAttachmentSource.gifs => _gifExtensions,
        _ => null,
      },
    );
    if (result == null) {
      return const <PickedComposerAttachment>[];
    }

    final attachments = <PickedComposerAttachment>[];
    for (final file in result.files) {
      final attachment = await _toPickedAttachment(file, source);
      if (attachment != null) {
        attachments.add(attachment);
      }
    }
    return attachments;
  }

  bool _needsPreviewBytes(ComposerAttachmentSource source) {
    return switch (source) {
      ComposerAttachmentSource.photos => true,
      ComposerAttachmentSource.gifs => true,
      ComposerAttachmentSource.videos => false,
      ComposerAttachmentSource.files => false,
    };
  }

  Future<PickedComposerAttachment?> _toPickedAttachment(
    PlatformFile file,
    ComposerAttachmentSource source,
  ) async {
    final mimeType = _detectMimeType(file, source);
    final kind = _detectKind(file, mimeType, source);
    final previewBytes = _previewBytesFor(file, kind);
    final dimensions = await _dimensionsFor(kind, previewBytes);

    return PickedComposerAttachment(
      localId: _createLocalId(),
      file: file,
      name: file.name,
      mimeType: mimeType,
      kind: kind,
      sizeBytes: file.size,
      previewBytes: previewBytes,
      width: dimensions.$1,
      height: dimensions.$2,
    );
  }

  String _detectMimeType(PlatformFile file, ComposerAttachmentSource source) {
    final detected = lookupMimeType(file.name, headerBytes: file.bytes);
    if (detected != null && detected.isNotEmpty) {
      return detected;
    }
    return switch (source) {
      ComposerAttachmentSource.photos => 'image/*',
      ComposerAttachmentSource.gifs => 'image/gif',
      ComposerAttachmentSource.videos => 'video/*',
      ComposerAttachmentSource.files => 'application/octet-stream',
    };
  }

  ComposerAttachmentKind _detectKind(
    PlatformFile file,
    String mimeType,
    ComposerAttachmentSource source,
  ) {
    if (mimeType == 'image/gif' || file.extension?.toLowerCase() == 'gif') {
      return ComposerAttachmentKind.gif;
    }
    if (mimeType.startsWith('image/')) {
      return ComposerAttachmentKind.image;
    }
    if (mimeType.startsWith('video/')) {
      return ComposerAttachmentKind.video;
    }
    return switch (source) {
      ComposerAttachmentSource.photos => ComposerAttachmentKind.image,
      ComposerAttachmentSource.gifs => ComposerAttachmentKind.gif,
      ComposerAttachmentSource.videos => ComposerAttachmentKind.video,
      ComposerAttachmentSource.files => ComposerAttachmentKind.file,
    };
  }

  Uint8List? _previewBytesFor(PlatformFile file, ComposerAttachmentKind kind) {
    return switch (kind) {
      ComposerAttachmentKind.image || ComposerAttachmentKind.gif => file.bytes,
      ComposerAttachmentKind.video || ComposerAttachmentKind.file => null,
    };
  }

  Future<(int?, int?)> _dimensionsFor(
    ComposerAttachmentKind kind,
    Uint8List? previewBytes,
  ) async {
    if (previewBytes == null) {
      return (null, null);
    }
    if (kind != ComposerAttachmentKind.image &&
        kind != ComposerAttachmentKind.gif) {
      return (null, null);
    }
    try {
      final completer = Completer<ui.Image>();
      ui.decodeImageFromList(previewBytes, completer.complete);
      final image = await completer.future.timeout(const Duration(seconds: 2));
      final size = (image.width, image.height);
      image.dispose();
      return size;
    } catch (_) {
      return (null, null);
    }
  }

  String _createLocalId() {
    final micros = DateTime.now().microsecondsSinceEpoch;
    final randomTail = micros.remainder(1000000).toString().padLeft(6, '0');
    return 'draft_$micros$randomTail';
  }
}
