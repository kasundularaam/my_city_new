import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageCard extends StatefulWidget {
  final Function(File) getImageFile;
  const SelectImageCard({
    Key key,
    @required this.getImageFile,
  }) : super(key: key);
  @override
  _SelectImageCardState createState() => _SelectImageCardState();
}

class _SelectImageCardState extends State<SelectImageCard> {
  File _image;

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile =
          await picker.getImage(source: ImageSource.gallery, maxWidth: 480.0);
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile =
          await picker.getImage(source: ImageSource.camera, maxWidth: 480.0);
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.getImageFile(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                "Image",
                style: TextStyle(color: Colors.black, fontSize: 25.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                color: Colors.purple,
              ),
              SizedBox(
                height: 10.0,
              ),
              _image != null
                  ? Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            _image,
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(
                          color: Colors.purple,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _image = null;
                              widget.getImageFile(null);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "Remove this image",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                              fillColor: Colors.deepPurple,
                              child: Icon(
                                Icons.add_photo_alternate_rounded,
                                color: Colors.white,
                              ),
                              elevation: 8,
                              onPressed: () {
                                getImage(true);
                              },
                              padding: EdgeInsets.all(20),
                              shape: CircleBorder(),
                            ),
                            SizedBox(width: 10.0),
                            RawMaterialButton(
                              fillColor: Colors.deepPurple,
                              child: Icon(
                                Icons.add_a_photo_rounded,
                                color: Colors.white,
                              ),
                              elevation: 8,
                              onPressed: () {
                                getImage(false);
                              },
                              padding: EdgeInsets.all(20),
                              shape: CircleBorder(),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
