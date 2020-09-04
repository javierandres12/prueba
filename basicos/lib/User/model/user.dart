
import 'package:basicos/Place/model/place.dart';
import 'package:flutter/material.dart';

class User{
  final String uid;
  final String name;
  final String email;
  final String photoURL;
  final List<Place> myPlaces;
  final List<Place> myFavoritePlaces;


// constructor con llave
  User ({
    Key key,
    @required this.uid,
    @required this.name,
    @required this.email,
    @required this.photoURL,
    @required this.myPlaces,
    @required this.myFavoritePlaces
  });



}