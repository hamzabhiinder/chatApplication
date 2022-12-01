import 'package:chatapplication/Helper/SharedPrefrenceHelper.dart';
import 'package:chatapplication/services/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login

  Future loginUserWithEmailandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //register

  Future registerUserWithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
        await DatabaseServices(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //Sign out

  Future signOut() async {
    try {
      await HelperFuction.saveUserLoggedInSatus(false);
      await HelperFuction.saveUseEmailsf("");
      await HelperFuction.saveUserNamesf("");
      await firebaseAuth.signOut();
    } catch (e) {
      return e;
    }
  }
}
