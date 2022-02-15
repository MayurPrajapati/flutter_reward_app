import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_reward_app/bloc/user_bloc.dart';
import 'dart:io';
import 'package:flutter_reward_app/model/reward_point_model.dart';
import 'package:flutter_reward_app/main.dart';
import 'package:flutter_reward_app/my_flutter_app_icons.dart';
import 'package:flutter_reward_app/screens/about_us_screen.dart';
import 'package:flutter_reward_app/screens/user_info_screen.dart';
import 'package:flutter_reward_app/widgets.dart';
import 'dart:math' as math;

import 'scratch_card_screen.dart';

const _blue = Color(0xff00C6FE);
const _yellow = Color(0xffFFDC00);

const upperContainerHeight = 200.0;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController _pointsAnimationController;
  AnimationController _initialAnimationController;
  final rewardModes = ['New Rewards', 'History'];
  final user = User.instance;
  String selectedRewardMode;

  int startingPoints;
  int endingPoints;

  Animation<int> _pointsAnimation;

  Animation<double> _lowerContainerTransformAnimation;

  @override
  void initState() {
    startingPoints = 0;
    endingPoints = user.totalPoints;

    selectedRewardMode = rewardModes[0];
    _pointsAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 4));

    _pointsAnimation = IntTween(begin: startingPoints, end: endingPoints)
        .animate(CurvedAnimation(
            parent: _pointsAnimationController, curve: Curves.fastOutSlowIn));

    _initialAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500))
          ..addStatusListener((status) => status == AnimationStatus.completed
              ? _pointsAnimationController.forward()
              : Object())
          ..addListener(() {
            setState(() {});
          });

    _lowerContainerTransformAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(
            parent: _initialAnimationController, curve: Curves.fastOutSlowIn));

    _initialAnimationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonClicked(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(
            headerSliverBuilder: _buildAppBar,
            body: _buildCardsList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCardsList() {
    return selectedRewardMode == rewardModes[0]
        ? Transform(
            child: newRewardPoints.length == 0
                ? Center(
                    child: Text(
                    'Rewards not available',
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white),
                  ))
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: _buildNewCard,
                    itemCount: newRewardPoints.length),
            transform: Matrix4.translationValues(
                0.0, _lowerContainerTransformAnimation.value * 500.0, 0.0),
          )
        : Transform(
            child: rewardsHistory.length == 0
                ? Center(
                    child: Text(
                    'No history available',
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white),
                  ))
                : ListView.builder(
                    itemBuilder: _buildHistoryCard,
                    itemCount: rewardsHistory.length),
            transform: Matrix4.translationValues(
                0.0, _lowerContainerTransformAnimation.value * 500.0, 0.0),
          );
  }

  Widget _buildNewCard(BuildContext context, int pos) {
    final reward = newRewardPoints[pos];

    final _radius = BorderRadius.circular(8.0);
    return Padding(
      key: Key(pos.toString()),
      padding: const EdgeInsets.all(16.0),
      child: Material(
        color: _yellow,
        elevation: 6.0,
        shape: RoundedRectangleBorder(borderRadius: _radius),
        child: InkWell(
          borderRadius: _radius,
          splashColor: _blue,
          onTap: () => _onClickCard(pos, reward),
          child: Container(
              child:
                  Icon(MyFlutterApp.gift_1, color: Colors.black, size: 90.0)),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, int pos) {
    final reward = rewardsHistory[pos];
    final pointsTextTheme = Theme.of(context)
        .textTheme
        .display1
        .copyWith(color: Colors.white, fontWeight: FontWeight.bold);

    final title =
        Theme.of(context).textTheme.title.copyWith(color: Colors.white);

    final subhead =
        Theme.of(context).textTheme.subhead.copyWith(color: Colors.white);

    return Padding(
      key: Key(pos.toString()),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          color: reward.color,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('${reward.points}', style: pointsTextTheme),
                Text('Points', style: title),
                SizedBox(height: 16.0),
                Text('For Service',
                    style: title.copyWith(fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 8.0),
                  child: Text(reward.serviceType,
                      style: subhead, textAlign: TextAlign.center),
                ),
                Text('Date',
                    style: title.copyWith(fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 8.0),
                  child: Text(reward.date,
                      style: subhead, textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onClickCard(int pos, RewardModel reward) {
    Navigator.push<bool>(
        context,
        MaterialPageRoute(
            builder: (context) => ScratchCardScreen(
                  pos: pos,
                  reward: reward,
                ))).then((isScratchComplete) {
      if (isScratchComplete == null) return;
      if (isScratchComplete) {
        rewardsHistory.insert(0, newRewardPoints.removeAt(pos));
      }
      if (reward.points > 0) {
        if (isScratchComplete) {
          _addPoints(reward);
        }
      }
    });
  }

  void _addPoints(RewardModel reward) {
    startingPoints = endingPoints;
    endingPoints = startingPoints + reward.points;
    _pointsAnimation = IntTween(begin: startingPoints, end: endingPoints)
        .animate(CurvedAnimation(
            parent: _pointsAnimationController, curve: Curves.fastOutSlowIn));
    _pointsAnimationController.reset();
    _pointsAnimationController.forward();
  }

  _onBackButtonClicked(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            title: Text('Quit?'),
            content: Text('Are you sure?\nYou want to leave?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context), child: Text('No')),
              FlatButton(
                  onPressed: () => exit(0),
                  child: Text('Quit'),
                  textColor: Colors.red),
            ],
          );
        });
  }

  void _onUserInfoButtonClicked(BuildContext context) {
    Navigator.push(context,
        SlideMaterialPageRoute(builder: (context) => UserInfoScreen()));
  }

  void _onAboutUsButtonClicked() => Navigator.push(
      context, SlideMaterialPageRoute(builder: (context) => AboutUsScreen()));

  List<Widget> _buildAppBar(context, isHeaderCollapsed) {
    return [
      SliverAppBar(
        title: Text('Rewards'),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info, color: Colors.white),
              onPressed: _onAboutUsButtonClicked)
        ],
        leading: IconButton(
            icon: Icon(Icons.person_outline, color: Colors.white),
            onPressed: () => _onUserInfoButtonClicked(context)),
        floating: true,
        centerTitle: true,
        primary: true,
      ),
      SliverAppBar(
        leading: SizedBox(),
        elevation: 0.0,
        expandedHeight: upperContainerHeight,
        pinned: true,
        flexibleSpace: LayoutBuilder(builder: (context, constraints) {
          final height = constraints.maxHeight;
          final animValue = (height * 1.0) / upperContainerHeight;
          return FlexibleSpaceBar(
            centerTitle: true,
            title: AnimatedBuilder(
              animation: _pointsAnimation,
              builder: (context, child) => PointsWidget(
                  points: _pointsAnimation.value, animationValue: animValue),
            ),
          );
        }),
      ),
      SliverAppBar(
        pinned: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        forceElevated: false,
        leading: SizedBox(),
        centerTitle: true,
        title: DropdownButton<String>(
          value: selectedRewardMode,
          onChanged: (changed) => setState(() {
                selectedRewardMode = changed;
              }),
          items: [
            DropdownMenuItem(
                child: Text(rewardModes[0]), value: rewardModes[0]),
            DropdownMenuItem(child: Text(rewardModes[1]), value: rewardModes[1])
          ],
        ),
      )
    ];
  }
}
