import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthAPI {

  //instance representa toda la composicion o lo que existe en la consola de firbase
  //eso lo guardamos en una variable global
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // sehcae lo mismo con google pero nos va a traer lo que esta en signin
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signIn() async{

    GoogleSignInAccount googleSignInAccount =
        await googleSignIn.signIn();
    // esto abre la ventana para ingresar con la cuenta de google
    GoogleSignInAuthentication gSA =
    await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: gSA.idToken, accessToken: gSA.accessToken);

    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    return user ;

  }

  //metodo para cerrar la sesion de firebase y google
  signOut() async{
    await _auth.signOut();
    googleSignIn.signOut();
  }

}