
import 'package:basicos/User/bloc/bloc_user.dart';
import 'package:basicos/User/model/user.dart';
import 'package:basicos/User/ui/screens/profile_header.dart';
import 'package:basicos/User/ui/widgets/profile_background.dart';
import 'package:basicos/User/ui/widgets/profile_places_list.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';



class ProfileTrips extends StatelessWidget {
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc =BlocProvider.of<UserBloc>(context);
    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          case ConnectionState.none:
            return CircularProgressIndicator();
          case ConnectionState.active:
            return showProfileData(snapshot);
          case ConnectionState.done:
            return showProfileData(snapshot);

          default:
            return showProfileData(snapshot);



        }


      },

    );




      /**/
  }
  
  Widget showProfileData(AsyncSnapshot snapshot){
    if(!snapshot.hasData || snapshot.hasError){
      print("No logueado");
      return Stack(
        children: <Widget>[
          ProfileBackground(),
          ListView(
            children: <Widget>[
              Text("usuario no logueado")
            ],
          ),
        ],
      );
    }else{
      print("logueado");
      var user = User(
          uid: snapshot.data.uid,
          name: snapshot.data.displayName,
          email: snapshot.data.email,
          photoURL: snapshot.data.photoUrl,
      );
      return Stack(
        children: <Widget>[
          ProfileBackground(),
          ListView(
            children: <Widget>[
              ProfileHeader(user: user ),//usuario datos
              ProfilePlacesList(user: user)//ususario uid

            ],
          ),
        ],
      );
    }
    
  }

}