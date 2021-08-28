import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:face_project_app/core/controllers/face_data_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_extend/share_extend.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../animatedIndexStack.dart';
// import 'package:face_project_app/core/models/face_data.dart';

List<AssetImage> _editChoiceButtons = [
  AssetImage('assets/buttons_images/head_left_right.png'),
  AssetImage('assets/buttons_images/head_up_down.png'),
  AssetImage('assets/buttons_images/head_old_young.png'),
  AssetImage('assets/buttons_images/head_expression.png'),
  AssetImage('assets/buttons_images/head_male_female.png'),
  AssetImage('assets/buttons_images/head_glasses.png'),
  AssetImage('assets/buttons_images/head_beard.png'),
  AssetImage('assets/buttons_images/head_bald_hairy.png'),
  AssetImage('assets/buttons_images/save.png'),
  AssetImage('assets/buttons_images/share.png'),
];

class AugmentFacePage extends StatefulWidget {
  final _facedataController = Get.find<FaceDataController>();
  @override
  _AugmentFacePage createState() => _AugmentFacePage();
}

class _AugmentFacePage extends State<AugmentFacePage> {
  int _widgetIndex = 0;
  double _sliderValue = 0.0;
  final faceDataController = Get.find<FaceDataController>();

  void _updateWidgetIndex(int idx) {
    setState(() => _widgetIndex = idx);
  }
  void _updateSliderValue(double value) {
    setState(() => _sliderValue = value);
  }
  double _getSliderValue() {
    return _sliderValue;
  }
  Future<File> _getSelectedImage() async {
    return widget._facedataController.encodedImage.value;
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: PhotoView(
                  imageProvider: Image.file(widget._facedataController.encodedImage.value).image,
                )
            ),
            AnimatedIndexedStack(
                  index: _widgetIndex,
                  // alignment: Alignment.bottomCenter,
                  children: <Widget>[
                EditChoice(
                    updatewidgetIndex: _updateWidgetIndex,
                    getImageFile: _getSelectedImage,
                ),
                EditWithSlider(
                  updateWidgetIndex: _updateWidgetIndex,
                  updateSliderValue: _updateSliderValue,
                  getSliderValue: _getSliderValue,),
              ]
              ),
          ],
        ),
      ),
    );
  }
}

class EditWithSlider extends StatelessWidget {
  final ValueChanged<double> updateSliderValue;
  final ValueChanged<int> updateWidgetIndex;
  final ValueGetter<double> getSliderValue;
  final faceDataController = Get.find<FaceDataController>();

  EditWithSlider ({
    required this.updateSliderValue,
    required this.updateWidgetIndex,
    required this.getSliderValue,
    Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white12
      ),
      child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Slider(
                  value: getSliderValue(),
                  activeColor: Colors.white60,
                  inactiveColor: Colors.white12,
                  onChanged: (newRatio) => updateSliderValue(newRatio),
                  min: 0.0,
                  max: 1.0,
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
                          onPressed: () => updateWidgetIndex(0),
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
                          onPressed: () => updateSliderValue(0.0),
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
                          onPressed: () => updateWidgetIndex(0),
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
    );
  }
}

class EditChoice extends StatelessWidget {
  final ValueChanged<int> updatewidgetIndex;
  final ValueGetter<Future<File>> getImageFile;
  final faceDataController = Get.find<FaceDataController>();

  EditChoice({
    required this.updatewidgetIndex,
    required this.getImageFile,
    Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white12
      ),
      child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(80),
                  children: [
                    TableRow(
                      children: [
                        TextButton(
                          onPressed: () => updatewidgetIndex(1),
                            child: Image(image: _editChoiceButtons[0])
                        ),
                        TextButton(
                            onPressed: () => updatewidgetIndex(1),
                            child: Image(image: _editChoiceButtons[1])
                        ),
                        TextButton(
                            onPressed: () => updatewidgetIndex(1),
                            child: Image(image: _editChoiceButtons[2])
                        ),
                        TextButton(
                            onPressed: () => updatewidgetIndex(1),
                            child: Image(image: _editChoiceButtons[3])
                        )
                        ]
                    ),
                    TableRow(
                      children: [
                        TextButton(
                            onPressed: () => updatewidgetIndex(1),
                            child: Image(image: _editChoiceButtons[4])
                        ),
                        TextButton(
                            onPressed: () => updatewidgetIndex(1),
                            child: Image(image: _editChoiceButtons[5])
                        ),
                        TextButton(
                            onPressed: () => updatewidgetIndex(1),
                            child: Image(image: _editChoiceButtons[6])
                        ),
                        TextButton(
                            onPressed: () => updatewidgetIndex(1),
                            child: Image(image: _editChoiceButtons[7])
                        ),
                      ]
                    )
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Table(
                    defaultColumnWidth: FixedColumnWidth(80),
                  children: [
                    TableRow(
                      children: [
                        TextButton(
                            onPressed: () async {
                              final File imageFile = await getImageFile();
                              await GallerySaver.saveImage(imageFile.path);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Image saved',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    backgroundColor: Colors.black45,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(25))
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    width: 200,
                                  )
                              );
                            },
                            child: Image(image: _editChoiceButtons[8])
                        ),
                        TextButton(
                            onPressed: () async {
                              final File imageFile = await getImageFile();
                              ShareExtend.share(imageFile.path, "file");
                            },
                            child: Image(image: _editChoiceButtons[9])),
                    ]
                  )
                ],
              ),
            )
            ],
      ),
    );
  }
}