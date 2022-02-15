import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reward_app/main.dart';
import 'package:flutter_reward_app/my_flutter_app_icons.dart';
import 'package:flutter_reward_app/bloc/login_bloc.dart';
import 'package:flutter_reward_app/screens/home/home_screen.dart';
import 'forgot_password_screen.dart';
import 'package:flutter_reward_app/utils.dart';

import 'phone_login_screen.dart';

const lightBlack = Color(0xff2B3B4A);
final TextEditingController emailTextEditingController =
    TextEditingController();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignUpScreen = true;
  String nameErrorText; // used to show error messages
  String emailErrorText;
  String passwordErrorText;

  final passwordFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  bool isPasswordVisible = true;

  @override
  void initState() {
    emailTextEditingController.addListener(() {
      if (emailErrorText != null)
        setState(() {
          emailErrorText = null;
        });
    });

    _passwordTextEditingController.addListener(() {
      if (passwordErrorText != null)
        setState(() {
          passwordErrorText = null;
        });
    });

    _nameTextEditingController.addListener(() {
      if (nameErrorText != null)
        setState(() {
          nameErrorText = null;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlack,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 60.0),
            _buildSignUpOrSignIn(),
            const SizedBox(height: 30.0),
            CircleAvatar(
              child: Image.asset('assets/images/logo.png', scale: 1.5),
              backgroundColor: Colors.white,
              radius: 40.0,
            ),
            const SizedBox(height: 56.0),
            _buildEmailPasswordTextFields(),
            const SizedBox(height: 16.0),
            !isSignUpScreen
                ? FlatButton(
                    onPressed: _forgotPassword,
                    child: Text('Forgot password?'),
                    textColor: Colors.green,
                  )
                : SizedBox(),
            const SizedBox(height: 16.0),
            _buildLoginButtons(),
          ],
        ),
      ),
    );
  }

  void _signInWithFacebook() {
    showLoadingDialog(context);

    var onSuccess = (FirebaseUser user) {
      dismissLoadingDialog(context);
      _onLoginSuccessful(context);
    };
    var onCancelledByUser = () {
      dismissLoadingDialog(context);
    };
    var onError = (error) {
      dismissLoadingDialog(context);
      showErrorDialog(error, context);
    };

    LoginBloc.instance.signInWithFacebook(context,
        onError: onError,
        onSuccess: onSuccess,
        onCancelledByUser: onCancelledByUser);
  }

  void _signInWithGoogle() {
    showLoadingDialog(context);
    LoginBloc.instance.signInWithGoogle(onSuccess: (user) {
      dismissLoadingDialog(context);
      assert(user != null);
      if (user == null)
        showErrorDialog('Some error has occurred', context);
      else
        _onLoginSuccessful(context);
    }, onFailed: (message) {
      dismissLoadingDialog(context);
      showErrorDialog(message, context);
    });
  }

  void _signInWithPhone() => Navigator.push(context,
      SlideMaterialPageRoute(builder: (context) => PhoneLoginScreen()));

  void _onLoginSuccessful(BuildContext context) => Navigator.push(
      context, SlideMaterialPageRoute(builder: (context) => HomeScreen()));

  void _onSignUpButtonClicked() {
    setState(() {
      nameErrorText = null;
      isSignUpScreen = !isSignUpScreen;
    });
  }

  Widget _buildSignUpOrSignIn() {
    return isSignUpScreen
        ? Row(
            children: <Widget>[
              const SizedBox(width: 16.0),
              Text(
                'Sign up',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const Spacer(),
              RaisedButton(
                onPressed: _onSignUpButtonClicked,
                shape: CircleBorder(),
                child: Icon(Icons.vpn_key),
                color: Colors.black,
                textColor: Colors.white,
              )
            ],
          )
        : Row(
            children: <Widget>[
              const SizedBox(width: 16.0),
              Text(
                'Sign in',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const Spacer(),
              RaisedButton(
                onPressed: _onSignUpButtonClicked,
                shape: CircleBorder(),
                child: Icon(Icons.add),
                color: Colors.black,
                textColor: Colors.white,
              )
            ],
          );
  }

  Widget _buildEmailPasswordTextFields() {
    final containerWidth = MediaQuery.of(context).size.width * 0.90;

    final nameTextFormField = TextFormField(
      controller: _nameTextEditingController,
      onFieldSubmitted: (name) =>
          FocusScope.of(context).requestFocus(emailFocusNode),
      decoration: InputDecoration(
        errorText: nameErrorText,
        hintText: 'Name',
        prefixIcon: Icon(Icons.person),
        border: InputBorder.none,
      ),
    );

    final emailTextFormField = TextFormField(
      focusNode: emailFocusNode,
      controller: emailTextEditingController,
      keyboardType: TextInputType.emailAddress,
      onFieldSubmitted: (email) =>
          FocusScope.of(context).requestFocus(passwordFocusNode),
      decoration: InputDecoration(
        errorText: emailErrorText,
        hintText: 'Email',
        prefixIcon: Icon(Icons.mail),
        border: InputBorder.none,
      ),
    );

    final passwordTextFormField = TextFormField(
      focusNode: passwordFocusNode,
      controller: _passwordTextEditingController,
      onFieldSubmitted: (password) => _signInOrSignUpWithEmailAndPassword(),
      decoration: InputDecoration(
        errorText: passwordErrorText,
        hintText: 'Password',
        prefixIcon: Icon(Icons.lock),
        border: InputBorder.none,
      ),
    );

    final border = Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Divider(height: 2.0, color: Colors.black));

    return AnimatedContainer(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
      width: containerWidth,
      duration: Duration(milliseconds: 300),
      child: Column(
        children: <Widget>[
          isSignUpScreen ? nameTextFormField : SizedBox(),
          isSignUpScreen ? border : SizedBox(),
          emailTextFormField,
          border,
          passwordTextFormField,
        ],
      ),
    );
  }

  Widget _buildLoginButtons() {
    const padding = SizedBox(width: 16.0);
    return Row(
      children: <Widget>[
        padding,
        FloatingActionButton(
          heroTag: 'facebook',
          onPressed: _signInWithFacebook,
          child: Icon(MyFlutterApp.facebook),
          backgroundColor: Color(0xff4065AD),
        ),
        padding,
        FloatingActionButton(
          heroTag: 'google',
          onPressed: _signInWithGoogle,
          child: Icon(MyFlutterApp.google),
          backgroundColor: Color(0xffEA5743),
        ),
        padding,
        FloatingActionButton(
          heroTag: 'phone',
          onPressed: _signInWithPhone,
          child: Icon(Icons.phone),
          backgroundColor: Colors.blueGrey,
        ),
        const Spacer(),
        FloatingActionButton(
          heroTag: 'email and password',
          onPressed: _signInOrSignUpWithEmailAndPassword,
          child: Icon(Icons.arrow_forward, color: Colors.blueGrey),
          backgroundColor: Colors.white,
        ),
        padding,
      ],
    );
  }

  void _signInOrSignUpWithEmailAndPassword() {
    var name = _nameTextEditingController.text.trim();
    if (isSignUpScreen) {
      if (name.isEmpty) {
        setState(() {
          nameErrorText = 'Enter valid name';
        });
        return;
      }
    }

    var email = emailTextEditingController.text.trim();
    var password = _passwordTextEditingController.text;
    if (email.isEmpty) {
      setState(() {
        emailErrorText = 'Email can\'t be empty';
      });
      return;
    }
    if (password.isEmpty) {
      setState(() {
        passwordErrorText = 'Password can\'t be empty';
      });
      return;
    }
    if (!isEmail(email)) {
      setState(() {
        emailErrorText = 'Enter valid email';
      });
      return;
    }

    showLoadingDialog(context);
    var onSuccess = () {
      dismissLoadingDialog(context);
      Navigator.push(
          context, SlideMaterialPageRoute(builder: (context) => HomeScreen()));
    };
    var onFailed = (String error) {
      if (error
          .contains('There is no user record corresponding to this identifier'))
        error = 'Account doesn\'t exists';
      dismissLoadingDialog(context);
      showErrorDialog(error, context);
    };

    if (isSignUpScreen) {
      var onVerificationMailSent = () {
        dismissLoadingDialog(context);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Email not verified'),
                  content: Text(
                      'Verification mail sent to $email.\nPlease, verify email to login.'),
                ));
      };
      LoginBloc.instance.signUpWithEmailAndPassword(
          email, password, onSuccess, onFailed, onVerificationMailSent);
    } else {
      var onEmailNotVerified = () {
        dismissLoadingDialog(context);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Email not verified'),
                  content: Text('Verification mail sent to $email'),
                ));
      };
      LoginBloc.instance.signInWithEmailAndPassword(
          email, password, onSuccess, onFailed, onEmailNotVerified);
    }
  }

  void _forgotPassword() => Navigator.push(context,
      SlideMaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
}
