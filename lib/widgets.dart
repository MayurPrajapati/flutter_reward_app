import 'dart:async';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final VoidCallback onTimerCompleted;

  const TimerWidget({Key key, @required this.onTimerCompleted})
      : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  Timer timer;
  int seconds = 60, prevSeconds = 60;
  bool isDisposed = false;

  @override
  void initState() {
    startTimer();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 1000), vsync: this)
          ..forward();
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn);
    super.initState();
  }

  @override
  void dispose() {
    isDisposed = true;
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Spacer(),
        Transform(
          child: Text('0:'),
          transform: Matrix4.translationValues(0.0, 10.0, 0.0),
        ),
        AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.translationValues(
                    0.0, _animation.value * 20.0, 0.0),
                child: Column(
                  children: <Widget>[
                    Opacity(
                      child: Text('$seconds'),
                      opacity: _animation.value,
                    ),
                    Opacity(
                      child: Text('$prevSeconds'),
                      opacity: (_animation.value - 1).abs(),
                    ),
                  ],
                ),
              );
            }),
        const Spacer(),
      ],
    );
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isDisposed) {
        timer.cancel();
        return;
      }
      prevSeconds = seconds;
      seconds -= 1;
      _animationController.reset();
      _animationController.forward();
      if (seconds < 0) {
        seconds = 0;
        timer.cancel();
        widget.onTimerCompleted();
      }
    });
  }
}

class ScratchCard extends StatefulWidget {
  const ScratchCard({
    Key key,
    this.cover,
    this.beforeReveal,
    this.strokeWidth = 25.0,
    this.finishPercent,
    this.afterReveal,
    this.onComplete,
  }) : super(key: key);
  final Widget cover;
  final Widget beforeReveal;
  final double strokeWidth;
  final int finishPercent;
  final VoidCallback onComplete;
  final Widget afterReveal;

  @override
  _ScratchCardState createState() => _ScratchCardState();
}

class _ScratchCardState extends State<ScratchCard> {
  _ScratchData2 _data = _ScratchData2();
  VoidCallback onComplete;
  bool isScratchCompleted = false;

  Offset _lastPoint;

  Offset _globalToLocal(Offset global) {
    return (context.findRenderObject() as RenderBox).globalToLocal(global);
  }

  double _distanceBetween(Offset point1, Offset point2) {
    return math.sqrt(math.pow(point2.dx - point1.dx, 2) +
        math.pow(point2.dy - point1.dy, 2));
  }

  double _angleBetween(Offset point1, Offset point2) {
    return math.atan2(point2.dx - point1.dx, point2.dy - point1.dy);
  }

  void _onPanDown(DragDownDetails details) {
    _lastPoint = _globalToLocal(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final currentPoint = _globalToLocal(details.globalPosition);
    final distance = _distanceBetween(_lastPoint, currentPoint);
    final angle = _angleBetween(_lastPoint, currentPoint);
    for (double i = 0.0; i < distance; i++) {
      _data.addPoint(Offset(
        _lastPoint.dx + (math.sin(angle) * i),
        _lastPoint.dy + (math.cos(angle) * i),
      ));
    }
    _lastPoint = currentPoint;
  }

  void _onPanEnd(DragEndDetails details) {
//    final areaRect = context.size.width * context.size.height;
    double touchArea = math.pi * widget.strokeWidth * widget.strokeWidth;
    double areaRevealed = _data._points
        .fold(0.0, (double prev, Offset point) => prev + touchArea);

    if (areaRevealed > 1600000 && onComplete != null) {
      onComplete();
      setState(() {
        isScratchCompleted = true;
      });
      onComplete = null;
    }
  }

  @override
  void initState() {
    super.initState();
    onComplete = widget.onComplete;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
//      onTapUp: _onPanEnd,
      onPanEnd: _onPanEnd,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          isScratchCompleted ? widget.afterReveal : widget.beforeReveal,
          !isScratchCompleted
              ? _ScratchCardLayout2(
                  strokeWidth: widget.strokeWidth,
                  data: _data,
                  child: widget.cover,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class _ScratchCardLayout2 extends SingleChildRenderObjectWidget {
  _ScratchCardLayout2({
    Key key,
    this.strokeWidth = 25.0,
    @required this.data,
    @required this.child,
  }) : super(key: key, child: child);

  final Widget child;
  final double strokeWidth;
  final _ScratchData2 data;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ScratchCardRender2(strokeWidth: strokeWidth, data: data);
  }

  @override
  void updateRenderObject(
      BuildContext context, _ScratchCardRender2 renderObject) {
    renderObject
      ..strokeWidth = strokeWidth
      ..data = data;
  }
}

class _ScratchCardRender2 extends RenderProxyBox {
  _ScratchCardRender2({
    RenderBox child,
    double strokeWidth,
    _ScratchData2 data,
  })  : assert(data != null),
        _strokeWidth = strokeWidth,
        _data = data,
        super(child);

  double _strokeWidth;
  _ScratchData2 _data;

  set strokeWidth(double strokeWidth) {
    assert(strokeWidth != null);
    if (_strokeWidth == strokeWidth) {
      return;
    }
    _strokeWidth = strokeWidth;
    markNeedsPaint();
  }

  set data(_ScratchData2 data) {
    assert(data != null);
    if (_data == data) {
      return;
    }
    if (attached) {
      _data.removeListener(markNeedsPaint);
      data.addListener(markNeedsPaint);
    }
    _data = data;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _data.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _data.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.canvas.saveLayer(offset & size, Paint());
      context.paintChild(child, offset);
      Paint clear = Paint()..blendMode = BlendMode.clear;
      _data._points.forEach((point) =>
          context.canvas.drawCircle(offset + point, _strokeWidth, clear));
      context.canvas.restore();
    }
  }

  @override
  bool get alwaysNeedsCompositing => child != null;
}

class _ScratchData2 extends ChangeNotifier {
  List<Offset> _points = [];

  void addPoint(Offset offset) {
    _points.add(offset);
    notifyListeners();
  }
}

class PointsWidget extends StatelessWidget {
  final int points;
  final double elevation;
  final double animationValue;

  const PointsWidget(
      {Key key,
        @required this.points,
        this.elevation = 8.0,
        this.animationValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final display3 = Theme.of(context)
        .textTheme
        .display3
        .copyWith(color: Colors.white, fontWeight: FontWeight.bold);

    return animationValue > 0.60
        ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Spacer(),
        Text('$points', style: display3),
        SizedBox(height: 8.0),
        Text('POINTS',
            style: Theme.of(context).textTheme.title.copyWith(
                fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    )
        : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text('$points',
            style: display3.copyWith(fontSize: display3.fontSize - 16.0)),
        SizedBox(width: 8.0),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text('POINTS',
              style: Theme.of(context).textTheme.title.copyWith(
                  fontWeight: FontWeight.w600, color: Colors.white)),
        ),
      ],
    );
  }
}