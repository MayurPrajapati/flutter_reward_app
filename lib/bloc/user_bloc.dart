import 'package:firebase_auth/firebase_auth.dart';
import 'login_bloc.dart';

class User {
  static User _instance;

  String displayName;

  static User get instance {
    if (_instance == null) {
      _instance = User._();
    }
    return _instance;
  }

  String profilePicUrl;
  String email;
  String uid;
  String phone;

  int totalPoints = 100;

  User._() {
    FirebaseUser firebaseUser = LoginBloc.instance.firebaseUser;
    String na = 'N/A';
    this.uid = LoginBloc.instance.firebaseUser.uid;
    this.email = firebaseUser.email != null ? firebaseUser.email : na;
    this.phone =
        firebaseUser.phoneNumber != null ? firebaseUser.phoneNumber : na;
    this.profilePicUrl =
        firebaseUser.photoUrl != null ? firebaseUser.photoUrl : na;

  }
}