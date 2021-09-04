import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'dart:core';
import 'dart:typed_data';

import 'package:face_project_app/core/controllers/face_data_controller.dart';
import 'package:face_project_app/core/controllers/face_detection_controller.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:face_project_app/face_choice/face_edit_choice_page.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'package:face_project_app/core/controllers/face_data_controller.dart';
import 'package:face_project_app/face_detection/binding/face_detection_page_binding.dart';

class ImageStruct {
  Uint8List imageData;
  double imageWidth;
  double imageHeight;
  double scale;
  Offset offset;

  ImageStruct({
    required this.imageData,
    required this.imageWidth,
    required this.imageHeight,
    required this.scale,
    required this.offset,
  });
}

class FaceDetectionPage extends StatefulWidget {
  final _faceDataController = Get.find<FaceDataController>();
  final _faceDetectionController = Get.find<FaceDetectionController>();
  @override
  _FaceDetectionPage createState() => _FaceDetectionPage();
}

class _FaceDetectionPage extends State<FaceDetectionPage> {
  final _rng = Random();
  late final imageSize;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: Future.wait([_loadData(context), detectFaces()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData ? new Scaffold(
            body: snapshot.data[1].length == 0
            ?Center(child: Text(
                'No faces found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                )
              )
            )
            :InteractiveViewer(
                  minScale: 0.15,
                  maxScale: 5.0,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.memory(
                            snapshot.data[0].imageData,
                          // alignment: Alignment.topLeft,
                        ),
                        for (var face in snapshot.data[1])
                          Positioned(
                            top: snapshot.data[0].scale * face.boundingBox.top + snapshot.data[0].offset.dy,
                            left: snapshot.data[0].scale * face.boundingBox.left + snapshot.data[0].offset.dx,
                            width: snapshot.data[0].scale * face.boundingBox.width,
                            height: snapshot.data[0].scale * face.boundingBox.height,
                            child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _isLoading = !_isLoading;
                                  });
                                  final String random = (_rng.nextInt(1000000)).toString();
                                  final Uint8List data = await _cropImage(snapshot.data[0], face.boundingBox);
                                  final String tempPath = (await getTemporaryDirectory()).path;
                                  final String filePathImageSource = tempPath + '/' + random+'.jpg';
                                  final String filePathFaceDataBase = tempPath + '/' + random;
                                  print(filePathImageSource);
                                  final File dataFile = File(filePathImageSource);
                                  if (dataFile.existsSync()) { dataFile.deleteSync(); }
                                  dataFile.writeAsBytesSync(data);
                                  await _uploadImageToServer(dataFile, filePathFaceDataBase);
                                  // faceData.printLatents();
                                  Get.off(() => AugmentChoicePage());
                                },
                              child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0.015*MediaQuery.of(context).size.longestSide),
                                border: Border.all(
                                    width: 0.006*MediaQuery.of(context).size.longestSide,
                                    color: Colors.blueAccent),
                              ),
                            ),
                          ),
                          ),
                        Visibility(
                          visible: _isLoading,
                            child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 7,
                                )
                            )
                        )
                      ],
                    ),
                  ),
                // ),
          )
            :
          new Center(
              child: CircularProgressIndicator()
          );
        }
    );
  }

  Future _cropImage(imageStructData, Rect rect) async {
    final editorOption = ImageEditorOption();
    var imageRect = Rect.fromLTRB(0, 0, imageStructData.imageWidth - 1, imageStructData.imageHeight - 1);
    rect = rect.inflate(rect.longestSide);
    rect = rect.intersect(imageRect);
    editorOption.addOption(ClipOption(x: rect.left, y: rect.top, width: rect.width, height : rect.height));
    return ImageEditor.editImage(
        image: imageStructData.imageData,
        imageEditorOption: editorOption);
  }

  Future detectFaces() async {
    final image = widget._faceDataController.sourceImage.value;
    return await widget._faceDetectionController.detectFacesBoxes(image);
  }

  Future _loadData(BuildContext context) async {
    final imageData = await widget._faceDataController.sourceImage.value.readAsBytes();
    final decodedImage = await decodeImageFromList(imageData);

    double imageWidth = decodedImage.width.toDouble();
    double imageHeight = decodedImage.height.toDouble();

    double screenWidth = MediaQuery.of(context).size.width.toDouble();
    double screenHeight = MediaQuery.of(context).size.height.toDouble();

    double scaleWidth = screenWidth / imageWidth;
    double scaleHeight = screenHeight / imageHeight;
    double scale = min(scaleWidth, scaleHeight).clamp(0.01, 1.0);

    Offset offset = Offset(
      0.5 * (screenWidth - scale * imageWidth),
      0.5 * (screenHeight - scale * imageHeight),
    );

    return ImageStruct(
      imageData: imageData,
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      scale : scale,
      offset : offset,
    );
  }

  _uploadImageToServer(File imageFile, String filePath) async {
    var uri = Uri.parse('http://ec0c-104-154-216-127.ngrok.io');
    var request =  http.MultipartRequest("POST", uri);
    request.files.add(
        http.MultipartFile.fromBytes(
            'file', await imageFile.readAsBytes(),
            filename: basename(imageFile.path),
            contentType: MediaType('image','jpeg')
        )
    );

    final response = await request.send();
    print('response:');
    print(response.statusCode);
    // print(response.headers);
    final jsonResponse = json.decode(await response.stream.bytesToString());
    // print(jsonResponse["faceAttributes"]);
    // final FaceAttributes faceAttributes = FaceAttributes.fromJson(await jsonResponse["faceAttributes"]);
    final imageAlignedDecoded = base64.decode(await jsonResponse["ImageAligned"]);
    final imageEncodedDecoded = base64.decode(await jsonResponse["ImageEncoded"]);
    final latents = jsonResponse["latent"];
    // faceAttributes.printAttributes();
    final File alignedImage = File(filePath + '_aligned.jpg');
    final File encodedImage = File(filePath + '_encoded.jpg');
    alignedImage.writeAsBytesSync(imageAlignedDecoded.toList());
    encodedImage.writeAsBytesSync(imageEncodedDecoded.toList());
    setState(() {
      _isLoading = !_isLoading;
    });
    widget._faceDataController.alignedImage.value = alignedImage;
    widget._faceDataController.encodedImage.value = encodedImage;
    // widget._faceDataController.updateFaceAttributes(faceAttributes);
    widget._faceDataController.latentEncoded.value = latents;
    widget._faceDataController.latentAugmented.value = latents;
    widget._faceDataController.faceAttributesMap = await jsonResponse["faceAttributes"];
    widget._faceDataController.readAugmentedImages('assets/image_sequences/young_old/', 10);
  }
}


