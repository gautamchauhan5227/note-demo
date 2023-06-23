import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServiceModel with ChangeNotifier {
  String _email = '';
  String _password = '';
  late bool _isProgress = false;
  late bool _isProgressGoogle = false;
  late bool _showPassword = false;

  String get email => _email;
  String get password => _password;
  bool get isProgress => _isProgress;
  bool get isProgressGoogle => _isProgressGoogle;
  bool get showPassword => _showPassword;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setProgress(bool progress) {
    _isProgress = progress;
    notifyListeners();
  }

  void setProgressGoogle(bool progress) {
    _isProgressGoogle = progress;
    notifyListeners();
  }

  void setShowPassword(bool password) {
    _showPassword = password;
    notifyListeners();
  }

  Future<String> signInWithEmailPassword() async {
    setProgress(true);
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final user = await firebaseAuth.signInWithEmailAndPassword(
          email: _email, password: _password);
      if (user.credential != null) {
        final userAuth = user.credential;
        final authCredential = GoogleAuthProvider.credential(
          idToken: userAuth!.token.toString(),
          accessToken: userAuth.accessToken,
        );

        await firebaseAuth.signInWithCredential(authCredential);
      }
      setProgress(false);
      return 'success';
    } catch (ex) {
      if (ex.toString().contains('no user')) {
        final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        await firebaseAuth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        setProgress(false);
        return 'success';
      } else {
        setProgress(false);
        return "Wrong credentials";
      }
    }
  }

  Future<String> signInWithGoogle() async {
    setProgressGoogle(true);
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuthentication = await googleUser.authentication;
        final authCredential = GoogleAuthProvider.credential(
          idToken: googleAuthentication.idToken,
          accessToken: googleAuthentication.accessToken,
        );
        await firebaseAuth.signInWithCredential(authCredential);
      }
      setProgressGoogle(false);
      return 'success';
    } catch (ex) {
      setProgressGoogle(false);
      return "Something went wrong";
    }
  }
}
