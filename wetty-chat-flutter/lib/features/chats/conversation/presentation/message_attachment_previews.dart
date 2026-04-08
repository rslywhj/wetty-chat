import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../../models/message_models.dart';

class MessageImageAttachmentPreview extends StatelessWidget {
  const MessageImageAttachmentPreview({
    super.key,
    required this.attachment,
    required this.onTap,
    required this.fallback,
  });

  final AttachmentItem attachment;
  final VoidCallback onTap;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 160,
          height: 160,
          child: CachedNetworkImage(
            imageUrl: attachment.url,
            width: 160,
            height: 160,
            memCacheWidth: 320,
            fit: BoxFit.cover,
            placeholder: (context, url) => DecoratedBox(
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey5.resolveFrom(context),
              ),
              child: const Center(child: CupertinoActivityIndicator()),
            ),
            errorWidget: (context, url, error) => fallback,
          ),
        ),
      ),
    );
  }
}
