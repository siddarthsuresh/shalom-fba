import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future signInWithEmail(String email, String password) async {
      try{
        UserCredential authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        print('Email');
        print(authResult.user.email);
        return authResult.user.uid;
      }
      on FirebaseAuthException catch (e){
        return null;
      }
  }

  Future signUpWithEmail(String email, String password) async {
    try{
      return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch (e){
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}