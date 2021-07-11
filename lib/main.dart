import 'dart:async';
import 'dart:io';

// import 'package:face_project_app/ExpandableFab.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:face_project_app/face_detection_page.dart';
import 'package:get/get.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:animate_icons/animate_icons.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Face Flow App',
      theme: ThemeData.from(colorScheme: ColorScheme.light()),
      darkTheme: ThemeData.from(colorScheme: ColorScheme.dark()),
      themeMode: ThemeMode.system,
      home: MyHomePage(title: 'Face Flow App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({required Key key, required this.title}) : super(key: key);
  final String title;
  MyHomePage({required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _scrollController = ScrollController();
  var isOpen = false;
  final _imagePicker = ImagePicker();
  late File _image;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              toolbarHeight: 25,
              stretch: true,
              pinned: false,
              // expandedHeight: 100,
              title: Text("Face Project App"),
              // floating: true
            ),
          ];
        },
        body: MediaGrid()
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        activeBackgroundColor: theme.backgroundColor,
        backgroundColor: theme.accentColor,
        spaceBetweenChildren: 15,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.insert_photo),
            backgroundColor: theme.accentColor,
            label: "choose image from gallery",
            onTap: () =>_showAction(0)
          ),
          SpeedDialChild(
            child: const Icon(Icons.camera_alt),
            backgroundColor: theme.accentColor,
            label: "take photo from camera",
              onTap: () =>_showAction(1)
          )
        ],
      )
    );
  }


  void _showAction(int index) {
       index == 1 ? getImage(ImageSource.camera): getImage(ImageSource.gallery);
  }

  Future getImage(pickerSource) async{
    final pickedFile = await _imagePicker.getImage(source: pickerSource);
    if (pickedFile == null) return;
    final imageFile = File(pickedFile.path);
    setState(() {
      _image = imageFile;
    });
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => FaceDetectionPage(
          imageFile: _image,
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
  int lastPage = 0;
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
    lastPage = currentPage;
    var permissionGranted = await PhotoManager.requestPermission();
    if (permissionGranted) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.image);
      print(albums);
      List<AssetEntity> media =  await albums[0].getAssetListPaged(currentPage, 60);
      print(media);
      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(
            FutureBuilder(
            future: asset.thumbData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return GestureDetector(
                    onTap: () async {
                      File file = (await asset.file)!;
                      Get.to(FaceDetectionPage(imageFile: file,));
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
              } else {
                return Icon(Icons.image_rounded);
              }  // return Container();
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
          return true;
        },
      child: Container(
        child: GridView.builder(
            itemCount: _mediaList.length,
            shrinkWrap: true,
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