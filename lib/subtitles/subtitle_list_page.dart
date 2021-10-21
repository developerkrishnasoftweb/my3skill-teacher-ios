import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/routes.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/localizations.dart';
import 'package:my3skill_teacher_ios/subtitles/subtitle_model.dart';

class SubtitlesListPage extends StatefulWidget {
  final String videoId;

  const SubtitlesListPage({Key key, this.videoId}) : super(key: key);

  @override
  _SubtitlesListPageState createState() => _SubtitlesListPageState();
}

class _SubtitlesListPageState extends State<SubtitlesListPage> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  bool isLoading = false;
  List<SubtitleData> subtitles = List();

  @override
  void initState() {
    super.initState();
    _loadSubs();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: BaseScaffold(
        title: AppLocalizations.of(context).subtitleList,
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
                child: subtitles != null && subtitles.length > 0
                    ? ListView.builder(
                        itemCount: subtitles.length,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                        itemBuilder: (context, index) {
                          return _singleCourseItem(subtitles[index]);
                        },
                      )
                    : Center(
                        child: Text(
                          AppLocalizations.of(context).noSubtitles,
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
                  var result = await Navigator.of(context).pushNamed(Routes.ADD_SUBTITLES_PAGE, arguments: {
                    AppRouteArgKeys.VIDEO_ID: widget.videoId,
                    AppRouteArgKeys.TYPE: 1,
                  });

                  if (result == 'Success') {
                    _loadSubs();
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

  Widget _singleCourseItem(SubtitleData subtitleData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _itemData(subtitleData),
        SizedBox(height: 10.0),
        Divider(
          height: 2,
          thickness: 1,
          indent: 8.0,
          endIndent: 8.0,
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _itemData(SubtitleData subtitleData) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        subtitleData.title ?? '',
        style: Styles.customTextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 21.0,
          color: Palette.blackColor,
        ),
      ),
    );
  }

  void _loadSubs() async {
    _startLoading();

    var response = await ApiData.getSubtitlesList(widget.videoId);
    subtitles.clear();
    if (response != null && response.status == 'true' && response.subtitle != null) {
      subtitles = response.subtitle;
      _stopLoading();
    } else {
      _stopLoading();
      showToast('Something went wrong in fetching subtitles list. Please try again later.');
    }
  }

  void _startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void _stopLoading() {
    setState(() {
      isLoading = false;
    });
  }
}
