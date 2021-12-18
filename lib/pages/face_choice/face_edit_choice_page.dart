import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:face_project_app/core/controllers/face_data_controller.dart';
import 'package:face_project_app/pages/face_choice/edit_choice_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_extend/share_extend.dart';
import 'package:gallery_saver/gallery_saver.dart';

class AugmentChoicePage extends StatefulWidget {
  @override
  _AugmentChoiceFacePage createState() => _AugmentChoiceFacePage();
}

class _AugmentChoiceFacePage extends State<AugmentChoicePage> {
  int _widgetIndex = 0;
  final _facedataController = Get.find<FaceDataController>();

  void _updateWidgetIndex(int idx) {
    setState(() => _widgetIndex = idx);
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Obx(() => PhotoView(
                    imageProvider: _facedataController.encodedImage.value.image,
                  ),)
              ),
              EditChoiceButtons(),
                ]
                ),
          ),
      ),
    );
  }
}

