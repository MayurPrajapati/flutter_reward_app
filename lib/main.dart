import 'package:flutter/material.dart';
import 'package:flutter_reward_app/screens/login/login_screen.dart';

const lightBlack = Color(0xff2B3B4A);

void main() => runApp(MaterialApp(
      home: LoginScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: lightBlack,
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
    ));

class SlideMaterialPageRoute<T> extends MaterialPageRoute<T> {
  SlideMaterialPageRoute(
      {@required WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var offset =
        Offset(height * (animation.value - 1.0), width * (animation.value - 1));
    return FadeTransition(
      opacity: animation,
      child: Transform(
          transform: Matrix4.translationValues(offset.dx, 0.0, 0.0),
          child: child),
    );
  }
}
