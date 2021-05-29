import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

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
      FaceDetectorOptions(mode: FaceDetectorMode.fast));
  late File _fileBBoxFace;
  final _rng = Random();
  late ui.Image image;

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: Future.wait([detectFaces(), loadImage()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData ? new Scaffold(
            body: snapshot.data[0].length == 0
            ?
            Center(child: Text(
                'No faces found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                )
              )
            )
            :
                  InteractiveViewer(
                    minScale: 0.25,
                    maxScale: 3.0,
                    child: FittedBox(
                      child: SizedBox(
                        width: snapshot.data[1].width.toDouble(),
                        height: snapshot.data[1].height.toDouble(),
                        child: CustomPaint(
                          painter: MyPainter(
                            image: snapshot.data[1],
                            faces: snapshot.data[0],
                            ),

                        ),
                      ),
                    ),
                  ),
                // ),
/*            Center(
              child: InteractiveViewer(
                  minScale: 0.45,
                  maxScale: 3.0,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.memory(snapshot.data[1]),
                        for (var face in snapshot.data[0] )
                          Positioned(
                            top: face.boundingBox.top,
                            left: face.boundingBox.left,
                            width: face.boundingBox.width,
                            height: face.boundingBox.height,
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
                ),*/
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
    final image = await decodeImageFromList(data);
    return image;
  }


}

class MyPainter extends CustomPainter{
  List<Face> faces;
  ui.Image image;

  MyPainter({required this.image, required this.faces});

  @override
  void paint(Canvas canvas, Size size) {
    // loadImage();
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..color = Colors.indigo;

    canvas.drawImage(image, Offset.zero, paint);
    for (var face in faces) {
      final rect = Rect.fromLTWH(
          face.boundingBox.left,
          face.boundingBox.top,
          face.boundingBox.width,
          face.boundingBox.height
      );
      final radius = Radius.circular(32);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
    }

  }
  @override
  bool shouldRepaint(CustomPainter old)  {
    print('sdfsdg')
    return false;
  };
}

