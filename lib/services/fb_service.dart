import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FbService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static User? currentUser;

  static Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      currentUser = _auth.currentUser;

      // Once signed in, return the UserCredential
      return _auth.signInWithCredential(credential);
    } catch (signUpError) {
      throw Exception(signUpError);
    }
  }

  static Future<void> signOut(BuildContext context) async {
    await _auth.signOut().then((_) {
      _googleSignIn.signOut();
      currentUser = null;
    });
  }
}
