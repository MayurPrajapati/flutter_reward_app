import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reward_app/bloc/login_bloc.dart';

import '../../main.dart';
import '../../utils.dart';
import '../../widgets.dart';
import 'package:flutter_reward_app/screens/home/home_screen.dart';

const lightBlack = Color(0xff2B3B4A);

class PhoneLoginScreen extends StatefulWidget {
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneNumberTextEditingController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _nameTextEditingController =
      TextEditingController();

  final phoneFocusNode = FocusNode();

  String nameErrorText; // used to show error messages
  String phoneErrorText;

  bool _verificationInProcess = false;

  bool _isShowingOtpDialog = false;

  @override
  void initState() {
    _phoneNumberTextEditingController.addListener(() {
      if (phoneErrorText != null)
        setState(() {
          phoneErrorText = null;
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
    final containerWidth = MediaQuery.of(context).size.width * 0.90;

    final emailTextFormField = TextFormField(
      controller: _phoneNumberTextEditingController,
      onFieldSubmitted: (phone) => _onVerifyButtonClicked(),
      keyboardType: TextInputType.phone,
      focusNode: phoneFocusNode,
      decoration: InputDecoration(
        prefixText: '+91 ',
        errorText: phoneErrorText,
        hintText: 'Phone',
        prefixIcon: Icon(Icons.phone),
        border: InputBorder.none,
      ),
    );

    final nameTextFormField = TextFormField(
      controller: _nameTextEditingController,
      onFieldSubmitted: (name) =>
          FocusScope.of(context).requestFocus(phoneFocusNode),
      decoration: InputDecoration(
        errorText: nameErrorText,
        hintText: 'Name',
        prefixIcon: Icon(Icons.person),
        border: InputBorder.none,
      ),
    );

    final border = Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Divider(height: 2.0, color: Colors.black));

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text('Phone Sign in'),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context))),
      backgroundColor: lightBlack,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 80.0),
            Icon(Icons.person, size: 150.0, color: Colors.white),
            Row(
              children: <Widget>[
                Spacer(),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0)),
                  width: containerWidth,
                  child: Column(
                    children: <Widget>[
                      nameTextFormField,
                      border,
                      emailTextFormField,
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 50.0),
            FloatingActionButton(
              heroTag: 'phone',
              onPressed: _onVerifyButtonClicked,
              child: Icon(Icons.arrow_forward, color: Colors.blueGrey),
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 36.0),
          ],
        ),
      ),
    );
  }

  _showSnackBar(String msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
  }

//  @override
//  Widget build(BuildContext context) {
//    return SafeArea(
//      child: Scaffold(
//        backgroundColor: lightBlack,
//        key: _scaffoldKey,
//        appBar: AppBar(
//            elevation: 0.0,
//            backgroundColor: Colors.transparent,
//            leading: IconButton(
//                icon: Icon(Icons.arrow_back, color: Colors.black),
//                onPressed: () {
//                  Navigator.pop(context);
//                })),
//        body: SingleChildScrollView(
//          physics: null,
//          child: Center(
//            child: Column(
//              children: <Widget>[
//                const SizedBox(height: 80.0),
//                Icon(Icons.person, size: 150.0, color: Color(0xff4B4B4B)),
//                const SizedBox(height: 8.0),
//                _buildPhoneTextField(),
//                const SizedBox(height: 36.0),
//                _buildVerifyButton(),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }

