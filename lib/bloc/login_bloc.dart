import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginBloc {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static LoginBloc _instance;

  FirebaseUser _firebaseUser;

  FirebaseUser get firebaseUser {
    return _firebaseUser;
  }

  LoginBloc._();

  static LoginBloc get instance {
    if (_instance == null) _instance = LoginBloc._();
    return _instance;
  }

  void signInWithEmailAndPassword(
      String email,
      String password,
      void Function() onSuccess,
      void Function(String error) onFailed,
      void Function() onEmailNotVerified) async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      assert(user != null);
      if (user.isEmailVerified) {
        onSuccess();
      } else {
        user.sendEmailVerification().then((v) {
          print('Verification mail sent');
          onEmailNotVerified();
        });
      }
    } catch (e) {
      onFailed(_getErrorMessageFromException(e));
    }
  }

  void forgotPassword(String email, VoidCallback onPasswordResetEmailSent,
      void Function(String errot) onFailed) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      onPasswordResetEmailSent();
    } catch (e) {
      final error = _getErrorMessageFromException(e);
      onFailed(error);
    }
  }

  void signUpWithEmailAndPassword(
      String email,
      String password,
      void Function() onSuccess,
      void Function(String error) onFailed,
      void Function() onVerificationMailSent) async {
    try {
      var providers = await _auth.fetchSignInMethodsForEmail(email: email);
      print(providers);
//      if (providers != null && providers.length > 0) {
      var user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      assert(user != null);
      if (user.isEmailVerified) {
        print('VERIFIED');
        onSuccess();
      } else {
        user.sendEmailVerification().then((v) {
          print('Verification mail sent');
          onVerificationMailSent();
        });
      }
//      } else {
//        onFailed('Invalid email address');
//      }
    } catch (e) {
      onFailed(_getErrorMessageFromException(e));
    }
  }

  String _getErrorMessageFromException(Object e) {
    if (e is AuthException) {
      print(e.message);
      return e.message;
    } else if (e is PlatformException) {
      print(e.message);
      return e.message;
    }
    print('Unknows error ${e.toString()}');
    return 'Some error has occurred';
  }

  void signInWithFacebook(BuildContext context,
      {@required void Function(String errorMessage) onError,
      @required void Function(FirebaseUser user) onSuccess,
      @required void Function() onCancelledByUser}) async {
    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult result =
        await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        this.token = token;
        print('TOKEN: $token');
        try {
          _firebaseUser = await _auth.signInWithCredential(
              FacebookAuthProvider.getCredential(accessToken: token));
          assert(_firebaseUser != null);
          onSuccess(_firebaseUser);
        } catch (e) {
          onError(_getErrorMessageFromException(e));
        }
        break;
      case FacebookLoginStatus.error:
        print('${result.errorMessage}');
        onError(result.errorMessage);
        break;
      case FacebookLoginStatus.cancelledByUser:
        onCancelledByUser();
        break;
    }
  }

  var token = '';

  signInWithGoogle(
      {@required Function(FirebaseUser user) onSuccess,
      @required Function(String message) onFailed}) async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      _firebaseUser = await _auth.signInWithCredential(credential);
      assert(_firebaseUser != null);
      if (_firebaseUser != null)
        onSuccess(_firebaseUser);
      else
        onFailed('Some error occurred');
    } catch (e) {
      onFailed(_getErrorMessageFromException(e));
    }
  }

  Function(FirebaseUser user) onVerificationUpdate;
  Function(String msg) onVerificationFailed;
  Function() onCodeSent;
  Function() onAutoRetrievalTimeout;
  String verificationId;
  bool isVerified = false;

  signInWithPhone(
      {@required String phoneNo,
      @required Function(FirebaseUser user) onVerificationUpdate,
      @required void Function(String msg) onVerificationFailed,
      @required void Function() onCodeSent,
      @required void Function() onAutoRetrievalTimeout}) async {
    this.onVerificationUpdate = onVerificationUpdate;
    this.onVerificationFailed = onVerificationFailed;
    this.onCodeSent = onCodeSent;
    this.onAutoRetrievalTimeout = onAutoRetrievalTimeout;
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this.onAutoRetrievalTimeout();
      verificationId = verId;
    };

    final PhoneCodeSent phoneCodeSent = (String verId, [int forceCodeResend]) {
      verificationId = verId;
      this.onCodeSent();
    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
      _firebaseUser = user;
      this.onVerificationUpdate(user);
    };

    final PhoneVerificationFailed verifiedFailed = (AuthException exception) {
      this.onVerificationFailed(exception.message);
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verifiedFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }

  verifyVerificationCode(
      {String smsCode,
      Function(FirebaseUser user) onVerificationUpdate,
      Function(String msg) onVerificationFailed}) async {
    try {
      var user = await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.getCredential(
              verificationId: verificationId, smsCode: smsCode));
      this._firebaseUser = user;
      onVerificationUpdate(user);
    } catch (e) {
      onVerificationFailed(_getErrorMessageFromException(e));
    }
  }
}
