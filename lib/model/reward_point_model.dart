import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

class RewardModel {
  int points;
  String date;
  String serviceType;
  final bool isScratched;
  final Color color;

  RewardModel({
    @required this.points,
    @required this.date,
    @required this.serviceType,
    @required this.isScratched,
    @required this.color,
  });
}

final services = [
  'Scaling (Oral Prophylaxis)',
  'Sealants',
  'Fluoridation (Anti Cavity)',
  'Veneers',
  'Teeth Whitening',
  'Dental Implants',
  'Dentures/Partial Dentures',
  'Crowns & Bridges (CAD-CAM)',
  'Intay & Onlay Restorations',
  'Composite Fillings',
  'Emergency Dental Trauma Services',
  'TMD / TMJ Disorders',
  'Custom Sports Mouth Guard',
  'Invisalign (Invisible Orthodontics)',
  'Metal Braces (USA & Germany) CE & FDA Certified',
  'Ceramic Braces (USA & Germany) CE & FDA Certified',
  'Customized Lingual Braces',
  'Cleft Lip & Palate Treatment',
  'Functional Jaw Orthopedics',
  'OPG',
  'Lateral Ceph',
  'TMJ Open & Close Mouth View',
  'Frontal Ceph',
  'Tooth Saving Procedures',
  'Simple, Surgical & Wisdom Teeth'
];

final _random = math.Random();


final accents = Colors.accents.toList()..removeWhere((color){
  return color.value == 0xffffff00 || color.value == 0xffeeff41 || color.value == 0xffb2ff59;
});

final rewardsHistory = List<RewardModel>.generate(20, (pos) {
  final points = _random.nextInt(500);
  final serviceType = services[_random.nextInt(services.length)];
  final randomColor = accents[math.Random().nextInt(accents.length)].withOpacity(0.7);

  return RewardModel(
    color: randomColor,
    isScratched: true,
      points: points,
      date: DateFormat.yMMMMd().format(DateTime.now()),
      serviceType: serviceType);
});

final newRewardPoints = List<RewardModel>.generate(20, (pos) {
  final points = _random.nextInt(500);
  final serviceType = services[_random.nextInt(services.length)];
  final randomColor = accents[math.Random().nextInt(accents.length)].withOpacity(0.7);

  return RewardModel(
    color: randomColor,
      isScratched: false,
      points: points,
      date: DateFormat.yMMMMd().format(DateTime.now()),
      serviceType: serviceType);
});


