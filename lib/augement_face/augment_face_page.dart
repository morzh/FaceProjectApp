import 'dart:ui';

import 'package:face_project_app/core/controllers/face_data_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';


class AugmentFacePage extends StatelessWidget {
  final _faceDataController = Get.find<FaceDataController>();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Obx(() => PhotoView(
                    imageProvider: _faceDataController.augmentedFaces[_faceDataController.currentSliderValue.value.toInt()].value,
              ),
            ),
            ),
            Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Obx(() =>
                      Slider(
                        value: _faceDataController.currentSliderValue.value,
                        activeColor: Colors.white60,
                        inactiveColor: Colors.white12,
                        onChanged: (newValue) => _faceDataController.currentSliderValue.value = newValue,
                        min: 0.0,
                        max: 9.0,
                      )
                    )
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                          children: [
                            TextButton(
                              onPressed: () => _faceDataController.currentSliderValue.value = 0.0,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white60,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => _faceDataController.currentSliderValue.value = 0.0,
                              child: Text(
                                'Reset',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white60,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'Accept',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white60,
                                ),
                              ),
                            )
                          ]
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}