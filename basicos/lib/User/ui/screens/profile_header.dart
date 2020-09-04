import 'package:basicos/User/bloc/bloc_user.dart';
import 'package:basicos/User/model/user.dart';
import 'package:basicos/User/ui/widgets/button_bar.dart';
import 'package:basicos/User/ui/widgets/user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';


class ProfileHeader extends StatelessWidget {
 // UserBloc userBloc;
  User user;
  ProfileHeader({@required this.user});

  @override
  Widget build (BuildContext context) {
    //instancia objeto userbloc
    //userBloc = BlocProvider.of<UserBloc>(context);
    /*return StreamBuilder(
      //stream: userBloc.streamFirebase,
      // ignore: missing_return
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
        }
      },

    );*/

    final title = Text(
      'Profile',
      style: TextStyle(
        fontFamily: "Lato",
        color: Colors.white,
        fontWeight:  FontWeight.bold,
        fontSize:  30.0
      ),
    );

    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 50
      ),
      child: Column(
        children: [
          Row(
            children: [
              title
            ],
          ),
          UserInfo(user),
          ButtonsBar()
        ],
      ),
    );
  }

  Widget showProfileData(AsyncSnapshot snapshot){
    if(!snapshot.hasData || snapshot.hasError){
      print("no logueado");
      return Container(
          margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 50.0
          ),
          child: Column(
            children: <Widget>[
              CircularProgressIndicator(),
              Text("No se pudo cargar la informacion")
            ],
          ));
    }else{
      print("logueado");
      print(snapshot.data);
      user = User(name: snapshot.data.displayName, email: snapshot.data.email, photoURL: snapshot.data.photoUrl);
      final title = Text(
        'Profile',
        style: TextStyle(
            fontFamily: 'Lato',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30.0
        ),
      );

      return Container(
        margin: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 50.0
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                title
              ],
            ),
            UserInfo(user),
            ButtonsBar()
          ],
        ),
      );
      }

    }
    
  }

