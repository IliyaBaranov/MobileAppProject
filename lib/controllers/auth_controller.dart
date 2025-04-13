import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth auth;
  GoogleSignIn googleSignIn = GoogleSignIn(); // Add this line

  AuthController({FirebaseAuth? auth})
      : auth = auth ?? FirebaseAuth.instance;

  Future<void> signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
      debugPrint('Anonymous sign-in successful');
    } catch (e, stack) {
      debugPrint('Error in signInAnonymously: $e');
      debugPrint(stack.toString());
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn(); // Use the instance field

      if (googleUser == null) {
        debugPrint('Google sign-in canceled');
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      debugPrint('Google sign-in successful');
    } catch (e, stack) {
      debugPrint('Error in signInWithGoogle: $e');
      debugPrint(stack.toString());
      rethrow;
    }
  }
}