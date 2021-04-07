import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class UploadService {
  static Future<String> uploadImageToFirebase(File file) async {
    String fileName = basename(file.path);
    Reference ref = FirebaseStorage.instance.ref().child('uploads/$fileName');
    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});
    Task uploadTask = ref.putFile(file, metadata);
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }
}
