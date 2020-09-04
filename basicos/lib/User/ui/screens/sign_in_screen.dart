import 'package:basicos/User/bloc/bloc_user.dart';
import 'package:basicos/User/model/user.dart';
import 'package:basicos/platzi_trips_cupertino.dart';
import 'package:basicos/widgets/button_green.dart';
import 'package:basicos/widgets/gradient_back.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';


class SignInScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignInScreen();
  }
}

class _SignInScreen extends State<SignInScreen>{
  //llamamos a UserBloc y usamos una variable userbloc para el boton creado

  UserBloc userBloc;
  double screenWidht;

  @override
  Widget build(BuildContext context) {
    // lo siguiente permite llamar los metodos creados en el patron bloc

    screenWidht = MediaQuery.of(context).size.width;


    userBloc = BlocProvider.of(context);
    return _handleCurrentSession();


  }

  // ignore: missing_return
  Widget _handleCurrentSession(){
    return StreamBuilder(
        stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot){
          if( !snapshot.hasData || snapshot.hasError){
            return signInGoogleUI();
          }else{
            return PlatziTripsCupertino();
          }
      },
    );

  }

  Widget signInGoogleUI() {
    return Scaffold(

      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GradientBack(height: null,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(20),
                  width: screenWidht,
                  child: Text('Bienvenido \n a tu app de viajes',
                    style: TextStyle(
                        fontSize: 37.0,
                        fontFamily: "Lato",
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              ButtonGreen(text: "Login with Gmail",
                  onPressed: (){
                userBloc.signIn().then((FirebaseUser user) {
                  userBloc.updateUserData(User(
                      uid: user.uid,
                      name: user.displayName,
                      email: user.email,
                      photoURL: user.photoUrl,
                      myPlaces: null,
                      myFavoritePlaces: null));
                });
                  },
                width: 300.0,
                heigth: 50.0,
              )
            ],
          ),
        ],


      ),
    );
  }
}