import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:face_project_app/core/controllers/face_data_controller.dart';
import 'package:face_project_app/face_choice/edit_choice_buttons.dart';
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
  double _sliderValue = 0.0;
  final _facedataController = Get.find<FaceDataController>();

  void _updateWidgetIndex(int idx) {
    setState(() => _widgetIndex = idx);
  }

  Future<File> _getSelectedImage() async {
    return _facedataController.encodedImage.value;
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: PhotoView(
                  imageProvider: Image.file(_facedataController.encodedImage.value).image,
                )
            ),
            EditChoiceButtons(
                // updatewidgetIndex: _updateWidgetIndex,
                // getImageFile: _getSelectedImage,
            ),
              ]
              ),
        ),
    );
  }
}

