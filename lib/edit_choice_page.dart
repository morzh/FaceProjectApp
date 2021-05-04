import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:photo_view/photo_view.dart';

class EditChoicePage extends StatefulWidget {
  final Image selectedImage;
  EditChoicePage({@required this.selectedImage}){
    print(selectedImage);
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
              child: GestureDetector(
                // dragStartBehavior: DragStartBehavior.start,
                onScaleStart: (ScaleStartDetails details) {
                  _previousScale = _scale;
                  setState(() {});
                },
                onScaleUpdate: (ScaleUpdateDetails details) {
                  _scale = _previousScale * details.scale;
                  setState(() {});
                },
                onScaleEnd: (ScaleEndDetails details) {
                  _previousScale = 1.0;
                  setState(() {});
                },
                  // onHorizontalDragStart: (),
                  child: Transform(
                    alignment: FractionalOffset.center,
                    transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
                    child: Image(
                        image: widget.selectedImage.image,
                        fit: BoxFit.fitWidth,
                    ),
                  )
                  ),
                ),
            Container(
              height: 150,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: <Widget>[
                        Text("Some text", style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        ),
                      ],
                    ),
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