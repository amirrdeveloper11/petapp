import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:front/core/network/api_config.dart';


class AppNetworkImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  static const String _emulatorHost = '10.0.2.2';

  static String get _baseUrl => ApiConfig.baseUrl.replaceAll(RegExp(r'/$'), '');

  String? _normalize(String? value) {
    if (value == null) return null;

    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;

    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed
          .replaceFirst('127.0.0.1', _emulatorHost)
          .replaceFirst('localhost', _emulatorHost);
    }

    if (trimmed.startsWith('/storage/')) {
      return '$_baseUrl$trimmed';
    }

    if (trimmed.startsWith('storage/')) {
      return '$_baseUrl/$trimmed';
    }

    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _normalize(url);

    final Widget fallback =
        errorWidget ?? const Center(child: Icon(Icons.broken_image_outlined));

    final Widget loading =
        placeholder ??
        const Center(child: CircularProgressIndicator(strokeWidth: 2));

    Widget child;

    if (imageUrl == null) {
      child = fallback;
    } else {
      child = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => loading,
        errorWidget: (_, __, ___) => fallback,
        fadeInDuration: const Duration(milliseconds: 150),
        fadeOutDuration: const Duration(milliseconds: 150),
        useOldImageOnUrlChange: true,
        memCacheWidth: width?.toInt(),
        memCacheHeight: height?.toInt(),
      );
    }

    if (borderRadius == null) return child;

    return ClipRRect(borderRadius: borderRadius!, child: child);
  }
}
