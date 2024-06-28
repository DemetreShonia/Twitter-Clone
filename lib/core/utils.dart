import 'package:appwrite/models.dart';
import "dart:io" as io;

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

String getNameFromEmail(String email) {
  return email.split('@')[0];
}

Future<List<io.File>> pickImages() async {
  List<io.File> images = [];
  final imagePicker = ImagePicker();
  final imageFiles = await imagePicker.pickMultiImage();

  if (imageFiles != null && imageFiles.isNotEmpty) {
    for (final image in imageFiles) {
      images.add(io.File(image.path));
    }
  }

  return images;
}

Future<io.File?> pickImage() async {
  final imagePicker = ImagePicker();
  final imageFile =
      await imagePicker.pickImage(source: ImageSource.gallery); // or camera ;)

  if (imageFile != null) {
    return io.File(imageFile.path);
  }
  return null;
}
