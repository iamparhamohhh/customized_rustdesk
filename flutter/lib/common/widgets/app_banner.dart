import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/consts.dart';
import 'package:flutter_hbb/models/platform_model.dart';

/// A configurable banner widget that loads an image from a remote URL
/// when available, otherwise falls back to `assets/banner.png`.
class AppBanner extends StatelessWidget {
  static const String _defaultBannerUrl =
      'https://rahbarhesab.com/rahbardesk.jpeg';

  final EdgeInsetsGeometry margin;

  const AppBanner({
    Key? key,
    this.margin = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final runtimeBannerUrl =
        bind.mainGetOptionSync(key: kOptionCustomBannerUrl).trim();
    final builtInBannerUrl =
        bind.mainGetBuildinOption(key: kOptionCustomBannerUrl).trim();
    final configuredBannerUrl =
        runtimeBannerUrl.isNotEmpty ? runtimeBannerUrl : builtInBannerUrl;
    final bannerUrl = configuredBannerUrl.isNotEmpty
        ? configuredBannerUrl
        : _defaultBannerUrl;

    return Container(
      margin: margin,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: bannerUrl.isNotEmpty
            ? Image.network(
                bannerUrl,
                fit: BoxFit.fitWidth,
                width: double.infinity,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/banner.png',
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              )
            : Image.asset(
                'assets/banner.png',
                fit: BoxFit.fitWidth,
                width: double.infinity,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
      ),
    );
  }
}
