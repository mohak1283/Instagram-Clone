import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/ui/insta_upload_photo_screen.dart';

class InstaAddScreen extends StatefulWidget {
  @override
  _InstaAddScreenState createState() => _InstaAddScreenState();
}

class _InstaAddScreenState extends State<InstaAddScreen> {
  File imageFile;

  Future<File> _pickImage(String action) async {
    File selectedImage;

    action == 'Gallery'
        ? selectedImage =
            await ImagePicker.pickImage(source: ImageSource.gallery)
        : await ImagePicker.pickImage(source: ImageSource.camera);

    return selectedImage;
  }

  _showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    Navigator.push(context, MaterialPageRoute(
                      builder: ((context) => InstaUploadPhotoScreen(imageFile: imageFile,))
                    ));
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  _pickImage('Camera').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    Navigator.push(context, MaterialPageRoute(
                      builder: ((context) => InstaUploadPhotoScreen(imageFile: imageFile,))
                    ));
                  }); 
                },
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Add Photo'),
      ),
      body: Center(
          child: RaisedButton.icon(
        splashColor: Colors.yellow,
        shape: StadiumBorder(),
        color: Colors.black,
        label: Text(
          'Upload Image',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.cloud_upload,
          color: Colors.white,
        ),
        onPressed: _showImageDialog,
      )),
    );
  }
}
