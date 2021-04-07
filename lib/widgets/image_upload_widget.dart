import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ylc/widgets/camera_page.dart';

class ImageUpload extends StatefulWidget {
  final Size size;
  final ValueChanged<File> onChanged;

  const ImageUpload({
    Key key,
    this.size,
    this.onChanged,
  }) : super(key: key);
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File file;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: widget.size.width,
        height: widget.size.height,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            Center(
              child: file != null
                  ? Image.file(
                      file,
                      width: widget.size.width,
                    )
                  : IconButton(
                      icon: Icon(Icons.upload_file),
                      onPressed: () {
                        openCamera(context).then(
                          (value) {
                            if (value != null) {
                              setState(() {
                                file = value;
                                widget.onChanged?.call(file);
                              });
                            }
                          },
                        );
                      },
                    ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: file != null
                  ? IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          file = null;
                        });
                      },
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
