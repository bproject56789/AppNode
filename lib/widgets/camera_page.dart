import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/navigaton_helper.dart';

Future<File> openCamera(BuildContext context) async {
  List<CameraDescription> cameras = await availableCameras();
  return navigateToPage<File>(context, CameraPage(cameras: cameras));
}

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPage({Key key, this.cameras}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<CameraPage> {
  CameraController controller;
  int _cameraIndex = 0;
  bool _cameraNotAvailable = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _initCamera(int index) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(widget.cameras[index], ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        _showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {
        _cameraIndex = index;
      });
    }
  }

  void _onSwitchCamera() {
    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture) {
      return;
    }
    final newIndex =
        _cameraIndex + 1 == widget.cameras.length ? 0 : _cameraIndex + 1;
    _initCamera(newIndex);
  }

  void _onTakePictureButtonPress() {
    _takePicture().then((filePath) {
      Navigator.of(context).pop(
        File(filePath),
      );
    });
  }

  Future<void> _onGalleryButtonPress() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    Navigator.of(context).pop(File(pickedFile.path));
  }

  Future<String> _takePicture() async {
    if (!controller.value.isInitialized || controller.value.isTakingPicture) {
      return null;
    }

    try {
      var file = await controller.takePicture();
      return file.path;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    _showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  Widget _buildControlBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.insert_photo),
          onPressed: _onGalleryButtonPress,
        ),
        GestureDetector(
          onTap: _onTakePictureButtonPress,
          child: Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 5.0,
              ),
            ),
          ),
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.switch_camera),
          onPressed: _onSwitchCamera,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.cameras == null || widget.cameras.isEmpty) {
      setState(() {
        _cameraNotAvailable = true;
      });
    }
    _initCamera(_cameraIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraNotAvailable) {
      return Center(
        child: Text('Camera not available /_\\'),
      );
    }

    final stack = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          color: Colors.black,
          child: Center(
            child: controller.value.isInitialized
                ? CameraPreview(controller)
                : Text('Loading camera...'),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildControlBar(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                Strings.tapForPhoto,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.white),
              ),
            )
          ],
        )
      ],
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: stack,
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (controller != null) {
      controller.dispose();
    }
  }
}