//  Widget _buildPhoneTextField() {
//    final titleStyle =
//    Theme.of(context).textTheme.title.copyWith(color: Colors.white);
//    return Align(
//      alignment: Alignment.centerLeft,
//      child: Container(
//        height: 60.0,
//        width: blockWidth,
//        decoration: BoxDecoration(
//            color: Color(0xff8A8A8A),
//            borderRadius:
//            BorderRadius.only(topRight: radius, bottomRight: radius)),
//        child: Row(
//          children: <Widget>[
//            _buildButtonContainer(Icons.phone),
//            Expanded(
//              child: TextFormField(
//                onFieldSubmitted: (_) => _onVerifyButtonClicked(),
//                keyboardType: TextInputType.phone,
//                style: titleStyle,
//                decoration: InputDecoration(
//                    prefixStyle: titleStyle,
//                    prefixText: ' +91 ',
//                    border: InputBorder.none),
//                controller: phoneNumberTextEditingController,
//              ),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget _buildVerifyButton() {
//    return RaisedButton(
//      onPressed: _onVerifyButtonClicked,
//      child: Text('Verify'),
//      color: Color(0xff33FF00),
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
//    );
//  }
//
  void _onVerifyButtonClicked() {
    //validate name
    var name = _nameTextEditingController.text.trim();
    if (name.isEmpty) {
      setState(() {
        nameErrorText = 'Enter valid name';
      });
      return;
    }

    //validate phone
    var phone = _phoneNumberTextEditingController.text.trim();
    var pattern = RegExp(r'^[0-9]{10}$');
    if (!pattern.hasMatch(phone))
      setState(() {
        phoneErrorText = 'Enter valid phone number.';
      });
    else {
      phone = '+91$phone';
      var onSendButtonPressed = () {
        if (_verificationInProcess) return;
        Navigator.pop(context); // Dismissing send otp button dialog
        var otpController = TextEditingController();

        var onVerificationFailed = (String error) {
          dismissLoadingDialog(context);
          _dismissOtpDialog();
          showErrorDialog(error, context);
        };
        _verificationInProcess = true;
        _showOtpDialog(context, otpController, onVerificationFailed);
        _verificationInProcess = false;

        var onAutoRetrievalTimeout = () {};
        LoginBloc.instance.signInWithPhone(
            phoneNo: phone,
            onVerificationUpdate: onVerificationUpdate,
            onVerificationFailed: onVerificationFailed,
            onCodeSent: () => _showSnackBar('Code sent to $phone'),
            onAutoRetrievalTimeout: onAutoRetrievalTimeout);
      };
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              content: SizedBox(
                height: 60.0,
                child: Column(
                  children: <Widget>[
                    Text('Send verification code to '),
                    Text(phone, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel')),
                FlatButton(onPressed: onSendButtonPressed, child: Text('Send')),
              ],
            );
          });
    }
  }

  void onVerificationUpdate(FirebaseUser user) {
    dismissLoadingDialog(context);
    _dismissOtpDialog();
    if (user != null) {
      Navigator.pushReplacement(context,
          SlideMaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      showErrorDialog('Some error has occurred', context);
    }
  }

  void _dismissOtpDialog() =>
      _isShowingOtpDialog ? Navigator.pop(context) : Object();

//
  void _showOtpDialog(BuildContext context, TextEditingController otpController,
      void Function(String value) onVerificationFailed) async {
    _isShowingOtpDialog = true;
    var onOtpSubmitted = () {
      var otp = otpController.text.trim();
      if (otp.length == 6) {
        LoginBloc.instance.verifyVerificationCode(
            onVerificationUpdate: onVerificationUpdate,
            onVerificationFailed: onVerificationFailed,
            smsCode: otp);
        showLoadingDialog(context);
      } else
        _showSnackBar('Enter valid otp');
    };
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _verificationInProcess = false;
                  },
                  child: Text('Cancel')),
              FlatButton(onPressed: onOtpSubmitted, child: Text('Ok')),
            ],
            title: Center(
                child: Text('OTP',
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontWeight: FontWeight.bold))),
            content: SizedBox(
              height: 140.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    maxLength: 6,
                    cursorColor: Colors.black,
                    onFieldSubmitted: (_) => onOtpSubmitted(),
                    keyboardType: TextInputType.phone,
                    controller: otpController,
                    decoration: InputDecoration(
                        hintText: 'OTP', border: OutlineInputBorder()),
                  ),
                  TimerWidget(onTimerCompleted: () {
                    print('Timeout');
                    Navigator.pop(context);
                    _showSnackBar('Try again.. next time');
                  }),
                ],
              ),
            ),
          );
        });
    _isShowingOtpDialog = false;
  }
}
