import 'package:flutter/material.dart';

class EditChoicePage extends StatefulWidget {
  final Image selectedImage;
  EditChoicePage({@required this.selectedImage}){
    print(selectedImage);
  }
  @override
  _EditChoicePage createState() => _EditChoicePage();
}

class _EditChoicePage extends State<EditChoicePage>{

  double _imageScale = 1.0;
  double _imagePreviousScale = 1.0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onPanEnd: (e) => print(e),
                child: Container(
                  child: Image(
                      image: widget.selectedImage.image,
                      fit: BoxFit.fitWidth,
                  )
                  ),
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