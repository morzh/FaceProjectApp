import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget{
  final Image selectedImage;
  double _imageScale = 1.0;
  double _imagePreviousScale = 1.0;

  DetailsPage({@required this.selectedImage}){
    print(selectedImage);
  }

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
                      image: selectedImage.image,
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