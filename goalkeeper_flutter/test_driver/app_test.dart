// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
//import 'package:flutter_driver/src/common/geometry.dart';
import 'package:test/test.dart';
import 'dart:async';
import 'dart:math' as math;


void main() {

  group('Platform Design', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    //final cards = find.byValueKey('cards');

    FlutterDriver driver;
    final timeout = Duration(seconds: 3);

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    /* create new goal */

    test('start by creating a new goal', () async {
      //tap the plus button
      await driver.tap(find.byValueKey('create_goal'));
      await new Future.delayed(const Duration(seconds: 3));
    });

    test('tap on goal title', () async {
      //tap goal title text input field 
      await driver.tap(find.byValueKey('goal_title'));
      await new Future.delayed(const Duration(seconds: 3));
    });

    test('enter goal title', () async {
      //enter goal title in text input field 
      await driver.enterText('I have no goals :(');
      await new Future.delayed(const Duration(seconds: 3));
    });

    test('verify entered text', () async {
      //verify entered text
      // final SerializableFinder goalText = find.ByText('goal_title');
      // expect(goalText, isNotNull);
      final SerializableFinder goalText = find.text('I have no goals :(');
      print(goalText);
      
      // String word;
      // while (word == null || word.isEmpty) {
      //   word = await driver.getText(goalText);
      // }
      
    });

    test('tap on description', () async {
      //tap goal description text input field 
      await driver.tap(find.byValueKey('goal_description'));
      await new Future.delayed(const Duration(seconds: 3));
    });

    test('enter goal description', () async {
      //tap goal description text input field 
      await driver.enterText('HIHIHIHIHIHIIIIHIH');
      await new Future.delayed(const Duration(seconds: 3));
    });

    test('tap on add deadline button', () async {
      //tap on add deadline button
      await driver.tap(find.byValueKey('calendar'));
    });

    test('tap on specific date', () async {
      //tap on specific date
      await driver.tap(find.text('27'));
    });

    test('tap on OK button', () async {
      //tap on OK button
      await driver.tap(find.text('OK'));
    });

    test('tap on 5 oclock', () async {
      //tap on 5 oclock
      final SerializableFinder timepicker = find.bySemanticsLabel('time-picker-dial');
      await driver.waitFor(find.byValueKey('dialpad'));
      await driver.tap(find.text('7'));
      await new Future.delayed(const Duration(seconds: 3));
    });

    test('tap on 5 oclock', () async {
      //tap on 5 oclock
      await driver.tap(find.text('AM'));
      await new Future.delayed(const Duration(seconds: 3));
    });

    test('tap on OK button Again', () async {
      //tap on OK button Again
      await driver.tap(find.text('OK'));
    });

    test('tap on Save button', () async {
      //tap on Save button
      await driver.tap(find.byValueKey('goal_add'));
      await new Future.delayed(const Duration(seconds: 3));
    });

    /* edit an existing goal */
    test('tap on goal', () async {
      //tap an existing goal 
      await driver.tap(find.text('Goal #1'));
      await new Future.delayed(const Duration(seconds: 3));
    });

    test('tap on speed dial button', () async {
      //tap speed dial edit button
      await driver.tap(find.byTooltip('speed_dial'));
      await new Future.delayed(const Duration(seconds: 3));
    });

    test('tap on speed dial delete button', () async {
      //tap speed dial delete button 
      await driver.tap(find.byValueKey('speed_dial_child'));
      await new Future.delayed(const Duration(seconds: 3));
    });

    test('tap on DELETE button to confirm deletion', () async {
      //tap on DELETE button to confirm deletion
      await driver.tap(find.byValueKey('confirm_delete'));
      await new Future.delayed(const Duration(seconds: 3));
    });
  });
}

