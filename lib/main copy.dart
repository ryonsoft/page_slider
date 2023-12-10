import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_page_view.dart';

void main() {
  runApp(
    CupertinoApp(
      home: CupertinoPageScaffold(
        child: SafeArea(
          child: MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SliderPageTurnController _pageController;
  late SliderPageTurn _sliderPageTurn;

  @override
  void initState() {
    super.initState();

    _pageController = SliderPageTurnController();
    _sliderPageTurn = SliderPageTurn(
      controller: _pageController,
      cellSize: const Size(700, 400),
    );

    _pageController.animToPositionWidget(1,
        duration: Duration.zero); // Hiển thị trang 2
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _sliderPageTurn,
        Row(
          children: [
            TextButton(
                onPressed: () {
                  _pageController.animToLeftWidget(
                      duration: const Duration(milliseconds: 500));
                },
                child: const Text("trái")),
            TextButton(
                onPressed: () {
                  _pageController.animToRightWidget(
                      duration: const Duration(milliseconds: 500));
                },
                child: const Text("phải")),
          ],
        )
      ],
    );
  }
}
