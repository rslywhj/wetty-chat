import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class MessageAvatar extends StatelessWidget {
  const MessageAvatar({
    super.key,
    required this.avatarUrl,
    required this.fallbackBuilder,
  });

  static const double avatarSize = 36;

  final String avatarUrl;
  final Widget Function() fallbackBuilder;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: avatarUrl,
        width: avatarSize,
        height: avatarSize,
        memCacheWidth: 96,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => fallbackBuilder(),
      ),
    );
  }
}
