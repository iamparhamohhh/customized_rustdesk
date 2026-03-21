import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A configurable banner widget that loads an image from assets.
///
/// To change the banner, simply replace `flutter/assets/banner.png`
/// with your desired image (recommended size: 600x120 or similar aspect ratio).
/// The banner will automatically scale to fit the available width.
class AppBanner extends StatelessWidget {
  final double maxHeight;
  final EdgeInsetsGeometry margin;

  const AppBanner({
    Key? key,
    this.maxHeight = 120,
    this.margin = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ByteData>(
      future: rootBundle.load('assets/banner.png'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        return Container(
          margin: margin,
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/banner.png',
              fit: BoxFit.contain,
              width: double.infinity,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}
