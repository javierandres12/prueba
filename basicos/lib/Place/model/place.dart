import 'package:basicos/User/model/user.dart';
import 'package:flutter/cupertino.dart';

class Place {

  String id;
  String name;
  String description;
  String urlImage;
  int likes;
  bool liked;
  //User userOwner;


  Place({
    Key key,
    this.id,
    @required this.name,
    @required this.description,
    @required this.urlImage,
    this.liked,
    this.likes,
    //this.userOwner

});
}