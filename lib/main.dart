import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

// PageController _pageController;
ScrollController _listScrollController;
ScrollController _activeScrollController;
Drag _drag;

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(appBar: AppBar(), body: Example()));
  }
}

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  PageController _pageController;
  // ScrollController _listScrollController;
  // ScrollController _activeScrollController;
  // Drag _drag;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // _listScrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    // _listScrollController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    if (_listScrollController.hasClients &&
        _listScrollController.position.context.storageContext != null) {
        final RenderBox renderBox = _listScrollController
              .position.context.storageContext
              .findRenderObject();
        if (renderBox.paintBounds
              .shift(renderBox.localToGlobal(Offset.zero))
              .contains(details.globalPosition)) {
          print("_activeController is _listController");
          _activeScrollController = _listScrollController;
          _drag = _activeScrollController.position.drag(details, _disposeDrag);
          return;
        }
    }
    print("_activeController is _pageController");
    _activeScrollController = _pageController;
    _drag = _pageController.position.drag(details, _disposeDrag);
  }

  void _handleDragUpdate(DragUpdateDetails details) {


    // print('==================');
    // print("DragUpdateDetails:");
    // print(_activeScrollController == _pageController);
    // print('delta.direction: ${details.delta.direction}');
    // print('delta.distance: ${details.delta.distance}');
    // print('delta.distanceSquared: ${details.delta.distanceSquared}');
    // print('delta.isFinite: ${details.delta.isFinite}');
    // print('delta.isInfinite: ${details.delta.isInfinite}');
    // print('delta.dx ${details.delta.dx}');
    // print('delta.dy ${details.delta.dy}');
    // print("PrimaryDelta: ${details.primaryDelta}");
    // print('globalPosition: ${details.globalPosition}');
    // print(_activeScrollController.position.pixels.roundToDouble());
    // print(_activeScrollController.position.maxScrollExtent.roundToDouble());
    // print(_activeScrollController.position.minScrollExtent.roundToDouble());


    if (_activeScrollController == _listScrollController
        // && (details.primaryDelta < 0)
        &&
        (_activeScrollController.position.pixels.roundToDouble() >=
                _activeScrollController.position.maxScrollExtent
                    .roundToDouble()) 
                    ||
            (_activeScrollController.position.pixels <= _activeScrollController.position.minScrollExtent 
            && details.delta.dy > 0
            )
            ) {
      _activeScrollController = _pageController;
      _drag?.cancel();
      _drag = _pageController.position.drag(
          DragStartDetails(
              globalPosition: details.globalPosition,
              localPosition: details.localPosition),
          _disposeDrag);
    }
    _drag?.update(details);
  }

  void _handleDragEnd(DragEndDetails details) {
    _drag?.end(details);
  }

  void _handleDragCancel() {
    _drag?.cancel();
  }

  void _disposeDrag() {
    _drag = null;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragStart: _handleDragStart,
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        onVerticalDragCancel: _handleDragCancel,

        // onHorizontalDragStart: _handleDragStart,
        // onHorizontalDragUpdate: _handleDragUpdate,
        // onHorizontalDragEnd: _handleDragEnd,
        // onHorizontalDragCancel: _handleDragCancel,

        behavior: HitTestBehavior.opaque,
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return PageRowWidget(
              verticalIndex: index,
            );
          },
          itemCount: 10,
          pageSnapping: false,
        ));
  }
}

class PageRowWidget extends StatefulWidget {
  final int verticalIndex;

  const PageRowWidget({Key key, this.verticalIndex}) : super(key: key);

  @override
  _PageRowWidgetState createState() => _PageRowWidgetState();
}

class _PageRowWidgetState extends State<PageRowWidget> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // _listScrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    // _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        // if (Random().nextInt(1) == 0) {
        return MyListWidget(
          verticalIndex: widget.verticalIndex,
          hotizontalIndex: index,
        );
        // } else {
        // return MyWidget(verticalIndex: widget.verticalIndex, hotizontalIndex: index,);
        // }
      },
      itemCount: 5,
    );
  }
}

class MyListWidget extends StatefulWidget {
  final int verticalIndex;
  final int hotizontalIndex;

  const MyListWidget({Key key, this.verticalIndex, this.hotizontalIndex})
      : super(key: key);

  @override
  _MyListWidgetState createState() => _MyListWidgetState();
}

class _MyListWidgetState extends State<MyListWidget> {
  final int rngList = 1 + Random().nextInt(10);

  List<ElementOfList> listElements = [];

  final baseColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  @override
  void initState() {
    super.initState();
    // _pageController = PageController();
    _listScrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    // _pageController.dispose();
    _listScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < rngList; i++) {
      listElements.add(ElementOfList(color: baseColor));
    }
    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: baseColor.withOpacity(0.6),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 1))
          ],
        ),
        child: ListView(
          controller: _listScrollController,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Row(
              children: [
                MyBox(baseColor[300], text: "ListViewWidget", height: 50),
              ],
            ),
            Row(
              children: [
                MyBox(baseColor[300]),
                MyBox(baseColor[300]),
              ],
            ),
            Row(
              children: <Widget>[
                MyBox(baseColor[600],
                    text:
                        'Idexes: Vertical: ${widget.verticalIndex}, Horizontal: ${widget.hotizontalIndex}'),
              ],
            ),
            Column(
              children: listElements,
            ),
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class ElementOfList extends StatelessWidget {
  final color;

  const ElementOfList({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyBox(color[900]),
        MyBox(color[900]),
      ],
    );
  }
}

class MyBox extends StatelessWidget {
  final Color color;
  final double height;
  final String text;

  MyBox(this.color, {this.height, this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.all(10),
        color: color,
        height: (height == null) ? 150 : height,
        child: (text == null)
            ? null
            : Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
