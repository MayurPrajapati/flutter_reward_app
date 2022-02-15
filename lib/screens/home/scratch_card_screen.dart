import 'package:flutter/material.dart';
import 'package:flutter_reward_app/model/reward_point_model.dart';

import '../../my_flutter_app_icons.dart';
import '../../widgets.dart';

class ScratchCardScreen extends StatefulWidget {
  final int pos;
  final RewardModel reward;

  const ScratchCardScreen({Key key, this.pos, this.reward}) : super(key: key);

  @override
  _ScratchCardScreenState createState() => _ScratchCardScreenState();
}

class _ScratchCardScreenState extends State<ScratchCardScreen>
    with TickerProviderStateMixin {
  bool isScratchCompleted = false;
  bool isPopped = false;
  Widget _scratchCard;

  @override
  void initState() {
    _scratchCard = _buildScratchCard(context, widget.pos);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).textTheme.title.copyWith(
        color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.bold);

    return WillPopScope(
      onWillPop: () {
        pop(isScratchCompleted);
        Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => pop(isScratchCompleted)),
            title: Text('Reward', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0.0),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                  height: 50.0,
                  child: isScratchCompleted && widget.reward.points > 0
                      ? Text('Congratulations', style: title)
                      : SizedBox()),
              _scratchCard,
              SizedBox(height: 16.0),
              !isScratchCompleted
                  ? Text('* Scratch card to redeem points',
                      style: TextStyle(color: Colors.white))
                  : SizedBox(),
              isScratchCompleted
                  ? RaisedButton.icon(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      onPressed: () => pop(isScratchCompleted),
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.redeem),
                      ),
                      label: Text('Redeem'))
                  : SizedBox(),
              _buildInviteNowButton(),
            ],
          ),
        ),
      ),
    );
  }

  void pop(bool isScratchCompleted) {
    Navigator.pop<bool>(context, isScratchCompleted);
    isPopped = true;
  }

  Widget _buildScratchCard(BuildContext context, int pos) {
    print('BUILDING');
    var _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3500));
    var boldTextStyle = TextStyle(fontWeight: FontWeight.bold);

    final title = TextStyle(fontSize: 20.0, color: Colors.white);

    final subhead = TextStyle(color: Colors.white, fontSize: 16.0);

    final cover = Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        color: const Color(0xffFFDC00),
        child: Column(
          children: <Widget>[
            Spacer(),
            Icon(MyFlutterApp.gift_1, size: 100.0),
            Spacer(),
          ],
        ),
      ),
    );

    final reward = widget.reward;

    var _animation = IntTween(begin: 0, end: widget.reward.points).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    var _buildPointsText = (int points) {
      String pointsText = '';
      if (points > 0) {
        int len = 6 - points.toString().length;
        for (int i = 0; i < len; i++) pointsText += '0';
        pointsText += points.toString();
      } else
        pointsText = '000000';
      return pointsText;
    };

    final beforeReveal = Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('000000',
            style: boldTextStyle.copyWith(fontSize: 30.0, color: Colors.white)),
        Text('Points', style: TextStyle(color: Colors.white, fontSize: 20.0))
      ],
    ));

    final afterReveal = reward.points > 0
        ? Center(
            child: AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${_buildPointsText(_animation.value)}',
                      style: boldTextStyle.copyWith(
                          fontSize: 30.0, color: Colors.white)),
                  Text('Points',
                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  SizedBox(height: 24.0),
                  Text('For Service',
                      style: title.copyWith(fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 8.0),
                    child: Text(reward.serviceType,
                        style: subhead, textAlign: TextAlign.center),
                  ),
                ],
              );
            },
          ))
        : Center(
            child: Text('BETTER LUCK NEXT TIME',
                style: boldTextStyle.copyWith(fontSize: 16.0)));

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 250.0,
          width: 250.0,
          child: Material(
            color: widget.reward.color,
            borderRadius: BorderRadius.circular(8.0),
            elevation: 4.0,
            child: ScratchCard(
              key: UniqueKey(),
              afterReveal: afterReveal,
              beforeReveal: beforeReveal,
              cover: cover,
              onComplete: () => _onScratchComplete(_controller, reward.points),
            ),
          ),
        ),
      ],
    );
  }

  void _onScratchComplete(AnimationController _controller, int points) {
    setState(() {
      isScratchCompleted = true;
    });
    if (points > 0)
      _controller.forward()
        ..whenComplete(() {
//          Future.delayed(Duration(milliseconds: 600), () {
//            if (!isPopped) Navigator.pop(context, isScratchCompleted);
//          });
        });
    else {
//      Future.delayed(Duration(milliseconds: 600), () {
//        if (!isPopped) Navigator.pop(context, isScratchCompleted);
//      });
    }
  }

  Widget _buildInviteNowButton() {
    final title = Theme.of(context)
        .textTheme
        .title
        .copyWith(color: Colors.white.withOpacity(0.6));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isScratchCompleted
          ? Column(
              children: <Widget>[
                Text('Sharing is Caring', style: title),
                SizedBox(height: 16.0),
                Text(
                  'Invite your friends to earn reward points for using our services and join the community',
                  style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                OutlineButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    borderSide: BorderSide(color: Colors.pinkAccent),
                    textColor: Colors.pinkAccent,
                    color: Colors.pinkAccent,
                    highlightedBorderColor: Colors.pinkAccent,
                    onPressed: () {},
                    icon: Icon(Icons.share),
                    label: Text('Invite now!')),
              ],
            )
          : SizedBox(),
    );
  }
}
