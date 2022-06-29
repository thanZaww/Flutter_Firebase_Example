import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> chooseImage() async {
  ImagePicker imagePicker = ImagePicker();
  // XFile? xFile1 = await imagePicker.pickImage(source: ImageSource.gallery);
  XFile? xFile2 = await imagePicker.pickImage(source: ImageSource.gallery);
  if (xFile2 != null) {
    return File(xFile2.path);
  }
  return null;
}

Future<String?> uploadImage(File image) async {
  try {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference ref =
        // ignore: prefer_interpolation_to_compose_strings
        firebaseStorage.ref('profileImage').child('${DateTime.now()}.jpg');
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  } catch (e) {
    return null;
  }
}
