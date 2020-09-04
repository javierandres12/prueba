import 'dart:io';

import 'package:basicos/Place/model/place.dart';
import 'package:basicos/Place/repository/firebase_storage_repository.dart';
import 'package:basicos/Place/ui/widgets/card_image.dart';
import 'package:basicos/User/model/user.dart';
import 'package:basicos/User/repository/auth_repository.dart';
import 'package:basicos/User/repository/cloud_firestore_api.dart';
import 'package:basicos/User/repository/cloud_firestore_repository.dart';
import 'package:basicos/User/ui/widgets/profile_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';


class UserBloc implements Bloc{
  // llamamos a la clase AuthRepository que tiene el metodo de signin con google para
  //implementarlo en el patron BLoC
  // ignore: non_constant_identifier_names
  final _auth_repository = AuthRepository();


  //Declaramos el stream el flujo de datos que proviene de firebase
  //Stream - Firebase

  //StreamController
  //se declara el tipo de Stream que se va a devolver firebase user en este caso
  //luego se coloca el nombre del objeto como streamFirebase
  //y en seguida colocamos FirebaseAuth que entrega el flujo de datos por medio del instance
  Stream<FirebaseUser> streamFirebase = FirebaseAuth.instance.onAuthStateChanged;

  // este objeto nos devuelve el estado de la sesion
  Stream<FirebaseUser> get authStatus => streamFirebase;

  //metodo para obtener el currentuser o uid identificador
  Future<FirebaseUser> get currentUser => FirebaseAuth.instance.currentUser();



  //Casos de uso de la aplicacion
  //1.signIn
  Future<FirebaseUser> signIn(){
    return _auth_repository.signInFirebase();
  }

  //2. Registrar usuario en base de datos
  final _cloudFirestoreRepository = CloudFirestoreRepository();
  void updateUserData(User user) => _cloudFirestoreRepository.updateUserDataRepository(user);
  Future<void> updatePlaceData(Place place) => _cloudFirestoreRepository.updatePlaceData(place);
  //se usa el widget streambuilder para modificar cada vez que se cambie un dato
  Stream<QuerySnapshot> placesListStream = Firestore.instance.collection(CloudFirestoreAPI().PLACES).snapshots();
  //otro stream que nos permita acceder a este
  Stream<QuerySnapshot> get placesStream => placesListStream; //placesStream es donde vamos a estar escuchando

  List<Place> buildPlaces(List<DocumentSnapshot> placesListSnapshot, User user) =>
      _cloudFirestoreRepository.buildPlaces(placesListSnapshot, user);

  //likes cambio
  Future likePlace(Place place, String uid) =>
      _cloudFirestoreRepository.likePlace(place,uid);



  //se realiza el siguiente filtro por edad
  Stream<QuerySnapshot> myPlacesListStream(String uid)=>
      Firestore.instance.collection(CloudFirestoreAPI().PLACES)//a continucion se hace el filtro
      .where("userOwner", isEqualTo: Firestore.instance.document("${CloudFirestoreAPI().USERS}/${uid}"))
      .snapshots();

  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) =>
      _cloudFirestoreRepository.buildMyPlaces(placesListSnapshot);








  //metodo de storage
  final _firebaseStorageRepository = FirebaseStorageRepository();
  Future<StorageUploadTask> upLoadFile(String path, File image ) =>
      _firebaseStorageRepository.uploadFile(path, image);

  //3.singOut firebase
  signOut(){
     _auth_repository.signOutFirebase();
  }

  @override
  void dispose() {


  }

}