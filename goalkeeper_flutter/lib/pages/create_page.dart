import 'dart:async';
import 'dart:ui';

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import "package:goalkeeper/utils/colors.dart";
import "package:goalkeeper/utils/database_helper.dart";
import "package:goalkeeper/utils/goal.dart";
import "package:goalkeeper/utils/public.dart";

class CreateGoal extends StatefulWidget {
  final GoalClass goal;

  CreateGoal(this.goal); //constructor

  @override
  State<StatefulWidget> createState() {
    return CreateGoalState(this.goal);
  }
}

class CreateGoalState extends State<CreateGoal> {
  DatabaseHelper helper = DatabaseHelper();

  GoalClass goal;

  bool isDeadlineSet = false;
  String buttonText = "ADD DEADLINE";

  TextEditingController inputGoalTitleController = TextEditingController();
  TextEditingController inputGoalBodyController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  CreateGoalState(this.goal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        backgroundColor: MyColors.purple,
        title: Text("New Goal",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22.0)),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                ),
                Hero(
                  tag: "",
                  child: Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/icon.png")))),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Center(
                  child: Text("New Goal",
                      style: TextStyle(
                          color: invertColors(context),
                          fontWeight: FontWeight.w700,
                          fontSize: 22.0)),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    color: invertColors(context),
                  ),
                  controller: inputGoalTitleController,
                  onChanged: (title) {
                    updateTitle();
                  },
                  key: Key('goal_title'),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: invertColors(context)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MyColors.purple),
                      ),
                      border: OutlineInputBorder(),
                      labelText: "Goal Title",
                      hintText: "What\'s your goal for today?",
                      labelStyle: TextStyle(
                        color: invertColors(context),
                      ),
                      hintStyle: TextStyle(
                        color: invertColors(context),
                      ),
                      contentPadding: const EdgeInsets.all(15.0)),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    color: invertColors(context),
                  ),
                  controller: inputGoalBodyController,
                  onChanged: (body) {
                    updateBody();
                  },
                  key: Key('goal_description'),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: invertColors(context)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MyColors.purple),
                      ),
                      border: OutlineInputBorder(),
                      labelText: "Description",
                      hintText: "Explain it in a few words",
                      labelStyle: TextStyle(
                        color: invertColors(context),
                      ),
                      hintStyle: TextStyle(
                        color: invertColors(context),
                      ),
                      contentPadding: const EdgeInsets.all(15.0)),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Theme(
                  key: Key('calendar'),
                  data: Theme.of(context).copyWith(
                      primaryColor: MyColors.purple,
                      accentColor: MyColors.yellow),
                  child: Builder(
                    builder: (context) => OutlineButton(
                          key: Key('calendar_highlight'),
                          child: Text("$buttonText",
                              style: TextStyle(
                                color: invertColors(context),
                                fontWeight: FontWeight.w500,
                              )),
                          onPressed: () {
                            pickDate(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          borderSide: BorderSide(color: MyColors.purple),
                          highlightedBorderColor: MyColors.yellow,
                          splashColor: MyColors.yellow,
                        ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveGoal();
        },
        key: Key('goal_add'),
        child: Icon(Icons.check),
        foregroundColor: MyColors.light,
        backgroundColor: MyColors.yellow,
        elevation: 3.0,
        heroTag: "fab",
      ),
    );
  }

  void updateTitle() {
    goal.title = inputGoalTitleController.text;
  }

  void updateBody() {
    goal.body = inputGoalBodyController.text;
  }

  void saveGoal() async {
    Navigator.pop(context);
    if (goal.title.length > 0) {
      if (goal.id == null) {
        await helper.createGoal(goal);
        await showWeeklyAtDayAndTime(goal.id, goal.title, goal.body);
        showSnackBar(context, "Goal created!");
      } else {
        await helper.updateGoal(goal);
        await showWeeklyAtDayAndTime(goal.id, goal.title, goal.body);
        showSnackBar(context, "Goal updated!");
      }
    }
  }

  void createNewDeadline() {
    pickDate(context);
  }

  Future<Null> pickDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: selectedDate.add(Duration(days: 3650)));
    if (picked != null) {
      selectedDate = picked;
      pickTime(context);
    }
  }

  Future<Null> pickTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      selectedTime = picked;

      setState(() {
        isDeadlineSet = true;
        buttonText = "EDIT DEADLINE";
      });

      showSnackBar(
          context,
          "Deadline set for ${selectedTime.hour}:${selectedTime.minute} on "
          "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}!");
    }
  }

  @override
  void initState() {
    super.initState();

    var initNotificationAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initNotificationIOS = new IOSInitializationSettings();
    var initNotificationSettings = new InitializationSettings(
        initNotificationAndroid, initNotificationIOS);

    flutterLocalNotificationsPlugin.initialize(initNotificationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload); //TODO: add goal edit page
    }
    Navigator.pop(context);
  }

  Future<void> showWeeklyAtDayAndTime(
      int id, String goalTitle, String goalBody) async {
    if (id == 0) {
      print("ID IS $id");
    }
    print("WRONG ID IS $id");
    var scheduledNotificationTime =
        Time(selectedTime.hour, selectedTime.minute, 0);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "goalNotificationChannelId",
        "Goal Deadlines",
        "Reminders to complete your goals in time",
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        icon: '@mipmap/ic_launcher',
        largeIcon: '@mipmap/ic_launcher',
        largeIconBitmapSource: BitmapSource.Drawable);

    var iosPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        "Reminder: $goalTitle",
        "Hope you're working on completing your goal!",
        Day.Wednesday,
        scheduledNotificationTime,
        platformChannelSpecifics);
  }
}
