import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

Future<List<List<List<List<double>>>>> processImage(XFile imageFile) async {
  
  // Read the image file
  Uint8List imageData = await imageFile.readAsBytes();

  // Decode the image
  img.Image image = img.decodeImage(imageData)!;

  // Resize the grayscale image to 64x64 using Lanczos3 interpolation
  img.Image resizedImage = img.copyResize(image, width: 224, height: 224, interpolation: img.Interpolation.cubic);

  // Convert pixel values to normalized form (0 to 1)
  List<List<List<List<double>>>> normalizedImage = [];
  List<List<List<double>>> imageList = [];
  for (int y = 0; y < resizedImage.height; y++) {
    List<List<double>> row = [];
    for (int x = 0; x < resizedImage.width; x++) {
      // Normalize the pixel values to range from 0 to 1
      int pixelValue = resizedImage.getPixel(x, y);
      int red = img.getRed(pixelValue);
      int green = img.getGreen(pixelValue);
      int blue = img.getBlue(pixelValue);
      
      double normalizedRed = red / 1.0; // Normalize the red component
      double normalizedGreen = green / 1.0; // Normalize the green component
      double normalizedBlue = blue / 1.0; // Normalize the blue component

      row.add([normalizedRed, normalizedGreen, normalizedBlue]); // Add all three color channels
    }
    imageList.add(row);
  }
  normalizedImage.add(imageList);

  return normalizedImage;
}

String classifyMax(List<double> list) {
  if (list.isEmpty) {
    throw ArgumentError('The list cannot be empty.');
  }

  // Find the index of the maximum value
  int maxValueIndex = 0;
  double maxValue = list[0];

  for (int i = 1; i < list.length; i++) {
    if (list[i] > maxValue) {
      maxValue = list[i];
      maxValueIndex = i;
    }
  }

  // Map the index to the corresponding letter of the alphabet
  return String.fromCharCode('A'.codeUnitAt(0) + maxValueIndex);
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Interpreter? _interpreter;
  XFile? image;
  String? prediction;

  @override
  initState(){
    super.initState();
    _loadModel();
  }
  
  @override
  void dispose(){
    super.dispose();
    _interpreter!.close();
  }

  Future<void> _loadModel() async {
    print('Loading interpreter options...');
    final interpreterOptions = InterpreterOptions();

    // Use XNNPACK Delegate
    if (Platform.isAndroid) {
      //interpreterOptions.addDelegate(XNNPackDelegate());
    }

    // Use Metal Delegate
    if (Platform.isIOS) {
      interpreterOptions.addDelegate(GpuDelegate());
    }

    print('Loading interpreter...');
    _interpreter = await Interpreter.fromAsset('static/etc/asl_model_v2.tflite', options: interpreterOptions);
    
    print(_interpreter!.getInputTensor(0).shape);
    print(_interpreter!.getOutputTensor(0).shape);
    print('----------------------------------------');
    print(_interpreter!.getInputTensor(0).type);
    print(_interpreter!.getOutputTensor(0).type);
  }

  final picker = ImagePicker(); // Create an instance of ImagePicker

  cropImage(XFile imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        maxWidth: 256,
        maxHeight: 256,
        sourcePath: imgFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Image Cropper",
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
          IOSUiSettings(
            title: "Image Cropper",
          )
        ]);
    if (croppedFile != null) {

      imageCache.clear();

      setState(() {
        image = XFile(croppedFile.path);
      });

      if (image != null) {
        List<List<List<List<double>>>> processedImage = await processImage(image!);
        // Do something with the processed image data
        var output = List.filled(1*25, 0).reshape([1,25]);

        print(processedImage[0]);
        print(processedImage.shape);
        print(output.shape);
        print(output);

        _interpreter!.run(processedImage, output);

        print(output);

        // Update the state with the XFile pointing to the temporary file
        setState(() {
          prediction = classifyMax(output[0]);
        });
      }
    }
  }

  Future getFromCamera() async {
    try {
      final pickedImage = await picker.pickImage(
        source: ImageSource.camera
      );
      if (pickedImage != null) {
        cropImage(XFile(pickedImage.path));
      }
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  Future getFromGallery() async {
    try {
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery
      );
      if (pickedImage != null) {
        cropImage(XFile(pickedImage.path));
      }
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                          child: Column(
                            children: const [
                              Icon(Icons.image, size: 60.0,  color: Colors.blueAccent,),
                              SizedBox(height: 12.0),
                              Text(
                                "Gallery",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.blue,),
                              )
                            ],
                          ),
                          onTap: () {
                            getFromGallery();
                            Navigator.pop(context);
                          },
                        )),
                    Expanded(
                        child: InkWell(
                          child: SizedBox(
                            child: Column(
                              children: const [
                                Icon(Icons.camera_alt, size: 60.0, color: Colors.blueAccent,),
                                SizedBox(height: 12.0),
                                Text(
                                  "Camera",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: Colors.blue),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            getFromCamera();
                            Navigator.pop(context);
                          },
                        ))
                  ],
                )),
          );
        }
    );
  }

  // set image to something 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column( // The Column widget starts here
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[ // Add the brackets to enclose the children of the Column
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromARGB(255, 220, 235, 255))
                  ),
                  child: SizedBox(
                    width: 200.0,
                    height: 200.0,
                    child: image != null 
                    ? Image(image: XFileImage(image!), height: 256, width: 256, fit: BoxFit.fill)
                    : Image.asset('static/images/default.png', height: 256, width: 256, fit: BoxFit.fill)
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  prediction != null 
                  ? 'Predicted Class: ${prediction}'
                  : 'Please Select an Image',
                  style: TextStyle(fontSize: 20.0), // Adjust the font size as needed
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (await Permission.camera.request().isGranted) {
                          showImagePicker(context);
                        } else {
                          print('Insufficient Permissions');
                        }
                      },
                      child: Text('Select Image'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
