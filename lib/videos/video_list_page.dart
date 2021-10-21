import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/common_image_layout.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/routes.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/forgot_password/common_model.dart';
import 'package:my3skill_teacher_ios/localizations.dart';
import 'package:my3skill_teacher_ios/sections/models/models.dart';
import 'package:my3skill_teacher_ios/videos/videos_list_model.dart';


class VideoListPage extends StatefulWidget {
  final CourseSections sections;

  const VideoListPage({Key key, this.sections}) : super(key: key);

  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  bool isLoading = false;
  List<VideosData> videos = [];

  @override
  void initState() {
    super.initState();
    videos = widget.sections.videos;
    // _loadVideos();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: BaseScaffold(
        title: AppLocalizations.of(context).videoList,
        isDrawerVisible: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        child: _videosListLayout(),
      ),
    );
  }

  Widget _videosListLayout() {
    return Container(
      height: screenHeight,
      width: screenWidth,
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: videos != null && videos.length > 0
                    ? ListView.builder(
                        itemCount: videos.length,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 0.0),
                        itemBuilder: (context, index) {
                          return _singleCourseItem(videos[index]);
                        },
                      )
                    : Center(
                        child: Text(
                          AppLocalizations.of(context).noVideos,
                          style: Styles.customTextStyle(
                            color: Palette.appThemeColor,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
              ),
            ],
          ),
          Positioned(
            bottom: 15.0,
            right: 15.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Palette.appThemeColor,
                    Palette.appThemeLightColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: FloatingActionButton(
                onPressed: () async {
                  var result = await Navigator.of(context)
                      .pushNamed(Routes.ADD_VIDEO_PAGE, arguments: {
                    AppRouteArgKeys.COURSE_ID: widget.sections.courseId,
                    AppRouteArgKeys.SECTION_ID: widget.sections.id,
                  });

                  if (result is CommonModel) {
                    videos.add(result.data);
                    videos.sort((a, b) {
                      int positionOfA = int.tryParse('${a?.position}') ?? 0;
                      int positionOfB = int.tryParse('${b?.position}') ?? 0;
                      if (positionOfA < positionOfB) {
                        return 0;
                      } else {
                        return 1;
                      }
                    });
                    setState(() {});
                  }
                },
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _singleCourseItem(VideosData videosData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _itemData(videosData),
        SizedBox(height: 10.0),
        Divider(height: 2, thickness: 1),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _itemData(VideosData videosData) {
    return InkWell(
//      onTap: () {
////        Navigator.of(context).pushNamed(Routes.VIDEOS_PAGE);
//        print("Open video page");
//      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CommonImageLayout(
            image: videosData.thumb,
            width: screenWidth * 0.3,
            height: screenHeight * 0.10,
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5.0),
                Text(
                  videosData.title.sCap() ?? '',
                  style: Styles.customTextStyle(
                    fontSize: 17.0,
                    color: Palette.blackColor,
                    fontFamily: semiBold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  videosData.description.sCap() ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.customTextStyle(
                    fontSize: 14.0,
                    color: Palette.blackColor,
                    fontFamily: medium,
                  ),
                ),
                SizedBox(height: 8.0),
                _resourceSubtitleLayout(videosData),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resourceSubtitleLayout(VideosData videosData) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () {
//            print("add resource");
            Navigator.of(context).pushNamed(Routes.RESOURCES_PAGE, arguments: {
              AppRouteArgKeys.VIDEO_ID: videosData.id,
            });
          },
          child: Text(
            AppLocalizations.of(context).resource,
            style: Styles.customTextStyle(
              color: Palette.appThemeColor,
              fontSize: 13.0,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        InkWell(
          onTap: () {
//            print("add subtitle");
            Navigator.of(context).pushNamed(Routes.SUBTITLES_PAGE, arguments: {
              AppRouteArgKeys.VIDEO_ID: videosData.id,
            });
          },
          child: Text(
            AppLocalizations.of(context).subtitle,
            style: Styles.customTextStyle(
              color: Palette.appThemeColor,
              fontSize: 13.0,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        InkWell(
          onTap: () {
//            print("add subtitle");
            Navigator.of(context).pushNamed(Routes.QUESTIONS_PAGE, arguments: {
              AppRouteArgKeys.VIDEO_ID: videosData.id,
            });
          },
          child: Text(
            AppLocalizations.of(context).questions,
            style: Styles.customTextStyle(
              color: Palette.appThemeColor,
              fontSize: 13.0,
            ),
          ),
        ),
      ],
    );
  }
}
