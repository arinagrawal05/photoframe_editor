import 'package:celebrare/homepage.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:widget_mask/widget_mask.dart';

Widget orignalbox() {
  return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(4),
      decoration: decoration(),
      child: const Text("Orignal"));
}

Widget shapebox(String address, String news) {
  return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(4),
      decoration: decoration(),
      height: 40,
      width: 40,
      child: Image.asset(address));
}

Widget customButton(
  String text,
  void Function()? ontap,
  BuildContext context, {
  bool isExpanded = true,
  Color color = Colors.teal,
}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: MaterialButton(
      minWidth: isExpanded ? MediaQuery.of(context).size.width : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color,
      onPressed: ontap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        ),
      ),
    ),
  );
}

BoxDecoration decoration() {
  return BoxDecoration(
      border: Border.all(width: 0.5, color: Colors.grey),
      borderRadius: BorderRadius.circular(5));
}

Widget cropButtons(CropController controller, BuildContext context) => Row(
      children: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            controller.rotation = CropRotation.up;
            controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
            controller.aspectRatio = 1;
          },
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(
            Icons.aspect_ratio,
            color: Colors.white,
          ),
          onPressed: () {
            aspectRatios(controller, context);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.rotate_90_degrees_ccw_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            controller.rotateLeft();
          },
        ),
        IconButton(
          icon: const Icon(Icons.rotate_90_degrees_cw_outlined,
              color: Colors.white),
          onPressed: () {
            controller.rotateRight();
          },
        ),
        TextButton(
          onPressed: () {
            doneCropping(controller, context);
          },
          child: const Text(
            'CROP',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );

Future<void> doneCropping(
    CropController controller, BuildContext context) async {
  final image = await controller.croppedImage();
  // ignore: use_build_context_synchronously
  await showDialog<bool>(
    context: context,
    builder: (context) {
      String shapeName = "assets/user_image_frame_1.png";
      return StatefulBuilder(builder: (context, setstate) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(6.0),
          titlePadding: const EdgeInsets.all(8.0),
          title: const Text('     Upload This image'),
          children: [
            Text(shapeName),
            WidgetMask(
                childSaveLayer: true,
                blendMode: BlendMode.srcATop,
                mask: image,
                child: shapeName == "orignal" ? image : Image.asset(shapeName)),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      setstate(() => shapeName = "orignal");
                    },
                    child: orignalbox()),
                GestureDetector(
                    onTap: () {
                      setstate(
                          () => shapeName = "assets/user_image_frame_1.png");
                    },
                    child:
                        shapebox("assets/user_image_frame_1.png", shapeName)),
                GestureDetector(
                    onTap: () {
                      setstate(
                          () => shapeName = "assets/user_image_frame_2.png");
                    },
                    child:
                        shapebox("assets/user_image_frame_2.png", shapeName)),
                GestureDetector(
                    onTap: () {
                      setstate(
                          () => shapeName = "assets/user_image_frame_3.png");
                    },
                    child:
                        shapebox("assets/user_image_frame_3.png", shapeName)),
                GestureDetector(
                    onTap: () {
                      setstate(
                          () => shapeName = "assets/user_image_frame_4.png");
                    },
                    child:
                        shapebox("assets/user_image_frame_4.png", shapeName)),
              ],
            ),
            customButton("Use this Image", () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => Homepage(maskURL: shapeName, image: image),
                ),
              );
            }, context)
          ],
        );
      });
    },
  );
}

Future<void> aspectRatios(
    CropController controller, BuildContext context) async {
  final value = await showDialog<double>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: const Text('Select aspect ratio'),
        children: [
          // special case: no aspect ratio
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, -1.0),
            child: const Text('free'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 1.0),
            child: const Text('square'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 2.0),
            child: const Text('2:1'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 1 / 2),
            child: const Text('1:2'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 4.0 / 3.0),
            child: const Text('4:3'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 16.0 / 9.0),
            child: const Text('16:9'),
          ),
        ],
      );
    },
  );
  if (value != null) {
    controller.aspectRatio = value == -1 ? null : value;
  }
}

Future<File> pickImage() async {
  File pickedImage = File("");

  final ImagePicker picker = ImagePicker();
  XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    var selected = File(image.path);
    pickedImage = selected;
    return selected;
  } else {
    if (kDebugMode) {
      print('No image has been picked');
    }
  }
  return pickedImage;
}
