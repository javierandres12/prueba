// ignore: avoid_web_libraries_in_flutter


import 'dart:io';
import 'package:basicos/Place/ui/screens/add_place_screen.dart';
import 'package:basicos/User/bloc/bloc_user.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'circle_button.dart';
import '';

// ignore: must_be_immutable
class ButtonsBar extends StatelessWidget {
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.0,
            vertical: 10.0
        ),
        child: Row(
          children: <Widget>[
            //cambiar la contraseña
            CircleButton(true, Icons.vpn_key, 20.0, Color.fromRGBO(255, 255, 255, 0.6),
                    ()=>{}),
            CircleButton(false, Icons.add, 40.0, Color.fromRGBO(255, 255, 255, 1),
                    (){//metodo para entrar a otra pagina


              //metodo para usar el hardware del dispositivo
              ImagePicker.pickImage(source: ImageSource.camera)
              .then((File image){
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context)
                    => AddPlaceScreen(image: image, )));

              } ).catchError((onError)=>print(onError));
              
              


                    }),
            CircleButton(true, Icons.exit_to_app, 20.0, Color.fromRGBO(255, 255, 255, 0.6),
                    ()=>{
              userBloc.signOut()
                    }),
            //cerrar
          ],
        )
    );
  }

}