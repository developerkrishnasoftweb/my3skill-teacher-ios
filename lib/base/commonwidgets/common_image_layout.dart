import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_url.dart';

import '../images_link.dart';

class CommonImageLayout extends StatelessWidget {
  final double width;
  final double height;
  final String image;

  const CommonImageLayout({
    Key key,
    this.width,
    this.height,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 100,
      height: height ?? 80,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: CachedNetworkImage(
          width: width ?? 100,
          height: height ?? 80,
          imageUrl: ApiUrls.IMAGE_URL + image,
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagesLink.PLACEHOLDER),
                fit: BoxFit.cover,
              ),
            ),
          ),
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagesLink.PLACEHOLDER),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
