import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_manager/Screens/add_fee_screen.dart';
import 'package:hostel_manager/widgets/controller.dart';
import 'package:hostel_manager/widgets/database_helper.dart';
import 'package:hostel_manager/widgets/form.dart';
import 'package:hostel_manager/widgets/hotel_data_sample.dart';
import 'package:telephony/telephony.dart';

class StudentDataScreen extends StatefulWidget {
  final int stuId;
  StudentDataScreen({this.stuId});
  @override
  _StudentDataScreenState createState() => _StudentDataScreenState();
}

class _StudentDataScreenState extends State<StudentDataScreen>
    with TickerProviderStateMixin {
  int reservedSeats = 0;
  String stuName = '';
  int stuId;
  String stuCNIC = '';
  String stuPhone = '';
  String stuInst = '';
  String stuAddress = '';
  int admFee = 0;
  int securityFee = 0;
  int remaining = 0;
  String stuRoom = '';
  String admMonth = '';
  String feeStatus = '';

  DatabaseHelper dbHelper = DatabaseHelper();
  final Telephony telephony = Telephony.instance;

  int sFloorIndex = 0;

  @override
  void initState() {
    super.initState();
    stuId = widget.stuId;
    getData();
  }

  List<StudentData> studentData = [];
  List<FeeData> feeData = [];
  Future<void> getData() async {
    studentData = await dbHelper.getStudentsData('stuId', widget.stuId);
    feeData = await dbHelper.getFeeData('stuId', widget.stuId);
    remaining = 0;
    if (studentData.isNotEmpty) {
      setState(() {
        feeStatus = studentData[0].feeStatus;

        stuName = studentData[0].stuName;
        stuCNIC = studentData[0].stuCNIC;
        stuPhone = studentData[0].stuPhone;
        stuInst = studentData[0].stuInst;
        stuAddress = studentData[0].stuAddress;
        admFee = studentData[0].admission;
        securityFee = studentData[0].security;
        stuId = studentData[0].stuId;
        stuRoom = studentData[0].stuRoom;
        admMonth = studentData[0].admMonth;
        remaining = studentData[0].remaining;
      });
    }
  }

  void _updateStudent(var value, String choose) {
    UpdateForm updateForm = UpdateForm(
      stuId: stuId,
      value: value,
      choose: choose,
    );
    // 'updateFeeStatus'
    FormController formController = FormController((String response) {
      if (response == FormController.STATUS_SUCCESS) {
        //
        _showSnackbar("FeeStatus Updated  Successfully", Colors.green);
      } else {
        _showSnackbar("Error Occurred!", Colors.red);
      }
    });

    _showSnackbar("Updating FeeStatus", Colors.blue);

    // Submit 'feedbackForm' and save it in Google Sheet

    formController.updateForm(updateForm, 0);
  }

  void _updateFeeForm(int fee, String sDate) {
    UpdateFeeForm updateFeeForm = UpdateFeeForm(
      stuId: stuId,
      fee: fee,
      sDate: sDate,
      choose: 'updateFee',
    );

    FormController formController = FormController((String response) {
      if (response == FormController.STATUS_SUCCESS) {
        //
        _showSnackbar("Fee Updated  Successfully", Colors.green);
      } else {
        _showSnackbar("Error Occurred!", Colors.red);
      }
    });

    _showSnackbar("Updating Fee", Colors.blue);

    // Submit 'feedbackForm' and save it in Google Sheet

    formController.updateFeeForm(updateFeeForm);
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showSnackbar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff141026),
      floatingActionButton: CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 30.0,
        child: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: Color(0xff251e37),
          child: Icon(
            Icons.add,
            size: 45.0,
            color: Colors.white,
          ),
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => AddFee(
                      stuId: stuId,
                      stuName: stuName,
                    )).whenComplete(() async {
              await getData();
              _updateStudent(feeStatus, 'updateFeeStatus');
            });
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Text(
                    stuName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34.0,
                      color: Colors.white,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await telephony.openDialer(stuPhone);
                        },
                        child: Icon(
                          Icons.phone,
                          color: Colors.blue,
                          size: 30.0,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await telephony.sendSmsByDefaultApp(
                              to: '$stuPhone',
                              message: "Hello $stuName i hpe u r doing well!");
                        },
                        child: Icon(
                          Icons.message_outlined,
                          color: Colors.blue,
                          size: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Text(
                    'STUDENT ID',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  title: Text(
                    '$stuId',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Text(
                    'STUDENT ROOM',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  title: Text(
                    stuRoom,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Text(
                    'PHONE',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  title: Text(
                    stuPhone,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Text(
                    'CNIC',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  title: Text(
                    stuCNIC,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Text(
                    'INSTITUTE',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  title: Text(
                    stuInst,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Text(
                    'ADDRESS',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  title: Text(
                    stuAddress,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Text(
                    'ADMITTED IN',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  title: Text(
                    admMonth,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Text(
                    'ADMISSION PAID',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  title: Text(
                    '$admFee',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            title: Text('Do you want to update Admission Fee?'),
                            content: TextField(
                              style: TextStyle(
                                fontSize: 30.0,
                              ),
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                                labelText:
                                    'PLEASE UPDATE YOUR ADMISSION FEE HERE!',
                                labelStyle: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              autofocus: true,
                              // controller: controller,
                              keyboardType: TextInputType.numberWithOptions(),
                              onChanged: (newValue) {
                                admFee = int.parse(newValue);
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'UPDATE',
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  await dbHelper
                                      .updateStudent('admission', admFee, stuId)
                                      .whenComplete(() {
                                    _updateStudent(admFee, 'updateAdm');
                                  }).whenComplete(() {
                                    Navigator.of(context).pop();
                                    getData();
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
                ListTile(
                  leading: Text(
                    'SECURITY PAID',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  title: Text(
                    '$securityFee',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            title: Text('Do you want to update Security Fee?'),
                            content: TextField(
                              style: TextStyle(
                                fontSize: 30.0,
                              ),
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                                labelText:
                                    'PLEASE UPDATE YOUR SECURITY FEE HERE!',
                                labelStyle: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              autofocus: true,
                              // controller: controller,
                              keyboardType: TextInputType.numberWithOptions(),
                              onChanged: (newValue) {
                                securityFee = int.parse(newValue);
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'UPDATE',
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  await dbHelper
                                      .updateStudent(
                                          'security', securityFee, stuId)
                                      .whenComplete(() {
                                    _updateStudent(securityFee, 'updateSec');
                                  }).whenComplete(() => {
                                            Navigator.of(context).pop(),
                                            getData(),
                                          });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
                ListTile(
                  leading: Text(
                    'TOTAL REMAINING',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  title: Text(
                    '$remaining',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            title: Text('Remaining Amount?'),
                            content: TextField(
                              style: TextStyle(
                                fontSize: 30.0,
                              ),
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                                labelText:
                                    'PLEASE UPDATE REMAINING AMOUNT HERE!',
                                labelStyle: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              autofocus: true,
                              // controller: controller,
                              keyboardType: TextInputType.numberWithOptions(),
                              onChanged: (newValue) {
                                remaining = int.parse(newValue);
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'UPDATE',
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  await dbHelper
                                      .updateStudent(
                                          'remaining', remaining, stuId)
                                      .whenComplete(() {
                                    _updateStudent(remaining, 'updateRem');
                                  }).whenComplete(() {
                                    Navigator.of(context).pop();
                                    getData();
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: FutureBuilder(
                        future: dbHelper.getFeeData('stuId', stuId),
                        initialData: [],
                        builder: (context, snapShot) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapShot.data.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 0.0),
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          'MONTH',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          snapShot
                                              .data[(snapShot.data.length - 1) -
                                                  index]
                                              .sDate,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'PIAD',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Rs.',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.blue),
                                            ),
                                            Text(
                                              '${snapShot.data[(snapShot.data.length - 1) - index].fee}',
                                              style: TextStyle(
                                                  fontSize: 26.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                        size: 30.0,
                                      ),
                                      onPressed: () async {
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible:
                                              true, // user must tap button!
                                          builder: (BuildContext context) {
                                            int newFee;
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0))),
                                              title: Text(
                                                  'Do yo want to Update ${snapShot.data[(snapShot.data.length - 1) - index].sDate} Fee?'),
                                              content: TextField(
                                                style: TextStyle(
                                                  fontSize: 30.0,
                                                ),
                                                decoration: InputDecoration(
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(),
                                                  ),
                                                ),
                                                autofocus: true,
                                                // controller: controller,
                                                keyboardType: TextInputType
                                                    .numberWithOptions(),
                                                onChanged: (newValue) {
                                                  newFee = int.parse(newValue);
                                                },
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text(
                                                    'CANCEL',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.deepPurple),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    'UPDATE',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.deepPurple,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () async {
                                                    if (newFee != null) {
                                                      await dbHelper
                                                          .updateFee(
                                                              newFee,
                                                              stuId,
                                                              snapShot
                                                                  .data[(snapShot
                                                                              .data
                                                                              .length -
                                                                          1) -
                                                                      index]
                                                                  .sDate)
                                                          .whenComplete(() {
                                                        _updateFeeForm(
                                                            newFee,
                                                            snapShot
                                                                .data[(snapShot
                                                                            .data
                                                                            .length -
                                                                        1) -
                                                                    index]
                                                                .sDate);
                                                        Navigator.of(context)
                                                            .pop();
                                                        getData();
                                                      });
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Please provide valid value for new Fee',
                                                          textColor:
                                                              Colors.redAccent,
                                                          gravity:
                                                              ToastGravity.TOP);
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 5.0),
                                  margin: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xff251e37),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                );
                              });
                        })),
                SizedBox(
                  height: 80.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)

  // More advanced TableCalendar configuration (using Builders & Styles)

  TextEditingController listController;
}
