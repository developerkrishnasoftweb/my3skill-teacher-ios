import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/routes.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/localizations.dart';
import 'package:my3skill_teacher_ios/resources/models/resources_model.dart';

class ResourcesListPage extends StatefulWidget {
  final String videoId;

  const ResourcesListPage({Key key, this.videoId}) : super(key: key);

  @override
  _ResourcesListPageState createState() => _ResourcesListPageState();
}

class _ResourcesListPageState extends State<ResourcesListPage> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  bool isLoading = false;
  List<ResourcesData> resources = List();

  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: BaseScaffold(
        title: AppLocalizations.of(context).resourceList,
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
                child: resources != null && resources.length > 0
                    ? ListView.builder(
                        itemCount: resources.length,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                        itemBuilder: (context, index) {
                          return _singleCourseItem(resources[index]);
                        },
                      )
                    : Center(
                        child: Text(
                          AppLocalizations.of(context).noResources,
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
                  print("Add subtitle..");
                  var result = await Navigator.of(context).pushNamed(Routes.ADD_RESOURCES_PAGE, arguments: {
                    AppRouteArgKeys.VIDEO_ID: widget.videoId,
                    AppRouteArgKeys.TYPE: 0,
                  });

                  if (result == 'Success') {
                    _loadResources();
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

  Widget _singleCourseItem(ResourcesData resourcesData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _itemData(resourcesData),
        SizedBox(height: 10.0),
        Divider(
          height: 2,
          thickness: 1,
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _itemData(ResourcesData resourcesData) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        resourcesData.title.sCap() ?? '',
        style: Styles.customTextStyle(
          fontSize: 21.0,
          color: Palette.blackColor,
        ),
      ),
    );
  }

  void _loadResources() async {
    _startLoading();

    var response = await ApiData.getResourcesList(widget.videoId);
    resources.clear();
    if (response != null && response.status == 'true' && response.resources != null) {
      resources = response.resources;
      _stopLoading();
    } else {
      _stopLoading();
      showToast('Something went wrong in fetching resources list. Please try again later.');
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
