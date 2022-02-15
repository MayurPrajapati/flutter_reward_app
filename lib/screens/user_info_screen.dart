import 'package:flutter/material.dart';

class UserInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context))),
      body: _Body(),
    ));
  }
}

class _Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

const _curve = Curves.fastOutSlowIn;
const _grey = Color(0xffE3E3E3);
const _maxBoxWidth = 230.0;

class _BodyState extends State<_Body> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _profileAnimation;
  Animation<double> _pointsAnimation;
  Animation<double> _contentAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 750));
    _profileAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _controller, curve: Interval(0.0, 1.0, curve: _curve)));

    _pointsAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _controller, curve: Interval(0.0, 1.0, curve: _curve)));

    _contentAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _controller, curve: Interval(0.0, 1.0, curve: _curve)));

    Future.delayed(Duration(milliseconds: 150), () => _controller.forward());

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _controller.reverse();
        return true;
      },
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildUserProfile(),
              _buildUserPoints(),
            ],
          ),
          const SizedBox(height: 16.0),
          _buildUserContent(),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    const _boxWidth = 130.0;
    return AnimatedBuilder(
      animation: _profileAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value,
          child: Transform(
              child: child,
              transform: Matrix4.translationValues(
                  _profileAnimation.value * _boxWidth, 0.0, 0.0)),
        );
      },
      child: const SizedBox(
        height: 130.0,
        width: _boxWidth,
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/user.png'),
        ),
      ),
    );
  }

  Widget _buildUserPoints() {
    const _boxWidth = 160.0;
    final display1 = Theme.of(context)
        .textTheme
        .display1
        .copyWith(fontWeight: FontWeight.bold, color: Colors.black);
    final _radius = BorderRadius.circular(8.0);
    return AnimatedBuilder(
      animation: _pointsAnimation,
      builder: (context, child) {
        return Transform(
            child: child,
            transform: Matrix4.translationValues(
                _pointsAnimation.value * _boxWidth, 0.0, 0.0));
      },
      child: Container(
        height: 100.0,
        width: _boxWidth,
        decoration: BoxDecoration(color: _grey, borderRadius: _radius),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(child: Text('2000', style: display1)),
            const Text('POINTS', style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserContent() {
    const _boxHeight = 500.0;
    return AnimatedBuilder(
        animation: _contentAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Mayur Prajapati',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 24.0),
            _buildPhoneOrEmail(),
            const SizedBox(height: 24.0),
            _buildUserDescription(),
          ],
        ),
        builder: (context, child) {
          return Opacity(
            opacity: _controller.value,
            child: Transform(
                child: child,
                transform: Matrix4.translationValues(
                    0.0, _contentAnimation.value * _boxHeight, 0.0)),
          );
        });
  }

  Widget _buildPhoneOrEmail() {
    return Container(
      width: _maxBoxWidth,
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      decoration:
          BoxDecoration(color: _grey, borderRadius: BorderRadius.circular(8.0)),
      child: Center(
          child: Text(
        '+91 0123456789',
        style: Theme.of(context).textTheme.subtitle,
      )),
    );
  }

  Widget _buildUserDescription() {
    return Container(
      width: _maxBoxWidth,
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0, right: 8.0, left: 8.0),
      decoration:
          BoxDecoration(color: _grey, borderRadius: BorderRadius.circular(8.0)),
      child: Center(
          child: Text(
        '"If you could go back...would you change what you had done?" her eyes searched his, relaxing when he shook his head. "No," he murmured, "Because then how could I have all the beauty this world holds?"',
        style: Theme.of(context).textTheme.subtitle,
      )),
    );
  }
}
