import 'package:flutter/material.dart';
import 'package:flutter_reward_app/bloc/login_bloc.dart';
import 'login_screen.dart';
import 'package:flutter_reward_app/utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String emailErrorText;
  final LoginBloc loginBloc = LoginBloc.instance;

  @override
  void initState() {
    emailTextEditingController.addListener(() {
      if (emailErrorText != null)
        setState(() {
          emailErrorText = null;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final containerWidth = MediaQuery.of(context).size.width * 0.90;

    final emailTextFormField = TextFormField(
      controller: emailTextEditingController,
      onFieldSubmitted: (email) => _forgotPassword,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        errorText: emailErrorText,
        hintText: 'Email',
        prefixIcon: Icon(Icons.mail),
        border: InputBorder.none,
      ),
    );

    return Scaffold(
      backgroundColor: lightBlack,
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          Row(
            children: <Widget>[
              Spacer(),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0)),
                width: containerWidth,
                child: emailTextFormField,
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 12.0),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Enter your email and we will send you a link to reset your password',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 36.0),
          FloatingActionButton(
            heroTag: 'email and password',
            onPressed: _forgotPassword,
            child: Icon(Icons.arrow_forward, color: Colors.blueGrey),
            backgroundColor: Colors.white,
          ),
          SizedBox(height: 36.0),
        ],
      ),
    );
  }

  void _forgotPassword() {
    var email = emailTextEditingController.text.trim();

    if (email.isEmpty) {
      setState(() {
        emailErrorText = 'Email can\'t be empty';
      });
      return;
    }

    if (!isEmail(email)) {
      setState(() {
        emailErrorText = 'Enter valid email';
      });
      return;
    }

    final onPasswordResetEmailSent = () {
      Navigator.pop(context);
      dismissLoadingDialog(context);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Password reset email sent'),
                content: Text(
                    'Password reset email sent to $email.\nOpen link to reset password'),
              ));
    };

    final onFailed = (String error) {
      dismissLoadingDialog(context);
      showErrorDialog(error, context);
    };

    showLoadingDialog(context);
    loginBloc.forgotPassword(email, onPasswordResetEmailSent, onFailed);
  }
}
