import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:face_project_app/edit_choice_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Face Flow App',
      theme:
      ThemeData.from(colorScheme: ColorScheme.light()),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.from(colorScheme: ColorScheme.dark()),
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
      // backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 8,),
            Text('    Face Project App', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              // color: Colors.white70,
            ),
              textAlign: TextAlign.left,),
          SizedBox( height: 14, ),
          Expanded(
            child: MediaGrid(),
            )
          ],
      )
      ),
      floatingActionButton:  FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Take a photo',
        child: Icon(Icons.camera_alt),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))
        ),
        foregroundColor: Colors.grey,
        backgroundColor: Colors.black87,
      ),
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
        builder: (context) => EditChoicePage(
            selectedImage: Image.file(_image)
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

  Future<void> _showInfo(AssetEntity entity) async {
    if (entity.type == AssetType.video) {
      var file = await entity.file;
      if (file == null) {
        return;
      }
      var length = file.lengthSync();
      var size = entity.size;
      print(
        "${entity.id} length = $length, "
            "size = $size, "
            "dateTime = ${entity.createDateTime}",
      );
    } else {
      final Size size = entity.size;
      print("${entity.id} size = $size, dateTime = ${entity.createDateTime}");
    }
  }

  _fetchNewMedia() async {
    _applicationDocumentsDirectory = await getApplicationDocumentsDirectory();
    print(_applicationDocumentsDirectory.path);
    lastPage = currentPage;
    var permissionGranted = await PhotoManager.requestPermission();
    if (permissionGranted) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.image);
      print(albums);
      List<AssetEntity> media =  await albums[0].getAssetListPaged(currentPage, 60);
      print(media);
      List<Widget> temp = [];
      for (var asset in media) {
        // _absolutePath = await FlutterAbsolutePath.getAbsolutePath(asset.id);
        temp.add(
            FutureBuilder(
            future: asset.thumbData,
            // future: asset.thumbDataWithSize(150, 150),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return GestureDetector(
                    onTap: () async {
                      File file = await asset.file;
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              EditChoicePage(
                              selectedImage: Image.file(file)
                              )
                      )
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.8),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                          ],
                          image: DecorationImage(
                              image: MemoryImage(snapshot.data),
                              fit: BoxFit.cover
                          )
                      ),
                    )
                );
              } else {
                return Icon(Icons.image_rounded);
              }
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
            color: Colors.white10,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              // topRight: Radius.circular(5),
            )
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