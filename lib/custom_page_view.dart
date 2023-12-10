import 'package:flutter/material.dart';

class SliderPageTurn extends StatefulWidget {
  const SliderPageTurn({
    Key? key,
    required this.controller,
    required this.cellSize,
  }) : super(key: key);

  final Size cellSize;
  final SliderPageTurnController controller;

  @override
  SliderPageTurnState createState() => SliderPageTurnState();
}

class SliderPageTurnState extends State<SliderPageTurn>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int position = 0;
  int total = 10;

  late List<Widget> children = [
    Container(
      width: 700,
      height: 400,
      color: Colors.blue,
      child: const Text('1'),
    ),
    Container(
      width: 700,
      height: 400,
      color: Colors.yellow,
      child: const Text('2'),
    ),
    Container(
      width: 700,
      height: 400,
      color: Colors.red,
      child: const Text('3'),
    ),
  ]; // List để lưu trữ các trang

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this);
    // Khai báo _animation là late
    _animation = _animationController
        .drive(Tween(begin: 0.0, end: children.length.toDouble() - 1));

    widget.controller._toLeftCallback = (duration) {
      if (position > 0) {
        position = position - 1;
        _animationController.animateTo(position / (children.length - 1),
            duration: duration);
      }
    };

    widget.controller._toRightCallback = (duration) {
      if (position < total - 1) {
        position = position + 1;
        _animationController.animateTo(position / total, duration: duration);
      }
    };

    widget.controller._toPositionCallback = (position, duration) {
      if (position >= 0 && position <= children.length - 1) {
        _animationController.animateTo(position / (children.length - 1),
            duration: duration * (position - this.position).abs());
        this.position = position;
      }
    };
    //thay thế
    widget.controller._replatePage = (page, index) {
      children[index] = page;
    };
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final cellWidth = widget.cellSize.width;
        final cellHeight = widget.cellSize.height;

        final translateX =
            (_animation.value - _animation.value ~/ 1) * -cellWidth;
        final translateY = 0.0;
        final scale = 1.0;

        return Container(
          color: Colors.transparent,
          width: cellWidth,
          height: cellHeight,
          child: Stack(
            children: <Widget>[
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(scale, scale),
                child: getRightWidget(),
              ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translate(translateX, translateY),
                child: getLeftWidget(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getLeftWidget() {
    return children.isEmpty ? Container() : children[_animation.value.toInt()];
  }

  Widget? getRightWidget() {
    if (_animation.value.toInt() < children.length - 1) {
      return children[_animation.value.toInt() + 1];
    } else {
      return children[0];
    }
  }
}

class SliderPageTurnController {
  ValueChanged<Duration>? _toLeftCallback;
  ValueChanged<Duration>? _toRightCallback;
  void Function(int, Duration)? _toPositionCallback;
  void Function(Widget, int)? _replatePage;

  void animToLeftWidget(
      {Duration duration = const Duration(milliseconds: 350)}) {
    if (_toLeftCallback != null) {
      _toLeftCallback!(duration);
    }
  }

  void animToRightWidget(
      {Duration duration = const Duration(milliseconds: 350)}) {
    if (_toRightCallback != null) {
      _toRightCallback!(duration);
    }
  }

  void animToPositionWidget(int position,
      {Duration duration = const Duration(milliseconds: 350)}) {
    if (_toPositionCallback != null) {
      _toPositionCallback!(position, duration);
    }
  }

  void replarePage(Widget page, int index) {
    if (_replatePage != null) {
      _replatePage!(page, index);
    }
  }
}
