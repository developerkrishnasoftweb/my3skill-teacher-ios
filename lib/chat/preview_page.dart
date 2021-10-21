import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_url.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/images_link.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:share/share.dart';

class PreviewPage extends StatefulWidget {
  final String url;
  final String tag;
  final isNetwork;

  const PreviewPage({
    Key key,
    this.url,
    this.isNetwork = false,
    this.tag,
  }) : super(key: key);

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(body: _previewPage());
  }

  Widget _previewPage() {
    return Stack(fit: StackFit.expand, children: <Widget>[
      AspectRatio(
          aspectRatio: 1.0, child: widget.isNetwork ? _imageLayout() : Image.file(File(widget.url), fit: BoxFit.cover)),
      SafeArea(
          child: Align(
              alignment: Alignment.topCenter,
              child: Row(children: [
                IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop()),
                spacer(width: 15),
                Expanded(
                    child: Text(
                        widget.url.isNotEmpty ? widget.url.split("/").last.trim().toString() : "NoPhotoAvailable.jpg",
                        style: Styles.customTextStyle(color: Colors.white, fontSize: 18))),
                Visibility(
                    visible: widget.isNetwork,
                    child: IconButton(
                        icon: Icon(Icons.share, color: Colors.white),
                        onPressed: () {
                          final RenderBox box = context.findRenderObject();
                          Share.share("Share ${widget.url.split("/").last.trim().toString()}",
                              subject: "Hey I found this course amazing.",
                              sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                        }))
              ]))),
      Visibility(
          visible: !widget.isNetwork,
          child: Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                  onTap: () => Navigator.of(context).pop('SUCCESS'),
                  child: Container(
                      height: 50.0,
                      width: screenWidth,
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Palette.appThemeColor, borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: Text("Send", style: Styles.customTextStyle(color: Colors.white, fontSize: 16)))))))
    ]);
  }

  Widget _imageLayout() {
    return Hero(
        tag: widget.tag,
        child: CachedNetworkImage(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.4,
            imageUrl: widget.url != null && widget.url.isNotEmpty
                ? ApiUrls.IMAGE_URL + widget.url
                : "https://www.esm.rochester.edu/uploads/NoPhotoAvailable.jpg",
            fit: BoxFit.cover,
            placeholder: (context, url) => _placeHolder(),
            errorWidget: (context, url, error) => _placeHolder()));
  }

  Widget _placeHolder() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.width * 0.4,
        child: Container(
            decoration:
                BoxDecoration(image: DecorationImage(image: AssetImage(ImagesLink.PLACEHOLDER), fit: BoxFit.cover))));
  }
}
