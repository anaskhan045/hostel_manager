import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_manager/widgets/controller.dart';
import 'package:hostel_manager/widgets/database_helper.dart';
import 'package:hostel_manager/widgets/form.dart';
import 'package:hostel_manager/widgets/hotel_data_sample.dart';
import 'package:intl/intl.dart';

class AddStudents extends StatefulWidget {
  final String stuRoom;
  AddStudents({this.stuRoom});
  @override
  _AddStudentsState createState() => _AddStudentsState();
}

class _AddStudentsState extends State<AddStudents> {
  String newStuName;
  String newStuCNIC;
  int newStuId;
  String newStuPhone;
  String newStuAddress;
  String newStuInst;
  int admissionFee = 0;
  int securityFee = 0;
  String admMonth = '';

  DatabaseHelper dbHelper = DatabaseHelper();
  List<StudentData> studentData = [];
  int reservedSeats;
  Future<void> getData() async {
    studentData = [];
    studentData = await dbHelper.getStudentsData('stuRoom', widget.stuRoom);

    if (studentData.isNotEmpty) {
      setState(() {
        reservedSeats = studentData.length;
      });
    } else {
      setState(() {
        reservedSeats = 0;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    admMonth = DateFormat('yMMMM').format(DateTime.now());
    getData();
  }

  void _submitForm() {
    StudentForm studentForm = StudentForm(
        stuId: newStuId,
        stuName: newStuName,
        stuPhone: newStuPhone,
        stuCNIC: newStuCNIC,
        stuInst: newStuInst,
        stuAddress: newStuAddress,
        stuRoom: widget.stuRoom,
        admMonth: admMonth,
        feeStatus: 'Unpaid',
        admission: admissionFee,
        security: securityFee,
        remaining: 0,
        choose: 'addStu');

    FormController formController = FormController((String response) {});

    formController.submitForm(studentForm);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: Color(0xff141026),
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Add New Student',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35.0,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: 5.0,
                ),
                child: Text(
                  'Student Name',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              TextField(
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
                autocorrect: true,
                style: TextStyle(color: Colors.white, fontSize: 22.0),
                onChanged: (value) {
                  newStuName = value;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white10,
                  filled: true,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: 5.0,
                ),
                child: Text(
                  'Student CNIC',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.numberWithOptions(),
                style: TextStyle(color: Colors.white, fontSize: 22.0),
                onChanged: (value) {
                  newStuCNIC = value;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white10,
                  filled: true,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: 5.0,
                ),
                child: Text(
                  'Student phone',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.numberWithOptions(),
                style: TextStyle(color: Colors.white, fontSize: 22.0),
                onChanged: (value) {
                  newStuPhone = value;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white10,
                  filled: true,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: 5.0,
                ),
                child: Text(
                  'Student Institute',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              TextField(
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
                autocorrect: true,
                style: TextStyle(color: Colors.white, fontSize: 22.0),
                onChanged: (value) {
                  newStuInst = value;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white10,
                  filled: true,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: 5.0,
                ),
                child: Text(
                  'Student Address',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              TextField(
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
                autocorrect: true,
                style: TextStyle(color: Colors.white, fontSize: 22.0),
                onChanged: (value) {
                  newStuAddress = value;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white10,
                  filled: true,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: 5.0,
                ),
                child: Text(
                  'Admission Fee',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.numberWithOptions(),
                style: TextStyle(color: Colors.white, fontSize: 22.0),
                onChanged: (value) {
                  admissionFee = int.parse(value);
                },
                decoration: InputDecoration(
                  fillColor: Colors.white10,
                  filled: true,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: 5.0,
                ),
                child: Text(
                  'Security Fee',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.numberWithOptions(),
                style: TextStyle(color: Colors.white, fontSize: 22.0),
                onChanged: (value) {
                  securityFee = int.parse(value);
                },
                decoration: InputDecoration(
                  fillColor: Colors.white10,
                  filled: true,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                ),
                color: Colors.white10,
                onPressed: () async {
                  if (newStuCNIC != null &&
                      newStuName != null &&
                      newStuPhone != null &&
                      newStuAddress != null &&
                      newStuInst != null) {
                    DatabaseHelper dbHelper = DatabaseHelper();
                    await dbHelper
                        .insertListToStudent(StudentData(
                      stuCNIC: newStuCNIC,
                      stuName: newStuName,
                      stuPhone: newStuPhone,
                      stuAddress: newStuAddress,
                      stuRoom: widget.stuRoom,
                      stuInst: newStuInst,
                      feeStatus: 'Unpaid',
                      admission: admissionFee,
                      security: securityFee,
                      admMonth: DateFormat('yMMMM').format(DateTime.now()),
                      remaining: 0,
                    ))
                        .whenComplete(() async {
                      await dbHelper.updateRoom(
                          'reserved', reservedSeats + 1, widget.stuRoom);
                    }).whenComplete(() async {
                      List<StudentData> sData =
                          await dbHelper.getStudentsData('stuCNIC', newStuCNIC);
                      if (sData.isNotEmpty) {
                        newStuId = sData[0].stuId;
                      }
                    }).whenComplete(() => _submitForm());
                    Navigator.of(context).pop();
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Please provide valid values',
                        textColor: Colors.redAccent,
                        gravity: ToastGravity.TOP);
                  }
                },
              ),
              TextButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Color(0xff141026),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
        ),
      ),
    );
  }
}
