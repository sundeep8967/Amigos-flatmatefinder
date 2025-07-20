import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload profile picture
  Future<String?> uploadProfilePicture(File imageFile, String userId) async {
    try {
      // Create a reference to the location you want to upload to in firebase
      final Reference ref = _storage
          .ref()
          .child('profile_pictures')
          .child('$userId.jpg');

      // Upload the file to firebase
      final UploadTask uploadTask = ref.putFile(imageFile);
      
      // Wait for the upload to complete
      final TaskSnapshot snapshot = await uploadTask;
      
      // Get the download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      // print('Error uploading profile picture: $e');
      return null;
    }
  }

  // Upload flat images
  Future<List<String>> uploadFlatImages(List<File> imageFiles, String flatId) async {
    List<String> downloadUrls = [];
    
    try {
      for (int i = 0; i < imageFiles.length; i++) {
        final Reference ref = _storage
            .ref()
            .child('flat_images')
            .child(flatId)
            .child('image_$i.jpg');

        final UploadTask uploadTask = ref.putFile(imageFiles[i]);
        final TaskSnapshot snapshot = await uploadTask;
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        
        downloadUrls.add(downloadUrl);
      }
      
      return downloadUrls;
    } catch (e) {
      // print('Error uploading flat images: $e');
      return downloadUrls; // Return whatever was uploaded successfully
    }
  }

  // Delete image
  Future<bool> deleteImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      return true;
    } catch (e) {
      // print('Error deleting image: $e');
      return false;
    }
  }
}