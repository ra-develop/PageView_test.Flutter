
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Example()
      )
    );
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
    _listScrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    if (_listScrollController.hasClients && 
        _listScrollController.position.context.storageContext != null) {
      final RenderBox renderBox = _listScrollController.position.context.storageContext.findRenderObject();
      if (renderBox.paintBounds.shift(renderBox.localToGlobal(Offset.zero)).contains(details.globalPosition)) {
        _activeScrollController = _listScrollController;
        _drag = _activeScrollController.position.drag(details, _disposeDrag);
        return;
      }
    }
    _activeScrollController = _pageController;
    _drag = _pageController.position.drag(details, _disposeDrag);
  }


    // print('StartReconizing:');
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

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_activeScrollController == _listScrollController 
    // && (details.primaryDelta < 0) 
    && (_activeScrollController.position.pixels.roundToDouble() >= _activeScrollController.position.maxScrollExtent.roundToDouble()
    || _activeScrollController.position.pixels <0 )) {
      _activeScrollController = _pageController;
      _drag?.cancel();
      _drag = _pageController.position.drag(
        DragStartDetails(
          globalPosition: details.globalPosition,
          localPosition: details.localPosition
        ),
        _disposeDrag
      );
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

  Drag _handlerMultiDrag(Offset offset) {
    print(offset);
  }


  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
    // RawGestureDetector(
    //   gestures: <Type, GestureRecognizerFactory>{
    //     PanGestureRecognizer: GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
    //       // VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
    //       () => PanGestureRecognizer(),
    //       // () => VerticalDragGestureRecognizer(),
    //       (PanGestureRecognizer instance) {
    //       // (VerticalDragGestureRecognizer instance) {
    //         instance 
    //           // .. onStart = _handlerMultiDrag
    //           ..onStart = _handleDragStart
    //           ..onUpdate = _handleDragUpdate
    //           ..onEnd = _handleDragEnd
    //           ..onCancel = _handleDragCancel
    //           ;
    //       }
    //       )
    //   },

      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      onVerticalDragCancel: _handleDragCancel,

      // onHorizontalDragStart: _handleDragStart,
      // onHorizontalDragUpdate: _handleDragUpdate,
      // onHorizontalDragEnd: _handleDragEnd,
      // onHorizontalDragCancel: _handleDragCancel,

      behavior: HitTestBehavior.opaque,
      child: 
      PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return PageRowWidget(verticalIndex: index,);
        },
        itemCount: 10,
      )
    );
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
  Widget build(BuildContext context) {
    return 
    PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal, 
        itemBuilder: (BuildContext context, int index) { 
          if (index == 1 || index == 3) {
            return MyListWidget(verticalIndex: widget.verticalIndex, hotizontalIndex: index,);
          }
          return MyWidget(verticalIndex: widget.verticalIndex, hotizontalIndex: index,);
        },
        itemCount: 5,
      );
  }
}


class MyWidget extends StatefulWidget {
  final int verticalIndex;
  final int hotizontalIndex;

  const MyWidget({Key key, this.verticalIndex, this.hotizontalIndex}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            MyBox(darkGreen, height: 50),
          ],
        ),
        Row(
          children: [
            MyBox(lightGreen),
            MyBox(lightGreen),
          ],
        ),
        MyBox(mediumGreen, 
              text: 'Idexes: Vertical: ${widget.verticalIndex}, Horizontal: ${widget.hotizontalIndex}'),
        Row(
          children: [
            MyBox(lightGreen, height: 200),
            MyBox(lightGreen, height: 200),
          ],
        ),
      ],
    );
  }
}

class MyListWidget extends StatefulWidget {

  final int verticalIndex;
  final int hotizontalIndex;

  const MyListWidget({Key key, this.verticalIndex, this.hotizontalIndex}) : super(key: key);

  @override
  _MyListWidgetState createState() => _MyListWidgetState();
}

class _MyListWidgetState extends State<MyListWidget> {
  @override
  Widget build(BuildContext context) {
    return 
    ListView(
              controller: _listScrollController,
            physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        Row(
          children: [
            MyBox(darkBlue, 
            text: "ListViewWidget",
            height: 50),
          ],
        ),
        Row(
          children: [
            MyBox(lightBlue),
            MyBox(lightBlue),
          ],
        ),
        MyBox(mediumBlue, 
              text: 'Idexes: Vertical: ${widget.verticalIndex}, Horizontal: ${widget.hotizontalIndex}'),
        Row(
          children: [
            MyBox(lightBlue),
            MyBox(lightBlue),
          ],
        ),
        Row(
          children: [
            MyBox(lightBlue),
            MyBox(lightBlue),
          ],
        ),
                Row(
          children: [
            MyBox(lightBlue),
            MyBox(lightBlue),
          ],
        ),
                Row(
          children: [
            MyBox(lightBlue),
            MyBox(lightBlue),
          ],
        ),
                Row(
          children: [
            MyBox(lightBlue),
            MyBox(lightBlue),
          ],
        ),
      ],
    );
  }
}


const lightBlue = Color(0xff00bbff);
const mediumBlue = Color(0xff00a2fc);
const darkBlue = Color(0xff0075c9);

final lightGreen = Colors.green.shade300;
final mediumGreen = Colors.green.shade600;
final darkGreen = Colors.green.shade900;


class MyBox extends StatelessWidget {
  final Color color;
  final double height;
  final String text;

  MyBox(this.color, {this.height, this.text});

  @override
  Widget build(BuildContext context) {
    return 
    Expanded(
      flex: 1,
      child: 
      Container(
        margin: EdgeInsets.all(10),
        color: color,
        height: (height == null) ? 150 : height,
        child: (text == null)
            ? null
            : Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize:25,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
