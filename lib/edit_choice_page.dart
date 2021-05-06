import 'package:flutter/material.dart';
// import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:photo_view/photo_view.dart';
// import ‘package:mlkit/mlkit.dart’;


List<AssetImage> _editChoiceButtons = [
  AssetImage('assets/buttons_images/male-female.png'),
  AssetImage('assets/buttons_images/male-female.png'),
  AssetImage('assets/buttons_images/male-female.png'),
  AssetImage('assets/buttons_images/male-female.png'),
  AssetImage('assets/buttons_images/male-female.png'),
  AssetImage('assets/buttons_images/male-female.png'),
  AssetImage('assets/buttons_images/male-female.png'),
  AssetImage('assets/buttons_images/male-female.png'),
];

class EditChoicePage extends StatefulWidget {
  final Image selectedImage;
  EditChoicePage({@required this.selectedImage}){
    // print(selectedImage);
  }
  @override
  _EditChoicePage createState() => _EditChoicePage();
}

class _EditChoicePage extends State<EditChoicePage>{

  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Container(
                    child: PhotoView(
                      imageProvider: widget.selectedImage.image,
                    )
                ),
                ),
            Container(
              height: 210,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Table(
                      defaultColumnWidth: FixedColumnWidth(80),
                      children: [
                        TableRow(
                          children: [
                            Image(image: _editChoiceButtons[0]),
                            Image(image: _editChoiceButtons[1]),
                            Image(image: _editChoiceButtons[2]),
                            Image(image: _editChoiceButtons[3])
                            ]
                        ),
                        TableRow(
                          children: [
                            Image(image: _editChoiceButtons[4]),
                            Image(image: _editChoiceButtons[5]),
                            Image(image: _editChoiceButtons[6]),
                            Image(image: _editChoiceButtons[7]),
                          ]
                        )
                      ],
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}