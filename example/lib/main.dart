import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_page_gutter/flutter_page_gutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Axis axis = Axis.horizontal;
  double gap = 10;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            Container(
              alignment: Alignment.center,
              height: 200,
              child: DefaultPageController.builder(
                viewportFraction: 0.7,
                initialPage: 1,
                builder: (context, controller) {
                  return PageView.builder(
                    controller: controller,
                    scrollDirection: axis,
                    itemCount: 10,
                    itemBuilder: (context, index) => _buildItem(index),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.outlined(
                  onPressed: _reduceGap,
                  icon: Icon(Icons.remove_rounded),
                ),
                IconButton.outlined(
                  onPressed: _addGap,
                  icon: Icon(Icons.add_rounded),
                ),
              ],
            ),
            FilledButton(
              onPressed: _toggleDirection,
              child: Text('Switch direction'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    return PageGutter(
      index: index,
      gap: gap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).highlightColor),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: [Colors.black12, Colors.black26, Colors.black12],
          ),
        ),
        child: Center(
          child: Text(
            '$index',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              shadows: [
                Shadow(
                  color: Colors.white,
                  blurRadius: 0,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addGap() {
    setState(() => gap += 5);
  }

  void _reduceGap() {
    setState(() => gap = max(0, gap - 5));
  }

  void _toggleDirection() {
    setState(() {
      axis = axis == Axis.horizontal ? Axis.vertical : Axis.horizontal;
    });
  }
}
