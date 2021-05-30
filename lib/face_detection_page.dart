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
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter/file_input.dart';


class ImageStruct {
  Uint8List imageData;
  double imageWidth;
  double imageHeight;

  ImageStruct({
    required this.imageData,
    required this.imageWidth,
    required this.imageHeight
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
        future: Future.wait([detectFaces(), loadImage()]/*, getIamgeSize()]*/),
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
            :InteractiveViewer(
                  minScale: 0.15,
                  maxScale: 5.0,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.memory(
                            snapshot.data[1].imageData,
                          alignment: Alignment.topLeft,
                        ),
                        for (var face in snapshot.data[0])
                          Positioned(
                            top: (MediaQuery.of(context).size.width / snapshot.data[1].imageWidth).clamp(0.01, 1.0) * face.boundingBox.top,
                            left: (MediaQuery.of(context).size.width / snapshot.data[1].imageWidth).clamp(0.01, 1.0) * face.boundingBox.left,
                            width: (MediaQuery.of(context).size.width / snapshot.data[1].imageWidth).clamp(0.01, 1.0) * face.boundingBox.width,
                            height: (MediaQuery.of(context).size.width / snapshot.data[1].imageWidth).clamp(0.01, 1.0)  * face.boundingBox.height,
                            child: GestureDetector(
                                onTap: () async {
                                    final String random = (_rng.nextInt(1000000)).toString();
                                    final Uint8List data = await _cropImage(snapshot.data[1], face.boundingBox);
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
                              child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                // borderRadius: BorderRadius.circular(0.01*MediaQuery.of(context).size.longestSide),
                                border: Border.all(
                                    width: 10,
                                    // width: 0.03*MediaQuery.of(context).size.longestSide,
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
  // return detectedFaces;
  return filteredFaces;
  }

  Future getIamgeSize() async {
    final memoryImageSize = ImageSizeGetter.getSize(FileInput(widget.imageFile));
    return memoryImageSize.width;
  }

  Future loadImage() async {
    // print('image width is:');
    final imageData = await widget.imageFile.readAsBytes();
    final imageSize = ImageSizeGetter.getSize(MemoryInput(imageData));
    // final image = Image.memory(
    //     data,
    //     width: memoryImageSize.width.toDouble(),
    //     height: memoryImageSize.height.toDouble(),
    //   );
    // print(memoryImageSize);
    return ImageStruct(
        imageData: imageData,
        imageWidth: imageSize.width.toDouble(),
        imageHeight: imageSize.height.toDouble()
    );
  }
}


