import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FbStorageController {
  final Reference _fireStorageRef = FirebaseStorage.instance.ref();

  final imageName = '${DateTime.now().millisecondsSinceEpoch}.png';

  Future<String> uploadImage(XFile image) async {
    final uploadTask =
        _fireStorageRef.child('images/$imageName').putFile(File(image.path));
    final taskSnapshot = await uploadTask.whenComplete(() => true);
    String _fileURL = await taskSnapshot.ref.getDownloadURL();
    return _fileURL;
  }
}
