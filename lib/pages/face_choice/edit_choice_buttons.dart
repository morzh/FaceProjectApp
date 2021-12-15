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
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Table(
              defaultColumnWidth: FixedColumnWidth(80),
              children: [
                TableRow(
                    children: [
                      TextButton(
                          onPressed: () async {
                            await GallerySaver.saveImage(_faceDataController.encodedImage.value.path);
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
                            ShareExtend.share(_faceDataController.encodedImage.value.path, "file");
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

  _requestAugmentedSequence(String augmentationType) async {
    List latent = _faceDataController.latentAugmented.value;
    Map faceAttributes = _faceDataController.faceAttributesMap;
    List faceLighting = _faceDataController.faceLighting.value;
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
    Get.toNamed("/face_augmentation");
  }
}