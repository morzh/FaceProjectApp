import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'dart:core';

import 'package:path_provider/path_provider.dart';
import 'package:face_project_app/edit_choice_page.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';


class ImageStruct {
  Uint8List imageData;
  double imageWidth;
  double imageHeight;
  List<Face> filteredFaces;

  ImageStruct({
    required this.imageData,
    required this.imageWidth,
    required this.imageHeight,
    required this.filteredFaces,
  });
}

class FaceDetectionPage extends StatefulWidget {
  final File imageFile;
  FaceDetectionPage({required this.imageFile});

  @override
  _FaceDetectionPage createState() => _FaceDetectionPage();
}

class _FaceDetectionPage extends State<FaceDetectionPage> {
  final faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(mode: FaceDetectorMode.accurate));
  final _rng = Random();
  late final imageSize;

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: Future.wait([_loadData()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          return snapshot.hasData ? new Scaffold(
            body: snapshot.data.length == 0
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
                          alignment: Alignment.topLeft,
                        ),
                        for (var face in snapshot.data[0].filteredFaces)
                          Positioned(
                            top: (MediaQuery.of(context).size.width / snapshot.data[0].imageWidth).clamp(0.01, 1.0) * face.boundingBox.top,
                            left: (MediaQuery.of(context).size.width / snapshot.data[0].imageWidth).clamp(0.01, 1.0) * face.boundingBox.left,
                            width: (MediaQuery.of(context).size.width / snapshot.data[0].imageWidth).clamp(0.01, 1.0) * face.boundingBox.width,
                            height: (MediaQuery.of(context).size.width / snapshot.data[0].imageWidth).clamp(0.01, 1.0)  * face.boundingBox.height,
                            child: GestureDetector(
                                onTap: () async {
                                    final String random = (_rng.nextInt(1000000)).toString();
                                    final Uint8List data = await _cropImage(snapshot.data[0].imageData, face.boundingBox);
                                    final String tempPath = (await getTemporaryDirectory()).path;
                                    final File dataFile = File('$tempPath/$random.jpg');
                                    if (dataFile.existsSync()) { dataFile.deleteSync(); }
                                    dataFile.writeAsBytesSync(data);
                                    // print(dataFile.path);
                                    // print( await dataFile.length());
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          EditChoicePage(
                                              imageFile: dataFile
                                          )
                                  )
                                  );
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

  Future _cropImage(imageData, Rect rect) async {
    final editorOption = ImageEditorOption();
    editorOption.addOption(ClipOption(x: rect.left, y: rect.top, width: rect.width, height : rect.height));
    return ImageEditor.editImage(
        image: imageData,
        imageEditorOption: editorOption);
  }

  Future detectFaces() async {
    final FirebaseVisionImage firebaseImage = FirebaseVisionImage.fromFile(widget.imageFile);
    final List<Face> detectedFaces = await faceDetector.processImage(firebaseImage);
    // faceDetector.close();
    final List<Face> filteredFaces = [];
    for (var face in detectedFaces) {
      if (face.boundingBox.longestSide / face.boundingBox.shortestSide > 2) {
        continue;
      }
      filteredFaces.add(face);
    }
  return filteredFaces;
  }

  Future _loadData() async {
    final imageData = await widget.imageFile.readAsBytes();
    final decodedImage = await decodeImageFromList(imageData);
    final imageSize = Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
    final FirebaseVisionImage firebaseImage = FirebaseVisionImage.fromFile(widget.imageFile);
    final List<Face> detectedFaces = await faceDetector.processImage(firebaseImage);
    // faceDetector.close();
    final List<Face> filteredFaces = [];
    for (var face in detectedFaces) {
      if (face.boundingBox.longestSide / face.boundingBox.shortestSide > 2) {
        continue;
      }
      filteredFaces.add(face);
    }

    print(filteredFaces[0].boundingBox);
    return ImageStruct(
      imageData: imageData,
      imageWidth: imageSize.width.toDouble(),
      imageHeight: imageSize.height.toDouble(),
      filteredFaces: filteredFaces
    );
  }
}


