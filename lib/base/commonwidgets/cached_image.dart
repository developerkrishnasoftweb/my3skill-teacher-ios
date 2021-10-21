import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../images_link.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final bool isRound;
  final double radius;
  final double height;
  final double width;

  final BoxFit fit;
  final String placeholder;

  final String noImageAvailable = "https://www.esm.rochester.edu/uploads/NoPhotoAvailable.jpg";

  CachedImage(
    this.imageUrl, {
    this.isRound = true,
    this.radius = 50.0,
    this.height = 50.0,
    this.width = 50.0,
    this.fit = BoxFit.cover,
    this.placeholder = ImagesLink.PLACEHOLDER,
  });

  @override
  Widget build(BuildContext context) {
//    showLog("image url ====> $imageUrl");
    try {
      return SizedBox(
        height: isRound ? radius : height,
        width: isRound ? radius : width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isRound ? 50 : radius),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: fit,
            height: height,
            width: width,
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                shape: isRound ? BoxShape.circle : BoxShape.rectangle,
                image: DecorationImage(
                  image: AssetImage(placeholder),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: isRound ? radius : height,
              width: isRound ? radius : width,
              decoration: BoxDecoration(
                shape: isRound ? BoxShape.circle : BoxShape.rectangle,
                image: DecorationImage(
                  image: AssetImage(placeholder),
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
//      print(e);
      return ClipOval(
        child: Image.network(
          noImageAvailable,
          height: isRound ? radius : height,
          width: isRound ? radius : width,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
