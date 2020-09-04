import 'package:basicos/User/repository/firebase_auth_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository{

  final _firebaseAuthAPI = FirebaseAuthAPI();// guardamos la claseque permite entrar con google
  Future<FirebaseUser> signInFirebase() => _firebaseAuthAPI.signIn();// llamamos al metodo signIn qu esta en la clase que creamos con firebase
   signOutFirebase() =>_firebaseAuthAPI.signOut();
}