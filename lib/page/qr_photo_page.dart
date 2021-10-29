import 'dart:convert';
import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

class QRPhotoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRPhotoPageState();
}

class _QRPhotoPageState extends State<QRPhotoPage> {
  String qrCode = '';
  String ipAddress = '';
  String port = '';
  List<XFile>? _imageFileList;
double maxWidth=500;
double maxHeight=800;
int imageQuality=100;

  @override
  void initState() {
    super.initState();
    _loadSetting();
  }
  //Loading thamso on start
  void _loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ipAddress = (prefs.getString('IpAddress') ?? "192.168.1.13");
      port = (prefs.getString('Port') ?? "8080");
      maxWidth = (prefs.getDouble('MaxWidth') ?? 500);
      maxHeight = (prefs.getDouble('MaxHeight') ?? 800);
      imageQuality = (prefs.getInt('ImageQuality') ?? 100);
    });
  }

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  dynamic _pickImageError;
  String? _retrieveDataError;
  final ImagePicker _picker = ImagePicker();

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (!isMultiImage) {
      try {
        final pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
        );
        setState(() {
          _imageFile = pickedFile;
        });

        setState(() async {
          Socket socket = await Socket.connect(ipAddress, 8080);
          //// listen to the received data event stream
          // socket.listen((List<int> event) {
          //   //print(utf8.decode(event));
          // });

          final bytes = File(pickedFile!.path).readAsBytesSync();

          socket.add(bytes);
          // wait 5 seconds
          //await Future.delayed(Duration(seconds: 5));
          socket.close();
        });

      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }


  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return Semantics(
        child: ListView.builder(
          key: UniqueKey(),
          itemBuilder: (context, index) {
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ? Image.network(_imageFileList![index].path)
                  : Image.file(File(_imageFileList![index].path)),
            );
          },
          itemCount: _imageFileList!.length,
        ),
        label: 'image_picker_example_picked_images',
      );


    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'Chưa có ảnh nào được chụp hoặc chọn trong gallery.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type != RetrieveType.video)
      {
        setState(() {
          _imageFile = response.file;
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
          future: retrieveLostData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Text(
                  'You have not yet picked an image.',
                  textAlign: TextAlign.center,
                );
              case ConnectionState.done:
                return _handlePreview();
              default:
                if (snapshot.hasError) {
                  return Text(
                    'Pick image/video error: ${snapshot.error}}',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const Text(
                    'You have not yet picked an image.',
                    textAlign: TextAlign.center,
                  );
                }
            }
          },
        )
            : _handlePreview(),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.photo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.camera, context: context);
              },
              heroTag: 'image2',
              tooltip: 'Chụp CCCD',
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}