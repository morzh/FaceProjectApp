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
          ],
        ),
      ),
    );
  }
}