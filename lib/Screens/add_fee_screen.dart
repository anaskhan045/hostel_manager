import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_manager/widgets/controller.dart';
import 'package:hostel_manager/widgets/database_helper.dart';
import 'package:hostel_manager/widgets/form.dart';
import 'package:hostel_manager/widgets/hotel_data_sample.dart';
import 'package:intl/intl.dart';

class AddFee extends StatefulWidget {
  final int stuId;
  final String stuName;
  AddFee({this.stuId, this.stuName});
  @override
  _AddFeeState createState() => _AddFeeState();
}

class _AddFeeState extends State<AddFee> {
  int newFee;
  DatabaseHelper dbHelper = DatabaseHelper();

  String selectedMonth;
  DateTime selectedDate;
  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();
    selectedMonth = DateFormat('yMMMM').format(selectedDate);
  }

  void _submitFeeForm() {
    AddFeeForm addFeeForm = AddFeeForm(
        stuId: widget.stuId,
        stuName: widget.stuName,
        fee: newFee,
        sDate: selectedMonth,
        choose: 'addFee');

    FormController formController = FormController((String response) {});

    formController.addFeeForm(addFeeForm);
  }

  void selectMonth(int direction) {
    if (direction == 1) {
      setState(() {
        selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
        selectedMonth = DateFormat('yMMMM').format(selectedDate);
      });
    } else {
      setState(() {
        selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
        selectedMonth = DateFormat('yMMMM').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: Color(0xff141026),
        child: Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text(
                'Enter Fee',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35.0,
                ),
              ),
              Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.blue),
                      onPressed: () {
                        selectMonth(-1);
                      }),
                  Text(
                    selectedMonth,
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        selectMonth(1);
                      }),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.numberWithOptions(),
                style: TextStyle(fontSize: 24, color: Colors.white),
                autofocus: true,
                onChanged: (value) {
                  newFee = int.parse(value);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                ),
                color: Colors.white10,
                onPressed: () async {
                  if (newFee != null) {
                    await dbHelper
                        .insertListToFeeData(FeeData(
                      stuId: widget.stuId,
                      fee: newFee,
                      sDate: selectedMonth,
                    ))
                        .whenComplete(() async {
                      await dbHelper.updateStudent(
                          'feeStatus', 'Paid', widget.stuId);
                    }).whenComplete(() {
                      _submitFeeForm();
                      Navigator.of(context).pop();
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Please Enter Fee Amount',
                        textColor: Colors.red,
                        gravity: ToastGravity.CENTER);
                  }
                },
              ),
              TextButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.red),
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
