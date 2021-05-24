import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:face_project_app/edit_choice_page.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';

class FaceDetectionPage extends StatefulWidget {
  final File imageFile;
  FaceDetectionPage({required this.imageFile});

  @override
  _FaceDetectionPage createState() => _FaceDetectionPage();
}

class _FaceDetectionPage extends State<FaceDetectionPage> {
  final faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(mode: FaceDetectorMode.accurate));
  late File _fileBBoxFace;
  final _rng = Random();

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: Future.wait([detectFaces(), loadImage()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData ? new Scaffold(
            body: snapshot.data[0].length == 0
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
            :Center(
              child: InteractiveViewer(
                  minScale: 0.45,
                  maxScale: 3.0,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.memory(snapshot.data[1]),
                        for (var face in snapshot.data[0] )
                          Positioned(
                            top: 0.41*face.boundingBox.top,
                            left: 0.41*face.boundingBox.left,
                            width: 0.41*face.boundingBox.width,
                            height: 0.41*face.boundingBox.height,
                            child: GestureDetector(
                                onTap: () async {
                                    final String random = (_rng.nextInt(1000000)).toString();
                                    final Uint8List data = await _cropImage(snapshot.data[1], face.boundingBox);
                                    final String tempPath = (await getTemporaryDirectory()).path;
                                    final File dataFile = File('$tempPath/$random.jpg');
                                    // final File dataFile = File('$tempPath/tempFaceImage.jpg');
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
                              child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0.01*MediaQuery.of(context).size.longestSide),
                                border: Border.all(
                                    width: 0.003*MediaQuery.of(context).size.longestSide,
                                    color: Colors.blueAccent),
                              ),
                            ),
                          ),
                          )
                      ],
                    ),
                  ),
                ),
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
    final FirebaseVisionImage firebaseImage = FirebaseVisionImage.fromFile(
        widget.imageFile);

    final List<Face> detectedFaces = await faceDetector.processImage(
        firebaseImage);
    // faceDetector.close();

  return detectedFaces;
  }

  Future loadImage() async {
    final data = await widget.imageFile.readAsBytes();
    return data;
  }


}


