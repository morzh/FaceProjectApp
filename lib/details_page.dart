import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget{
  final Image selectedImage;

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
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(11), bottomRight: Radius.circular(11)),
                  image: DecorationImage(
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