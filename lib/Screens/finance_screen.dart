import 'package:flutter/material.dart';
import 'package:hostel_manager/Screens/add_expenses_screen.dart';
import 'package:hostel_manager/widgets/controller.dart';
import 'package:hostel_manager/widgets/database_helper.dart';
import 'package:hostel_manager/widgets/form.dart';
import 'package:hostel_manager/widgets/hotel_data_sample.dart';
import 'package:intl/intl.dart';

class FinanceScreen extends StatefulWidget {
  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen>
    with TickerProviderStateMixin {
  int monthExpenses = 0;
  int totalBalance = 0;
  DateTime selectedDate;
  String selectedMonth;

  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedMonth = DateFormat('yMMMM').format(selectedDate);
    getData();
  }

  Future<void> getData() async {
    List<StudentData> studentData = [];
    List<FeeData> feeData = [];
    List<ExpData> expData = [];

    studentData = await dbHelper.getStudentsData('admMonth', selectedMonth);
    feeData = await dbHelper.getFeeData('sDate', selectedMonth);
    expData = await dbHelper.getExpData(selectedMonth);

    if (studentData.isNotEmpty || feeData.isNotEmpty || expData.isNotEmpty) {
      totalBalance = 0;
      monthExpenses = 0;

      for (int i = 0; i < studentData.length; i++) {
        totalBalance =
            totalBalance + studentData[i].security + studentData[i].admission;
      }
      for (int i = 0; i < feeData.length; i++) {
        totalBalance = totalBalance + feeData[i].fee;
      }
      for (int i = 0; i < expData.length; i++) {
        monthExpenses = monthExpenses + expData[i].expAmount;
      }
      setState(() {
        totalBalance = totalBalance - monthExpenses;
      });
    } else {
      setState(() {
        totalBalance = 0;
        monthExpenses = 0;
      });
    }
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
    getData();
  }

  void _deleteExpForm(String sDate, String expName, int expAmount) {
    DeleteExpForm deleteExpForm = DeleteExpForm(
        sDate: sDate, expName: expName, expAmount: expAmount, choose: 'delExp');

    FormController formController = FormController((String response) {});

    formController.deleteExpForm(deleteExpForm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                builder: (context) => AddExpenses(
                      sDate: selectedMonth,
                      totalBalance: totalBalance,
                    )).whenComplete(() {
              getData();
            });
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Color(0xff251e37),
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.blue),
                          onPressed: () {
                            selectMonth(-1);
                          }),
                      Text(
                        selectedMonth,
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
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
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 30.0, horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MONTHLY EXPENSES',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                Text(
                                  'Rs.',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '$monthExpenses',
                                  style: TextStyle(
                                      fontSize: monthExpenses < 999999 &&
                                              monthExpenses > -999999
                                          ? 34.0
                                          : 17.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CURRENT BALANCE',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                Text(
                                  'Rs.',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '$totalBalance',
                                  style: TextStyle(
                                      fontSize: totalBalance < 999999 &&
                                              totalBalance > -999999
                                          ? 34.0
                                          : 17.0,
                                      fontWeight: FontWeight.bold,
                                      color: totalBalance <= 0
                                          ? Colors.redAccent
                                          : Colors.green),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: WillPopScope(
                      child: FutureBuilder(
                          future: dbHelper.getExpData(selectedMonth),
                          initialData: [],
                          builder: (context, snapShot) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapShot.data.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: ListTile(
                                      onLongPress: () {
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
                                                'Do you want to Delete?',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text(
                                                    'NO',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.deepPurple,
                                                        fontSize: 18.0),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    'YES',
                                                    style: TextStyle(
                                                        fontSize: 22.0,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () async {
                                                    await dbHelper
                                                        .deleteExpense(
                                                            snapShot
                                                                .data[(snapShot
                                                                            .data
                                                                            .length -
                                                                        1) -
                                                                    index]
                                                                .expName,
                                                            snapShot
                                                                .data[(snapShot
                                                                            .data
                                                                            .length -
                                                                        1) -
                                                                    index]
                                                                .sDate,
                                                            snapShot
                                                                .data[(snapShot
                                                                            .data
                                                                            .length -
                                                                        1) -
                                                                    index]
                                                                .expAmount)
                                                        .whenComplete(() {
                                                      _deleteExpForm(
                                                          snapShot
                                                              .data[(snapShot
                                                                          .data
                                                                          .length -
                                                                      1) -
                                                                  index]
                                                              .sDate,
                                                          snapShot
                                                              .data[(snapShot
                                                                          .data
                                                                          .length -
                                                                      1) -
                                                                  index]
                                                              .expName,
                                                          snapShot
                                                              .data[(snapShot
                                                                          .data
                                                                          .length -
                                                                      1) -
                                                                  index]
                                                              .expAmount);

                                                      Navigator.of(context)
                                                          .pop();
                                                      getData();
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      title: Text(
                                        snapShot
                                            .data[(snapShot.data.length - 1) -
                                                index]
                                            .expName,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white),
                                      ),
                                      subtitle: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Rs.',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                          Text(
                                            '${snapShot.data[(snapShot.data.length - 1) - index].expAmount}',
                                            style: TextStyle(
                                                fontSize: 28.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 5.0),
                                    margin: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xff251e37),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  );
                                });
                          }),
                    ))),
          ],
        ),
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)

  // More advanced TableCalendar configuration (using Builders & Styles)

  TextEditingController listController;
}
