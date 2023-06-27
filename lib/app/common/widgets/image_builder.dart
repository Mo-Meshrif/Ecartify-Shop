import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/assets_manager.dart';

class ImageBuilder extends StatelessWidget {
  final bool hasPlaceHolder;
  final String imageUrl;
  final double? height, width;
  final BoxFit? fit;

  const ImageBuilder({
    Key? key,
    this.hasPlaceHolder = true,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        placeholder: !hasPlaceHolder
            ? null
            : (_, __) => Lottie.asset(JsonAssets.loading),
      );
}
