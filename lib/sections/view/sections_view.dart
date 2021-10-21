import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';

import '../../localizations.dart';
import '../sections.dart';

class SectionList extends StatefulWidget {
  final String courseId;

  const SectionList({Key key, this.courseId}) : super(key: key);

  @override
  _SectionListState createState() => _SectionListState();
}

class _SectionListState extends State<SectionList> {
  bool _isLoading = false;
  List<CourseSections> _sections = [];

  set _setLoading(bool status) {
    setState(() {
      _isLoading = status;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: BaseScaffold(
        title: AppLocalizations.of(context).sections,
        isDrawerVisible: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        child: _sectionsLayout(),
      ),
    );
  }

  Widget _sectionsLayout() {
    return Stack(
      children: [
        ListView.builder(itemBuilder: itemBuilder, itemCount: _sections.length),
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
              onPressed: _addSection,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 28.0,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget itemBuilder(BuildContext _, int index) {
    return sectionTile(_sections[index], context,
        callBack: (v) => _loadSections(),
        onDelete: () => _deleteSection(_sections[index]),
        onUpdate: () => _updateSection(_sections[index]));
  }

  void _loadSections() async {
    _setLoading = true;
    var data = await ApiData.getCourseSections(widget.courseId);
    if (data != null) {
      if (data.isNotEmpty) {
        _sections = data;
      } else {
        showToast('No sections found in this course.');
      }
    } else {
      showToast('Something went wrong in fetching sections. Please try again later.');
    }
    _setLoading = false;
  }

  void _addSection() async {
    var sectionData = await alert<Map<String, String>>(context);
    if (sectionData == null) return;
    if (sectionData.isEmpty) return;
    _setLoading = true;
    var data = await ApiData.addSection(
        <String, dynamic>{'course': widget.courseId, 'title': sectionData['title'], 'position': sectionData['position']});
    if (data != null && data.status == 'true') {
      _sections.add(data.data);
      _sections.sort((a, b) {
        int positionOfA = int.tryParse('${a?.position}') ?? 0;
        int positionOfB = int.tryParse('${b?.position}') ?? 0;
        if (positionOfA < positionOfB) {
          return 0;
        } else {
          return 1;
        }
      });
    } else {
      showToast('Unable to add section');
    }
    _setLoading = false;
  }

  _updateSection(CourseSections section) async {
    var sectionData = await alert<Map<String, String>>(context, isUpdate: true, courseSections: section);
    if (sectionData == null) return;
    if (sectionData.isEmpty) return;
    _setLoading = true;
    var data = await ApiData.updateSection(
        <String, dynamic>{'section_id': section.id, 'title': sectionData['title'], 'position': sectionData['position']});
    if (data != null && data.status == 'true') {
      section.title = sectionData['title'];
      section.position = sectionData['position'];
      _sections.sort((a, b) {
        int positionOfA = int.tryParse('${a?.position}') ?? 0;
        int positionOfB = int.tryParse('${b?.position}') ?? 0;
        if (positionOfA < positionOfB) {
          return 0;
        } else {
          return 1;
        }
      });
      setState(() {});
    } else {
      showToast('Unable to update section');
    }
    _setLoading = false;
  }

  _deleteSection(CourseSections section) async {
    _setLoading = true;
    var data = await ApiData.deleteSection(section.id);
    if (data != null && data.status == 'true') {
      _sections.remove(section);
    } else {
      showToast('Unable to delete section');
    }
    _setLoading = false;
  }
}
