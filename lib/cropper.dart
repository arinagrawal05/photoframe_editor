import 'dart:io';

import 'package:celebrare/components.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';

class CropPage extends StatefulWidget {
  final File image;

  const CropPage({super.key, required this.image});

  @override
  State<CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  final controller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: cropButtons(controller, context),
          leading: Container(
            width: 0,
          ),
          leadingWidth: 0,
        ),
        body: Center(
          child: SizedBox(
            height: double.infinity,
            width: MediaQuery.of(context).size.width,
            child: CropImage(
              controller: controller,
              image: Image.file(widget.image),
              alwaysMove: true,
            ),
          ),
        ),
      );
}
