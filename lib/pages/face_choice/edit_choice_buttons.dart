import 'dart:ui';
import 'dart:convert';
import 'package:face_project_app/core/controllers/face_data_controller.dart';
import 'package:face_project_app/core/controllers/http_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:dio/dio.dart';
import 'package:share_extend/share_extend.dart';
import 'package:gallery_saver/gallery_saver.dart';

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
List<int> firstRowIndices = [0, 1, 2, 3];
List<int> secondRowIndices = [4, 5, 6, 7];
List<String> augmentTypesMap = ['Yaw', 'Pitch', 'Age', 'Expression', 'Gender', 'Glasses', 'Beard', 'Baldness'];

class EditChoiceButtons extends StatelessWidget {
  EditChoiceButtons({ Key? key, }) : super(key: key);
  final _faceDataController = Get.find<FaceDataController>();
  final _httpController = Get.find<HttpController>();
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
                      children: firstRowIndices.map((i) =>
                          TextButton(
                            onPressed: () async => await _requestAugmentedSequence(augmentTypesMap[i]),
                            child: Image(image: _editChoiceButtons[i])
                          )
                      ).toList()
                  ),
                  TableRow(
                      children: secondRowIndices.map((i) =>
                          TextButton(
                              onPressed: () async => await _requestAugmentedSequence(augmentTypesMap[i]),
                              child: Image(image: _editChoiceButtons[i])
                          )
                      ).toList()
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }

  _requestAugmentedSequence(String augmentationType) async {
    _faceDataController.currentAugmentationType = augmentationType;
    _faceDataController.initSlider();
    List latent = _faceDataController.latent;
    Map faceAttributes = _faceDataController.attributes;
    List faceLighting = _faceDataController.lighting;
    Response response =  await _httpController.augmentFace(augmentationType, latent, faceAttributes, faceLighting);
    _processAugmentRequest(response);
    // print(response);
    Get.toNamed("/face_augmentation");
  }
  
  _processAugmentRequest(Response response) {
    print('response: ' + response.statusCode.toString() + '; headers' + response.headers.toString());
    final jsonResponse = jsonDecode(response.toString());
    // print(jsonResponse);

    _faceDataController.augmentedFaceImages.clear();
    for(var imageString in jsonResponse['augmented_images']) {
      final imageDecoded = base64.decode(imageString);
      Image image = Image.memory(imageDecoded);
      _faceDataController.augmentedFaceImages.add(image.obs);
    }

    _faceDataController.augmentedFaceLatents.clear();
    for(var latent in jsonResponse['augmented_latents']) {
      _faceDataController.augmentedFaceLatents.add(latent);
    }

/*
    print('_faceDataController.augmentedFaceLatents.length: ${_faceDataController.augmentedFaceLatents.length}');
    print('_faceDataController.augmentedFaceLatents[0].length: ${_faceDataController.augmentedFaceLatents[0].length}');
    print('_faceDataController.augmentedFaceLatents[0][0].length: ${_faceDataController.augmentedFaceLatents[0][0].length}');
*/

    // assert(_faceDataController.augmentedFaceImages.length == _faceDataController.augmentedFaceLatents.length);
    _faceDataController.augmentedEntitiesNumber = _faceDataController.augmentedFaceImages.length.toDouble();

    Get.toNamed("/face_augmentation");
  }
}