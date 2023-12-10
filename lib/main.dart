import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'content.dart';
import 'page_slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<PageSliderState> _slider = GlobalKey();
  late InAppWebViewController webViewController1;
  late InAppWebViewController webViewController2;
  late InAppWebViewController webViewController3;
  List<String> listContent = [
    '11111111',
    '22222222',
    '33333333',
    '44444444',
    '55555555',
    '66666666'
  ];
  int currentIndex = 0;

  void initState() {
    super.initState();
  }

  Widget _card(String text) => Card(
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(100),
          child: Text(text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              )),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Page Slider Demo'),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            PageSlider(
              key: _slider,
              initialPage: 1,
              duration: Duration(milliseconds: 400),
              pages: <Widget>[
                ExamContent(
                  content: listContent[currentIndex],
                  scrolHandler: (t) {},
                  onWebViewCreated: (controller) {
                    webViewController1 = controller;
                    // webViewController1.loadData(
                    //     data: listContent[currentIndex == 0
                    //         ? listContent.length - 1
                    //         : currentIndex - 1]);
                  },
                ),
                ExamContent(
                  content: listContent[currentIndex + 1],
                  scrolHandler: (t) {},
                  onWebViewCreated: (controller) {
                    webViewController2 = controller;
                    // webViewController2.loadData(
                    //     data: listContent[currentIndex]);
                  },
                ),
                ExamContent(
                  content: listContent[currentIndex + 2],
                  scrolHandler: (t) {},
                  onWebViewCreated: (controller) {
                    // webViewController3 = controller;
                    // webViewController3.loadData(
                    //     data: listContent[currentIndex + 1]);
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    _slider.currentState!.previous();
                  },
                ),
                FloatingActionButton(
                  child: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    _slider.currentState!.next();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
