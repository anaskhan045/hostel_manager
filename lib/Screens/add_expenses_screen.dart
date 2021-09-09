import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_manager/widgets/controller.dart';
import 'package:hostel_manager/widgets/database_helper.dart';
import 'package:hostel_manager/widgets/form.dart';
import 'package:hostel_manager/widgets/hotel_data_sample.dart';
import 'package:intl/intl.dart';

class AddExpenses extends StatefulWidget {
  final String sDate;
  final int totalBalance;

  AddExpenses({this.sDate, this.totalBalance});

  @override
  _AddExpensesState createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  String expName;
  int expAmount;
  TextEditingController titleController;
  TextEditingController amountController;
  String sDate = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sDate = DateFormat('yMMMMd').format(DateTime.now());
  }

  void _submitExpForm() {
    AddExpForm addExpForm = AddExpForm(
        sDate: sDate,
        expName: expName,
        expAmount: expAmount,
        totalBalance: widget.totalBalance - expAmount,
        choose: 'addExp');

    FormController formController = FormController((String response) {});

    formController.addExpForm(addExpForm);
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
                'Add New Expense',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35.0,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: 10.0,
                ),
                child: Text(
                  'Expense Title',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                ),
                autofocus: true,
                controller: titleController,
                textCapitalization: TextCapitalization.words,
                autocorrect: true,
                style: TextStyle(color: Colors.white, fontSize: 22.0),
                onChanged: (value) {
                  expName = value;
                },
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: 10.0,
                ),
                child: Text(
                  'Expenses Amount',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                ),
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(),
                style: TextStyle(color: Colors.white, fontSize: 22.0),
                onChanged: (value) {
                  expAmount = double.parse(value).toInt();
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
                  if (expName != null && expAmount != null) {
                    DatabaseHelper dbHelper = DatabaseHelper();
                    dbHelper
                        .insertListToExp(ExpData(
                      expName: expName,
                      expAmount: expAmount,
                      sDate: widget.sDate,
                    ))
                        .whenComplete(() {
                      _submitExpForm();
                      Navigator.of(context).pop();
                    });
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
