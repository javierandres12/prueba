import 'dart:io';

import 'package:basicos/Place/repository/firebase_storage_api.dart';
import 'package:basicos/User/ui/widgets/profile_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageRepository{

  //primero creamos la instancia
  final _firebaseStorageAPI = FirebaseStorageAPI();

  Future<StorageUploadTask> uploadFile(String path,File image)=>
      _firebaseStorageAPI.uploadFile(path, image);






}