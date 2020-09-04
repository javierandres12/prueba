import 'package:basicos/Place/model/place.dart';
import 'package:basicos/Place/ui/widgets/card_image.dart';
import 'package:basicos/User/model/user.dart';
import 'package:basicos/User/ui/widgets/profile_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CloudFirestoreAPI{
  // nombres de mis colleciones de las bases de datos
  // parte mas alta e la database real time
  final String USERS = "users";
  final String PLACES = "places";

  // creamos un objeto tipo Firestore llamado _db y luego instaciamos
  //y optenemos la entidad base de datos y la dejara disponible para insertar los datos en ese lugar
 final Firestore _db = Firestore.instance;
 final FirebaseAuth _auth =FirebaseAuth.instance;

 //creamos el primer metodo recibiendo un objeto de tipo User con nombre user
  //actualizara cada vez que se logee el ususario

  void updateUserData(User user) async{
    //insertar la collection de USERS a la _db, colocando los doscumentos
    //opteniendolos por medio de user en el identicador uid
    DocumentReference ref =_db.collection(USERS).document(user.uid);
    return await ref.setData({
      'uid': user.uid,
      'name': user.name,
      'photoURL': user.photoURL,
      'myPlaces': user.myPlaces,
      'myFavoritePlaces': user.myFavoritePlaces,
      'lastSignIn': DateTime.now()// parametro adicional para saber la ultima fecha de logeo

    }, merge: true); // hacemos un comit a la base de datos

 }

 //metodo para subir informacion de un lugar
  //en este caso se usa solo la collection y se deja a firebase que eliga el identificador
  //usando un await para un usuario registrado
 Future<void> updatePlaceData(Place place) async{
    CollectionReference refPlaces = _db.collection(PLACES);

    await _auth.currentUser().then((FirebaseUser user){
      refPlaces.add({
        'name': place.name,
        'description': place.description,
        'likes': place.likes,
        'urlImage': place.urlImage,
        'userOwner': _db.document("$USERS/${user.uid}"),//tipo de dato referencia
      }).then((DocumentReference dr) {
        dr.get().then((DocumentSnapshot snapshot){
          //ID del place que se acaba de asignar
          DocumentReference refUsers = _db.collection(USERS).document(user.uid);
          refUsers.updateData({
          'myPlaces': FieldValue.arrayUnion([_db.document("${PLACES}/${snapshot.documentID}")])
            
          });
          
        });
      });
    });

 }

 //metodo para procesar los datos
List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot){
    List<ProfilePlace> profilePlaces = List<ProfilePlace>();//declarar lista que se va a devolver
  //vamos a iterar estalista de documentos
  placesListSnapshot.forEach((p) {
    profilePlaces.add(ProfilePlace(
      Place(name: p.data['name'],
          description: p.data['description'],
          urlImage: p.data['urlImage'],
          likes: p.data['likes'],

      )

    ));
  });

    return profilePlaces;

}


//contruir lugares en la pantalla principal

  List<Place> buildPlaces(List<DocumentSnapshot> placesListSnapshot, User user) {
    List<Place> places = List<Place>();

    placesListSnapshot.forEach((p)  {
      Place place = Place(id: p.documentID, name: p.data["name"], description: p.data["description"],
          urlImage: p.data["urlImage"],likes: p.data["likes"]
      );
      List usersLikedRefs =  p.data["usersLiked"];
      place.liked = false;
      usersLikedRefs?.forEach((drUL){
        if(user.uid == drUL.documentID){
          place.liked = true;
        }
      });
      places.add(place);
    });
    return places;
  }

  Future likePlace(Place place, String uid) async {
    await _db.collection(PLACES).document(place.id).get()
        .then((DocumentSnapshot ds){
      int likes = ds.data["likes"];

      _db.collection(PLACES).document(place.id)
          .updateData({
        'likes': place.liked?likes+1:likes-1,
        'usersLiked':
        place.liked?
        FieldValue.arrayUnion([_db.document("${USERS}/${uid}")]):
        FieldValue.arrayRemove([_db.document("${USERS}/${uid}")])
      });


    });
  }


}