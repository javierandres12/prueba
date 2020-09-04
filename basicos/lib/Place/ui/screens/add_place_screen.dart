// ignore: avoid_web_libraries_in_flutter
import 'dart:io';
import 'package:basicos/Place/model/place.dart';
import 'package:basicos/Place/ui/widgets/card_image.dart';
import 'package:basicos/Place/ui/widgets/title_input_location.dart';
import 'package:basicos/User/bloc/bloc_user.dart';
import 'package:basicos/widgets/button_purple.dart';
import 'package:basicos/widgets/gradient_back.dart';
import 'package:basicos/widgets/text_input.dart';
import 'package:basicos/widgets/title_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

// ignore: must_be_immutable
class AddPlaceScreen extends StatefulWidget{

  //crear un objeto de tipo archivo
  File image;
  AddPlaceScreen({Key key, this.image});

  @override
  State<StatefulWidget> createState() {
    return _AddPlaceScreen();
  }
}

class _AddPlaceScreen extends State<AddPlaceScreen>{

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc =BlocProvider.of<UserBloc>(context);
    final _controllerTitlePlace = TextEditingController();
    final _controllerDescriptionPlace = TextEditingController();
    final _controllerLocation=TextEditingController();

    double screenWidht = MediaQuery.of(context).size.width;

    return  Scaffold(


      body: Stack(
        children: <Widget>[
          GradientBack(height: 300.0,),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 25.0, left: 5.0),
                child: SizedBox(
                  height: 45.0,
                  width: 45.0,
                  child: IconButton(
                      icon: Icon(Icons.keyboard_arrow_left,color: Colors.white ,size: 45,),
                      onPressed: (){
                        Navigator.pop(context);
                      }
                  ),
                  
                ),
              ),
              Flexible(
                  child: Container(
                    width: screenWidht,
                    padding: EdgeInsets.only(top: 45.0,left: 20,right: 10),
                    child: TitleHeader(title: "Add a new place"),
                  ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 120.0,bottom: 20.0),
            child: ListView(
              children: <Widget>[
                Container(alignment: Alignment.center,
                  child: CardImageWithFabIcon(
                      pathImage: widget.image.path,
                      width:350.0,
                      height: 250.0,
                      left: 10,
                      iconData: Icons.camera_alt,
                      onPressedFabIcon: null
                  ),
                ),
                Container(//textfield
                  margin: EdgeInsets.only(bottom: 20.0,
                  top: 20),
                  child: TextInput(
                      hintText: "title",
                      inputType: null,
                      maxLines: 1,
                      controller:  _controllerTitlePlace,
                  ),
                ),
                TextInput(
                  hintText: "Description",
                  inputType: TextInputType.multiline,
                  maxLines: 5,
                  controller: _controllerDescriptionPlace,

                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextInputLocation(hintText: "Add location", controller: _controllerLocation, iconData: Icons.location_on),


                ),
                Container(
                  child: ButtonPurple(
                      buttonText: "App Place",
                      onPressed: (){//1. subir imagen al firebase storage
                        //firebase stroage devuelve una url y
                        //url
                        //ID de usuario que esta logueado
                        userBloc.currentUser.then((FirebaseUser user) {
                          if(user!=null){//subir archivo
                            String uid = user.uid;
                            String path = "${uid}/${DateTime.now().toString()}.jpg";
                            userBloc.upLoadFile(path, widget.image)
                            .then((StorageUploadTask storageUploadTask ) {
                              //aca recuperamos la url de la imagen
                              storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot){
                                snapshot.ref.getDownloadURL().then((urlImage) {
                                  print("URLIMAGE: ${urlImage}");

                                  //2.subiremos esa informacion en cloud firestore
                                  userBloc.updatePlaceData(Place(
                                      name: _controllerTitlePlace.text,
                                      description: _controllerDescriptionPlace.text,
                                      likes: 0,
                                      urlImage: urlImage


                                  )).whenComplete(() {
                                    print("Termino");
                                    Navigator.pop(context);
                                  });
                                });
                              });
                            });
                          }
                        });






                      }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );


  }
}
