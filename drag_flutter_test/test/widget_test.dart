import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dragger/main.dart';

void main() {

  testWidgets('Drag Test', (WidgetTester tester) async {
    await tester.pumpWidget(MakeTestableWidget());

    //drag the second green box from point A to B
    await tester.drag(find.byKey(Key('box 2')), Offset(500.0, 0.0));

    //add delay
    await tester.pump(new Duration(seconds: 5));
    await tester.pumpAndSettle();    
  });
}

class MakeTestableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyApp(),
    );
  }
}