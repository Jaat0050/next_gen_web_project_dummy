import 'package:bkb/data/repos/api_repo.dart';
import 'package:bkb/views/auth/waitingScreen.dart';
import 'package:bkb/views/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:camera/camera.dart';
import '../../shared_pref_helper.dart';
import '../../utils/color_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:html' as html;

class FaceId extends StatefulWidget {
  const FaceId({super.key});

  @override
  State<FaceId> createState() => _FaceIdState();
}

class _FaceIdState extends State<FaceId> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String? _capturedImagePath;
  bool loader = true;

  ApiRepo apiRepo = ApiRepo();

  String name = SharedPreferencesHelper.getUserName();
  String user_id = 'bkb_'+ SharedPreferencesHelper.getUserId();
  //String user_id = "1";
  //String name = "Pooja";


  @override
  void initState() {
    super.initState();
    getCameras();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getCameras() async {
    final cameras = await availableCameras();
    _controller =
        CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
    _initializeControllerFuture = _controller.initialize();

    setState(() {
      loader = false;
    });
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      setState(() {
        _capturedImagePath = image.path;
      });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> _retakePicture() async {
    // Dispose of the existing controller
    _controller.dispose();

    final cameras = await availableCameras();
    // Create a new controller for the live preview
    _controller =
        CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);

    // Initialize the new controller
    _initializeControllerFuture = _controller.initialize();

    setState(() {
      _capturedImagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorTheme.purpleBg,
      body: loader
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Center(
                        child: _capturedImagePath != null
                            ? kIsWeb
                                ? ClipOval(
                                    child: Image.network(
                                      _capturedImagePath!,
                                      width: 300,
                                      height: 300,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.file(
                                      File(_capturedImagePath!),
                                      width: 300,
                                      height: 300,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                            : Container(
                                height: 300,
                                width: 300,
                                child: ClipOval(
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: CameraPreview(_controller),
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 80),
                      Center(
                        child: SizedBox(
                          width: size.width * 0.3,
                          child: ElevatedButton(
                            onPressed: _capturedImagePath != null
                                ? _retakePicture
                                : _takePicture,
                            child: Text(_capturedImagePath != null
                                ? "Retake Image"
                                : "Capture Image"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: ColorTheme.purpleBg,
                              backgroundColor: ColorTheme.lightPurple,
                              padding: EdgeInsets.all(16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              textStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _capturedImagePath != null
                          ? Center(
                              child: SizedBox(
                                width: size.width * 0.3,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // Navigator.pushNamed(
                                    //     context, MyRoutes.accountStatus);
                                    try {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      );
                                      print("Name: $name");
                                      print((_capturedImagePath!));
                                      var imageElement = html.ImageElement(src: _capturedImagePath!);

                                      await imageElement.onLoad.first;

                                      var canvas = html.CanvasElement(width: imageElement.width!, height: imageElement.height!);
                                      var contextnew = canvas.context2D;
                                      contextnew.drawImage(imageElement, 0, 0);

                                      var blob = await canvas.toBlob('image/jpeg', 1.0);

                                      var capturedImageFile = html.File([blob!], 'capturedImage.jpg', {'type': 'image/jpeg'});


                                      print("Name: $name");
                                      print("User id: $user_id");
                                      print("Captured image: $capturedImageFile");

                                      var result = await apiRepo.faceAuth(
                                        name,
                                        user_id,
                                        capturedImageFile
                                      );
                                      Navigator.pop(context);

                                      print("--------------------*********************Result********************---------------------");
                                      print(result);
                                      if (result != null && result['status'] == "detected") {
                                        String originalUserId = result['user_id'];
                                        print("Originial user id: ");
                                        print(originalUserId);
                                        String user_id = originalUserId.substring('bkb_'.length);
                                        WaitingScreen(userId: user_id,);
                                      }
                                    } catch (e) {
                                      print(e);
                                      Fluttertoast.showToast(
                                        msg: "Failed to register user's face",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: ColorTheme.purpleBg,
                                    backgroundColor: ColorTheme.lightPurple,
                                    padding: EdgeInsets.all(16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    textStyle: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: const Text("Continue"),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error initializing camera: ${snapshot.error}'),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }
}
