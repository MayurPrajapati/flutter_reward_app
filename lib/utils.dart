import 'package:flutter/material.dart';

bool _isShowingLoadingDialog = false;

void showErrorDialog(String msg, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Text(msg),
        );
      });
}

void showLoadingDialog(BuildContext context) async {
  _isShowingLoadingDialog = true;
  await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        content: Center(
            child:
            CircularProgressIndicator(backgroundColor: Colors.white)),
      ));
  _isShowingLoadingDialog = false;
}

void dismissLoadingDialog(BuildContext context) =>
    _isShowingLoadingDialog ? Navigator.pop(context) : Object();

bool isEmail(String em) => RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
    .hasMatch(em);