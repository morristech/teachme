import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:teachme/services/firestore_path.dart';

class FirebaseStorageService {
  /// Upload an avatar from file
  Future<String> uploadPicture(
          {@required String id,
          @required File file,
          @required String fileName,
          @required String type}) async =>
      await upload(
        file: file,
        path: FirestorePath.getPath(type, id) + '/' + fileName,
        contentType: 'image/png',
      );

  /// Generic file upload for any [path] and [contentType]
  Future<String> upload({
    @required File file,
    @required String path,
    @required String contentType,
  }) async {
    print('uploading to: $path');
    final storageReference = FirebaseStorage.instance.ref().child(path);
    final uploadTask = storageReference.putFile(
        file, StorageMetadata(contentType: contentType));
    final snapshot = await uploadTask.onComplete;
    if (snapshot.error != null) {
      print('upload error code: ${snapshot.error}');
      throw snapshot.error;
    }
    // Url used to download file/image
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('downloadUrl: $downloadUrl');
    return downloadUrl;
  }
}
