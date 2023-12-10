import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'content.dart';

class PageSlider extends StatefulWidget {
  PageSlider(
      {@required this.pages,
      this.duration,
      this.initialPage,
      this.onFinished,
      @required Key? key})
      : super(key: key);

  final List<Widget>? pages;
  final Duration? duration;
  final int? initialPage;
  final VoidCallback? onFinished;

  PageSliderState createState() => PageSliderState();
}

class PageSliderState extends State<PageSlider> with TickerProviderStateMixin {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  List<Animation<Offset>>? _positions;
  List<AnimationController>? _controllers;
  List<Widget>? pages;
  late InAppWebViewController webViewController0;
  late InAppWebViewController webViewController1;
  late InAppWebViewController webViewController2;
  List<GlobalKey<ExamContentState>> webKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];

  List<String> listContent = [
    '11111111',
    '22222222',
    '33333333',
    '44444444',
    '55555555',
    '66666666'
  ];
  int? index;

  @override
  void initState() {
    super.initState();
    index = 0;
    pages = [
      ExamContent(
        content: listContent[index!],
        scrolHandler: (t) {},
        onWebViewCreated: (controller) {
          webViewController0 = controller;
        },
        key: webKeys[0],
      ),
      ExamContent(
        content: listContent[index!],
        scrolHandler: (t) {},
        onWebViewCreated: (controller) {
          webViewController1 = controller;
        },
        key: webKeys[1],
      ),
      ExamContent(
        content: listContent[index!],
        scrolHandler: (t) {},
        onWebViewCreated: (controller) {
          webViewController2 = controller;
        },
        key: webKeys[2],
      )
    ];

    _currentPage = widget.initialPage ?? 0;

    _controllers = List.generate(
        pages!.length,
        (i) => AnimationController(
              vsync: this,
              duration: widget.duration ?? Duration(milliseconds: 300),
              lowerBound: 0,
              upperBound: 1,
              value: i == _currentPage ? 0.5 : (i > _currentPage ? 1 : 0),
            ));

    _positions = _controllers!
        .map((controller) => Tween(begin: Offset(-1, 0), end: Offset(1, 0))
            //.chain(CurveTween(curve: Curves.easeInCubic))
            .animate(controller))
        .toList();
  }

  bool get hasNext => (_currentPage < pages!.length - 1);
  bool get hasPrevious => (_currentPage > 0);

  void setPage(int page) {
    assert(page >= 0 || page < pages!.length);
    while (_currentPage < page) next();
    while (_currentPage > page) previous();
  }

  void next() {
    if (index == listContent.length - 1) {
      // widget.onFinished!();
      return;
    }
    if (index == 0) {
      // webKeys[1].currentState!.updateData(listContent[index!]);
      webKeys[2].currentState!.updateData(listContent[index! + 1]);
    } else {
      webKeys[0].currentState!.updateData(listContent[index! - 1]);
      webKeys[2].currentState!.updateData(listContent[index! + 1]);
    }

    Widget tmpPage = pages![0];
    pages![0] = pages![1];
    pages![1] = pages![2];
    pages![2] = tmpPage;
    GlobalKey<ExamContentState> tmpWebKey = webKeys[0];
    webKeys[0] = webKeys[1];
    webKeys[1] = webKeys[2];
    webKeys[2] = tmpWebKey;
    _currentPage -= 1;
    _controllers = List.generate(
        pages!.length,
        (i) => AnimationController(
              vsync: this,
              duration: widget.duration ?? Duration(milliseconds: 300),
              lowerBound: 0,
              upperBound: 1,
              value: i == _currentPage ? 0.5 : (i > _currentPage ? 1 : 0),
            ));

    _positions = _controllers!
        .map((controller) => Tween(begin: Offset(-1, 0), end: Offset(1, 0))
            //.chain(CurveTween(curve: Curves.easeInCubic))
            .animate(controller))
        .toList();

    _controllers![_currentPage].animateTo(0);
    _controllers![_currentPage + 1].animateTo(0.5);
    setState(() {
      // print(listContent[index! + 1]);
      _currentPage += 1;
    });
    if (index! < listContent.length - 1) {
      index = index! + 1;
    }
  }

  void previous() {
    if (index == 0) {
      // webKeys[1].currentState!.updateData(listContent[index!]);
      webKeys[2].currentState!.updateData(listContent[index! + 1]);
      return;
    } else {
      if (index == listContent.length - 1) {
        webKeys[0].currentState!.updateData(listContent[index! - 1]);
        //  webKeys[1].currentState!.updateData(listContent[index!]);
      } else {
        webKeys[0].currentState!.updateData(listContent[index! - 1]);
        webKeys[2].currentState!.updateData(listContent[index! + 1]);
      }
    }

    //  if (!hasPrevious) return;
    Widget tmpPage = pages![0];
    pages![0] = pages![2];
    pages![2] = pages![1];
    pages![1] = tmpPage;
    GlobalKey<ExamContentState> tmpWebKey = webKeys[0];
    webKeys[0] = webKeys[2];
    webKeys[2] = webKeys[1];
    webKeys[1] = tmpWebKey;
    _currentPage += 1;
    _controllers = List.generate(
        pages!.length,
        (i) => AnimationController(
              vsync: this,
              duration: widget.duration ?? Duration(milliseconds: 300),
              lowerBound: 0,
              upperBound: 1,
              value: i == _currentPage ? 0.5 : (i > _currentPage ? 1 : 0),
            ));

    _positions = _controllers!
        .map((controller) => Tween(begin: Offset(-1, 0), end: Offset(1, 0))
            //.chain(CurveTween(curve: Curves.easeInCubic))
            .animate(controller))
        .toList();

    _controllers![_currentPage].animateTo(1);
    _controllers![_currentPage - 1].animateTo(0.5);
    setState(() {
      _currentPage -= 1;
    });
    if (index! > 0) {
      index = index! - 1;
    }
  }

  @override
  void dispose() {
    _controllers!.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: pages!
          .asMap()
          .map((i, page) => MapEntry(
              i,
              SlideTransition(
                position: _positions![i],
                child: page,
              )))
          .values
          .toList(),
    );
  }
}
