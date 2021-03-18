import 'package:cats_or_dogs/constants.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isloading = false;
  File _image;
  List _outputs;

  @override
  void initState() {
    super.initState();
    _isloading = true;
    loadModel().then((value) {
      setState(() {
        _isloading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    /* double h=MediaQuery.of(context).size.height; */
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Know Your Food"),
        ),
      ),
      body: _isloading
          ? Container(
              alignment: Alignment.center,
              child: SpinKitFadingCircle(color: Colors.white, size: 50),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40.0),
                  _image == null
                      ? Container(
                          height: 300,
                          width: double.infinity,
                          child: Center(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Select Image",
                                style: TextStyle(fontSize: 30),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Icon(
                                Icons.image,
                              )
                            ],
                          )),
                        )
                      : Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          height: 300,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_image, fit: BoxFit.cover),
                          ),
                        ),
                  SizedBox(height: 20),
                  _outputs != null
                      ? Text(
                          "${_outputs[0]["label"]} ",
                          style: TextStyle(fontSize: 30),
                        )
                      : Container(),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: chooseImage,
                        child: Container(
                            width: 170,
                            height: 50.0,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 17,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Pick an image",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  width: 3.0,
                                ),
                                Icon(
                                  Icons.image_search,
                                  color: Colors.white,
                                )
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: pickCameraImage,
                        child: Container(
                            width: 170,
                            height: 50,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 17,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Take a photo",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                )
                              ],
                            )),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.fromLTRB(40, 0.0, 40, 0.0),
                    height: 40.0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/explore');
                        },
                        child: Center(
                          child: Text(
                            'View recipes',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  chooseImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img == null) {
      return null;
    }
    _isloading = true;
    _image = img;
    detectImage(_image);
  }

  pickCameraImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img == null) {
      return null;
    }
    _isloading = true;
    _image = img;
    detectImage(_image);
  }

  detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 7,
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.5,
    );
    setState(() {
      _isloading = false;
      _outputs = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }
}
