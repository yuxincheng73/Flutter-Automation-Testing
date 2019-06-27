# Flutter Integration Testing (Flutter Driver)

Provide insight on how to perform end-to-end automation testing of flutter applications via Flutter's Integration Testing packages. 

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

- Latest version of Flutter (2.3.0)
    - Run flutter doctor in terminal to check if you're current version of flutter is up to date.
```
flutter doctor
```
- Android SDK (29.0.0)
- Emulator or real device


### Installing

A step by step series of examples that tell you how to get a development env running

Add the Flutter Driver dependency in pubspec.yaml
```
dev_dependencies:
  flutter_driver:
    sdk: flutter
  test: any
  ```

Create a new folder called test_driver. Create two new files inside the folder called app.dart & app_test.dart. The "_test" notation is necessary. The app.dart file is to instantiate the testing module. The app_test.dart file contains the actual test code you want to run. Folder structure should look like this:
```
test_driver
    -> app.dart
    -> app_test.dart
```

Import driver_extension & main.dart in app.dart
```
import 'package:flutter_driver/driver_extension.dart';
import 'package:path_to_main/main.dart' as app;
```

The main function of app.dart should simply look like:
```
void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  app.main();
}
```

Import flutter_driver.dart and test.dart in app_test.dart
```
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
```

The main function of app_test.dart is often wrapped in a group; indicating a group of tests. The FlutterDriver class is then initialized. We first have to connect the FlutterDriver in setUpAll function and unconnect it after the tests are complete in tearDownAll function. Then the actual tests are written inside the test function.  

```
void main() {
  group('Platform Design', () {

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

    //test cases
    test('start by creating a new goal', () async {
        //do some test
    });
  }
}
```

## Writing the Tests
Every action is executed through the driver class. The driver class already has many prebuilt methods: https://api.flutter.dev/flutter/flutter_driver/FlutterDriver-class.html

Some common methods include:
```
driver.tap
driver.enterText
driver.getText
driver.scrollIntoView
```

In order to perform an action on a widget, you must find the widget via commonFinders. There are several prebuilt find methods: https://api.flutter.dev/flutter/flutter_driver/CommonFinders-class.html

Some common methods include:
```
find.byValueKey('string')
find.byTooltip('string')
find.text('string')
```

If you intend to use find.byValueKey or find.byTooltip, make sure to have set those properties on the element/object you're trying to target. For instance:

```
floatingActionButton: FloatingActionButton(
    key: Key('string'),
    tooltip: 'string',
),
```

The general syntax for a test looks like:
```
test('description of action', () async {
    await driver.tap(find.byValueKey('string'));
});
```
## Running the tests

Navigate to the root project folder. To run the test, simply type in terminal:

```
flutter drive --target=test_driver/app.dart
```

## Example Test

The following tests were conducted on this flutter application found on github: https://github.com/urmilshroff/goalkeeper

You can view this test here: https://github.com/yuxincheng73/Flutter-Automation-Testing

## Useful Notes

To verify information regarding an element/object, the "expect" function can be used. It usually takes in two variables: "actual" & "matcher". It compares the actual element/object to the supposed information.
The "expect" method will either succeed and proceed to the next set of tests or throw an error. For example, to verify the information stored in a Text element:

```
expect(await driver.getText(find.byValueKey('string')), 'supposed_string');
```

The tests often execute extremely fast, providing insufficient time for the person to view. It is useful to add a delay for every action.

```
await new Future.delayed(const Duration(seconds: 3));
```

The driver.getText method as of now only works for "Text" type and not for "TextField" or "TextFormField". So if the targeted element/object is of type "Textfield", this following line of code will generate an error:
```
await driver.getText(find.byValueKey('string'));
```

## Concluding Statement

As Flutter is still relativity new, there is still a limitation on the types of tests you can perform. There should be many updates coming in the upcoming future to bringforth more abundance of testing tools. So be on the lookout!

———————————————————————————————————————————————————————————————

# Flutter Widget Testing (Flutter Test)

Provide insight on how to perform widget automation testing of flutter applications. Useful for testing widget functionalities prior to integration tests. 

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

- Latest version of Flutter (2.3.0)
    - Run flutter doctor in terminal to check if you're current version of flutter is up to date.
```
flutter doctor
```
- Android SDK (29.0.0)

### Installing

A step by step series of examples that tell you how to get a development env running

Add the Flutter Test dependency in pubspec.yaml (should be there by default)
```
dev_dependendices:
  flutter_test:
    sdk: flutter
```

Create a folder called "test" and add a file called "widget_test.dart" (name of file can be anything)
```
-> test
  -> widget_test.dart
```

Import two files into widget_test.dart
```
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
```

Although the following step is not mandatory, but ideally it is safer as occassionally, flutter throws an error if you directly pump the widget class. Create a separate class that essentially wraps the widget class you're trying to test.
```
class MakeTestableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Test Wrapper',
      home: Widget_Class_To_Be_Tested(),
    );
  }
}
```

So when pumping the widget, it would look like
```
tester.pumpWidget(MakeTestableWidget());
```

## Writing Test Cases

Similar to the "test()" function of integration tests, here it is "testWidgets()". Each testcase is wrapped inside testWidgets(). The WidgetTester tester is also equivalent to the FlutterDriver driver of integration testing. 
```
testWidget('description of testcase', (WidgetTester tester) async {
  //write tests
});
```

Each testcase must begin with a tester.pumpWidget()
```
testWidget('description of testcase', (WidgetTester tester) async {
  //to initialize the widget by pumping
  tester.pumpWidget(name_of_widgetclass());
});
```

Subsequent testing logic & code is similar to that of the integration testing. There are several builtin commands. 

The Finder class is used to locate the element/object. The syntax is slightly different than that of integration testing. Check out the Finder methods: https://api.flutter.dev/flutter/flutter_test/CommonFinders-class.html
```
find.byKey(Key('string'));
```

The WidgetTester class has many prebuilt methods to perform actions on the widget. Check out the WidgetTester methods: https://api.flutter.dev/flutter/flutter_test/WidgetTester-class.html

Some common methods include
```
tester.pump()
tester.tap()
tester.drag()
```

It is also good practice to use the "expect()" functionality to verify the current state of the widget. For example right after a toggle of a button, you can verify that the new element is present in the frame and the old element has disappeared. The keywords findsOneWidget and findsNothing are useful to identify whether objects are present or not. 

```
tester.tap(find.byKey(Key('toggle_button')));
expect(find.byKey('new_element'), findsOneWidget);
expect(find.byKey('old_element'), findsNothing);
```
## Examples


## Useful Notes

For every action performed that updates the UI should be followed with a tester.pump() to force a frame redraw as it doesn't redraw itself. For example, after a tap action:
```
tester.tap(find.byKey(Key('string')));
tester.pump();
```

Sometimes the WidgetTester tester class is unable to perform the desired actions. In that case, you should force the action. For instance, you're unable to tap on the element,
```
tester.tap(find.byKey(Key('string')));
```
then you could first find the element and then call its methods manually
```
IconButton toggle = tester.widget(find.byKey(Key('toggle_button')));
toggle.onPressed();
```

## Concluding Statement

Although Flutter Widget test is to test the functionalities of individual widgets, thereby less complete than Flutter's Integration test, however, it possesses more actions such as dragging, fling, press, getCenter, etc. 