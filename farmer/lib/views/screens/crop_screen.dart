import 'dart:io';
import 'dart:ui';

import 'package:farmer/constants/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:simple_image_crop/simple_image_crop.dart';

class SimpleCropRoute extends StatefulWidget {
  @override
  _SimpleCropRouteState createState() => _SimpleCropRouteState();
}

class _SimpleCropRouteState extends State<SimpleCropRoute> {
  final cropKey = GlobalKey<ImgCropState>();

  Future<Null> showImage(BuildContext context, File file) async {
    new FileImage(file)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      print('-------------------------------------------$info');
    }));
    return showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                'Current screenshot：',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).primaryColor,
                    letterSpacing: 1.1),
              ),
              content: Image.file(file));
        });
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Zoom and Crop',
            style: TextStyle(color: ThemeColors.colorAccent),
          ),
          backgroundColor: Colors.white,
          leading: new IconButton(
            icon:
                new Icon(Icons.navigate_before, color: Colors.black, size: 40),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: ImgCrop(
            key: cropKey,
            chipRadius: 150,
            chipShape: ChipShape.circle,
            image: FileImage(args['image']),
            // handleSize: 0.0,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ThemeColors.colorAccent,
          onPressed: () async {
            final crop = cropKey.currentState;
            final croppedImage =
                await crop.cropCompleted(args['image'], preferredSize: 1000);
            Navigator.pop(context, croppedImage);
          },
          child: Text(
            'Crop',
            style: TextStyle(color: Colors.white),
          ),
        ));
  }
}
