import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  File? file;
  XFile? image;
  var isImageNotNull = false.obs;

  void pickImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    file = File(image!.path);
    if (file != null) {
      isImageNotNull.value = false;
      isImageNotNull.value = true;
    } else {
      isImageNotNull.value = false;
    }
  }
}
