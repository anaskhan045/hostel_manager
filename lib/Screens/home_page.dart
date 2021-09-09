import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_manager/Screens/all_students_screen.dart';
import 'package:hostel_manager/Screens/finance_screen.dart';
import 'package:hostel_manager/Screens/rooms_screen.dart';
import 'package:hostel_manager/Screens/student_data_screen.dart';
import 'package:hostel_manager/widgets/controller.dart';
import 'package:hostel_manager/widgets/database_helper.dart';
import 'package:hostel_manager/widgets/form.dart';
import 'package:hostel_manager/widgets/hotel_data_sample.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int stuId;

  DatabaseHelper dbHelper = DatabaseHelper();
  final Telephony telephony = Telephony.instance;
  static const sheetUrl =
      'https://docs.google.com/spreadsheets/d/1mi61v2g_dYLEP9US6jQ6PJ-zgtyZsl9fR684DeyMN4k/edit?usp=sharing';

  List<StudentData> studentData = [];
  List<FeeData> feeData = [];
  List<RoomData> roomData = [];
  List<String> stuPhoneNumbers = [];
  List<String> unPaidNumbers = [];

  List<int> stuIds = [];
  List<int> stuPaidIds = [];
  int presentStu = 0;
  int totalSeats = 0;
  String selectedMonth;

  Future<void> getData() async {
    studentData = [];
    feeData = [];
    studentData = await dbHelper.getAllStudentsData();
    feeData = await dbHelper.getFeeData('sDate', selectedMonth);
    roomData = await dbHelper.getAllRoomData();
    if (roomData.isNotEmpty) {
      totalSeats = 0;
      for (int i = 0; i < roomData.length; i++) {
        totalSeats = totalSeats + roomData[i].roomCapacity;
      }
    } else {
      totalSeats = 0;
    }

    if (studentData.isNotEmpty) {
      stuIds = [];
      stuPhoneNumbers = [];
      unPaidNumbers = [];
      presentStu = studentData.length;

      for (int i = 0; i < studentData.length; i++) {
        stuIds.add(studentData[i].stuId);
        stuPhoneNumbers.add(studentData[i].stuPhone);
        if (studentData[i].feeStatus == 'Unpaid') {
          unPaidNumbers.add(studentData[i].stuPhone);
        }
      }
      setState(() {});
    } else {
      setState(() {
        presentStu = 0;
      });
    }
    if (feeData.isEmpty) {
      stuPaidIds = [];
      for (int i = 0; i < studentData.length; i++) {
        await dbHelper.updateStudent(
            'feeStatus', 'Unpaid', studentData[i].stuId);
      }
    } else {
      stuPaidIds = [];
      for (int i = 0; i < feeData.length; i++) {
        stuPaidIds.add(feeData[i].stuId);
      }

      List<int> unPaidIds =
          stuIds.toSet().difference(stuPaidIds.toSet()).toList();

      for (int j = 0; j < unPaidIds.length; j++) {
        await dbHelper.updateStudent('feeStatus', 'Unpaid', unPaidIds[j]);

        _updateStudent(unPaidIds[j]);
      }
    }
  }

  void _updateStudent(int id) {
    UpdateForm updateForm = UpdateForm(
      stuId: id,
      value: 'Unpaid',
      choose: 'updateFeeStatus',
    );
    // 'updateFeeStatus'
    FormController formController = FormController((String response) {});
    formController.updateForm(updateForm, 1);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedMonth = DateFormat('yMMMM').format(DateTime.now());
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff141026),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 15.0, top: 10.0),
                decoration: BoxDecoration(
                  color: Color(0xff251e37),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.only(
                    bottom: 30.0, left: 0.0, right: 0.0, top: 20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'TOTAL',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            Text(
                              'SEATS',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '$totalSeats',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 34.0),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'RESERVED',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            Text(
                              'SEATS',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '$presentStu',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 34.0),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'AVAILABLE',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            Text(
                              'SEATS',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '${totalSeats - presentStu}',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 34.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: [
                      GestureDetector(
                        child: buildContainer(
                            'Finance', CupertinoIcons.money_dollar_circle_fill),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FinanceScreen()));
                        },
                      ),
                      GestureDetector(
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: true, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Color(0xff141026),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  title: Text(
                                    'Enter Student ID',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: TextField(
                                    onSubmitted: (value) {
                                      stuId = int.parse(value);
                                      if (stuIds.contains(stuId)) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StudentDataScreen(
                                                      stuId: stuId,
                                                    )));
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                'No student found with ID:$stuId',
                                            textColor: Colors.red,
                                            fontSize: 18.0,
                                            gravity: ToastGravity.TOP);
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    style: TextStyle(
                                        fontSize: 30.0, color: Colors.white),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white10,
                                    ),
                                    autofocus: true,
                                    // controller: controller,

                                    onChanged: (newValue) {
                                      stuId = int.parse(newValue);
                                    },
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        'CANCEL',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_sharp,
                                        color: Colors.blue,
                                        size: 30.0,
                                      ),
                                      onPressed: () async {
                                        if (stuIds.contains(stuId)) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudentDataScreen(
                                                        stuId: stuId,
                                                      )));
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'No student found with ID:$stuId',
                                              fontSize: 18.0,
                                              textColor: Colors.red,
                                              gravity: ToastGravity.TOP);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            ).whenComplete(() {
                              getData();
                            });
                          },
                          child: buildContainer('Pay Fee', Icons.payments)),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllStudentsScreen())).whenComplete(() {
                              getData();
                            });
                          },
                          child: buildContainer('Students', Icons.people_alt)),
                      GestureDetector(
                        child: buildContainer(
                            'Rooms', CupertinoIcons.bed_double_fill),
                        onTap: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RoomsScreen()))
                              .whenComplete(() {
                            getData();
                          });
                        },
                      ),
                      GestureDetector(
                        child: buildContainer(
                          'Send  Message\n(All)',
                          Icons.send_to_mobile,
                        ),
                        onTap: () async {
                          if (stuPhoneNumbers.isNotEmpty) {
                            await telephony.sendSmsByDefaultApp(
                              to: stuPhoneNumbers.join(','),
                              message:
                                  "AOA This Message is From Bangash Boys Hostel",
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: 'No Student available for now!',
                                textColor: Colors.red,
                                fontSize: 18.0,
                                gravity: ToastGravity.CENTER);
                          }
                        },
                      ),
                      GestureDetector(
                        child: buildContainer(
                            'Send\nMessage\n(Unpaid)', Icons.send_to_mobile),
                        onTap: () async {
                          if (unPaidNumbers.isNotEmpty) {
                            await telephony.sendSmsByDefaultApp(
                              to: unPaidNumbers.join(','),
                              message:
                                  "AOA This Message is From Bangash Boys Hostel",
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: 'No  Unpaid Students available for now!',
                                textColor: Colors.red,
                                fontSize: 18.0,
                                gravity: ToastGravity.CENTER);
                          }
                        },
                      ),
                      GestureDetector(
                          onTap: () async {
                            if (await canLaunch(sheetUrl)) {
                              await launch(sheetUrl);
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Connection Error!\nPlease Try Again',
                                  textColor: Colors.red,
                                  fontSize: 18.0,
                                  gravity: ToastGravity.CENTER);
                            }
                          },
                          child:
                              buildContainer('Google\nSheets', Icons.wysiwyg)),
                      GestureDetector(
                          onTap: () => exit(0),
                          child: buildContainer(
                              'Exit', Icons.exit_to_app_outlined)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContainer(String title, IconData icon) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            icon,
            color: Colors.grey,
            size: 50.0,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0),
          ),
        ],
      ),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color(0xff251e37),
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }
}
