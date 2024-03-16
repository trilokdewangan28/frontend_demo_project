
import 'dart:convert';
import 'dart:io';
import 'package:demo_project/config/StaticMethod.dart';
import 'package:demo_project/config/apis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';



class ImagePickerPage extends StatefulWidget {
  final Map<String,dynamic> userDetails;
  String imageFile;
  final String forWhich;
  String token;


  ImagePickerPage({Key? key, required this.userDetails, required this.forWhich, required this.imageFile,required this.token}) : super(key: key);

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  bool _mounted = false;
  File? _imageFile;
  //------------------------------------------------------PICK IMAGE FROM GALARY
  Future _pickImageFromGallery() async {
    //print('pick image from galary method called');
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if(_mounted){
      setState(() {
        if (pickedImage != null) {
          _imageFile = File(pickedImage.path);
        } else {
          //print('No image selected.');
        }
      });
    }
  }

//-----------------------------------------------------CAPTURE IMAGE FROM CAMERA
  Future _captureImageFromCamera() async {
    //print('capture image from camera method called');
    final picker = ImagePicker();
    final capturedImage = await picker.pickImage(source: ImageSource.camera);

    if(_mounted){
      setState(() {
        if (capturedImage != null) {
        _imageFile = File(capturedImage.path);
        } else {
          //print('No image captured.');
        }
      });
    }
  }

//------------------------------------------------------------UPLOAD PROFILE PIC
  Future<Map<String, dynamic>> uploadImage(data, Uri url) async {
    var request = http.MultipartRequest(
      'POST',
      url,
    );
    // Add token to the headers
    request.headers['Authorization'] = 'Bearer ${widget.token}';
    request.fields['uid'] = data['uid'].toString();
    var mimeType = lookupMimeType(data['imageFile'].path);
    var fileExtension = mimeType!.split('/').last;

    var pic = await http.MultipartFile.fromPath(
      'image',
      data['imageFile'].path,
      contentType: MediaType('image', fileExtension),
    );
    request.files.add(pic);
    try {
      var res = await request.send();
      if (res.statusCode == 200) {
        //print('image uploaded successful inside the upload function');
        return jsonDecode(await res.stream.bytesToString());
      } else {
        return jsonDecode(await res.stream.bytesToString());
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred while image uploading',
        'error': '$e',
      };
    }
  }

  //----------------------------------------------------------------BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
        },
        child: Scaffold(
          appBar: _appBar('Image Picker'),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20,),
                  widget.imageFile != null
                      ? Image.file(
                    _imageFile!,
                    height: 200,
                  )
                      : Container(
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Icon(Icons.image_not_supported_outlined,size: 50,),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  //--------------------------------------------FROM GALARY BUTTON
                  // ===========================buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          //--------------------------------------------FROM GALARY BUTTON
                          IconButton(onPressed: ()async{
                            _mounted=true;
                            await _pickImageFromGallery();
                          },
                              icon: Icon(Icons.photo, color: Colors.blue, size: 50,)
                          ),
                          const Text('Galary')
                        ],
                      ),
                      const SizedBox(width: 100),
                      Column(
                        children: [
                          //--------------------------------------------FROM CAMERA BUTTON
                          IconButton(onPressed: ()async{
                            _mounted=true;
                            await _captureImageFromCamera();
                          },
                              icon: Icon(Icons.camera_alt, color:Colors.blue, size: 50,)
                          ),
                          const Text('Camera')
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          //-------------------------------------------------FLOATING ACTION BTN
          floatingActionButton: widget.imageFile != null
              ? FloatingActionButton(
            onPressed: () async {
              //print('floating button acion called');
              var url=Uri.parse(uploadProfilePic);
              var data =  {
                "uid":widget.userDetails['uid'],
                "image":_imageFile
              };
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
              final response = await uploadImage(data, url);
              //print('inside the floating action');
              //print(response);
              if(response.isNotEmpty){
                Navigator.pop(context);
              }
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.check),
          )
              : null,
        ));
  }
  _appBar(appBarContent){
    return AppBar(
      title:Text(
        appBarContent,),
    );
  }
}
