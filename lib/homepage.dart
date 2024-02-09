import 'package:celebrare/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widget_mask/widget_mask.dart';
import 'cropper.dart';

class Homepage extends StatelessWidget {
  final Image? image;
  final String? maskURL;

  const Homepage({super.key, this.image, this.maskURL});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: const Icon(
              Icons.chevron_left,
            )),
        elevation: 2,
        centerTitle: true,
        title: const Text(
          "Add Image/Icon",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: decoration(),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                const Text(
                  "Upload Image",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                customButton("Choose From Device", () {
                  pickImage().then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CropPage(image: value),
                      ),
                    );
                  });
                }, context),
              ],
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          image == null
              ? Container()
              : WidgetMask(
                  childSaveLayer: true,
                  blendMode: BlendMode.srcATop,
                  mask: image!,
                  child:
                      maskURL! == "orignal" ? image! : Image.asset(maskURL!)),
        ]),
      ),
    );
  }
}
