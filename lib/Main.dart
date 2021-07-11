import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:face_project_app/MediaGrid.dart';
import 'package:get/get.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:face_project_app/FaceDetectionPage.dart';
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
            onTap: () => _getImage(ImageSource.gallery)
          ),
          SpeedDialChild(
            child: const Icon(Icons.camera_alt),
            backgroundColor: theme.accentColor,
            label: "take photo from camera",
              onTap: () => _getImage(ImageSource.camera)
          )
        ],
      )
    );
  }

  Future _getImage(pickerSource) async{
    final pickedFile = await _imagePicker.getImage(source: pickerSource);
    if (pickedFile == null) return;
    final imageFile = File(pickedFile.path);
    setState(() {
      _image = imageFile;
    });
    Get.to(FaceDetectionPage(imageFile: _image));
  }
}
