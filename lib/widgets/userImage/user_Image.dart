import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
  final void Function(File pickedImage) imagePicker;

  const UserImage({Key? key, required this.imagePicker}) : super(key: key);

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? pickedImage;
  final ImagePicker picker = ImagePicker();

  void pickImage(ImageSource src) async {
    final pickedImageFile = await picker.pickImage(
      source: src,
      imageQuality: 80,
      maxWidth: 200,
    );
    if (pickedImageFile != null) {
      setState(() {
        pickedImage = File(pickedImageFile.path);
      });
      widget.imagePicker(pickedImage!);
    } else {
      print('No Image Selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: pickedImage != null ? FileImage(pickedImage!) : null,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () => pickImage(ImageSource.camera),
              child: const Row(
                children: [
                  Icon(Icons.camera_alt_outlined),
                  Text(' Add image\n from camera'),
                ],
              ),
            ),
            TextButton(
              onPressed: () => pickImage(ImageSource.gallery),
              child: const Row(
                children: [
                  Icon(Icons.image_outlined),
                  Text(' Add image\n from gallery'),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}