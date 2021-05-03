import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'details_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Flow App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Face Flow App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _imagePicker = ImagePicker();
  File _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: MediaGrid(),
      floatingActionButton:  FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Take a photo',
        child: Icon(Icons.camera_alt),
      )
      );
  }

  Future getImage() async{
    final pickedFile = await _imagePicker.getImage(source: ImageSource.camera);
    if (pickedFile == null) return;
    final imageFile = File(pickedFile.path);
    setState(() {
      _image = imageFile;
    });
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => DetailsPage(
            selectedImage: Image.file(imageFile)
        )
    )
    );
  }
}

class MediaGrid extends StatefulWidget {
  @override
  _MediaGridState createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  List<Widget> _mediaList = [];
  int currentPage = 0;
  int lastPage;
  Directory _applicationDocumentsDirectory;
  String _absolutePath;
  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    _applicationDocumentsDirectory = await getApplicationDocumentsDirectory();
    print(_applicationDocumentsDirectory.path);
    lastPage = currentPage;
    var permissionGranted = await PhotoManager.requestPermission();
    if (permissionGranted) {
      List<AssetPathEntity> albums =
      await PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.image);
      print(albums);
      List<AssetEntity> media =  await albums[0].getAssetListPaged(currentPage, 60);
      print(media);
      List<Widget> temp = [];
      for (var asset in media) {
        // _absolutePath = await FlutterAbsolutePath.getAbsolutePath(asset.id);
        temp.add(
            FutureBuilder(
            future: asset.originBytes, // . thumbDataWithSize(200, 200),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return RawMaterialButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DetailsPage(
                              selectedImage: Image.memory(snapshot.data)
                            )
                        )
                      );
                    },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: MemoryImage(snapshot.data),
                        fit: BoxFit.cover
                          )
                      ),
                  )
                );
            return Container();
              }
          )
        );
      }
      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          _handleScrollEvent(scroll);
          return;
        },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),)
        ),
        child: GridView.builder(
            itemCount: _mediaList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index){
              return _mediaList[index];
            }),
      )
    );
  }
}