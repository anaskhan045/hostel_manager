import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_manager/Screens/student_data_screen.dart';
import 'package:hostel_manager/widgets/database_helper.dart';
import 'package:hostel_manager/widgets/hotel_data_sample.dart';
import 'package:intl/intl.dart';

class AllStudentsScreen extends StatefulWidget {
  @override
  _AllStudentsScreenState createState() => _AllStudentsScreenState();
}

class _AllStudentsScreenState extends State<AllStudentsScreen>
    with TickerProviderStateMixin {
  DatabaseHelper dbHelper = DatabaseHelper();
  int present = 0;
  int paid = 0;
  int unpaid = 0;
  int stuId;
  List<int> stuIds = [];
  List<int> stuPaidIds = [];
  String selectedMonth;
  TextEditingController idController = TextEditingController();
  @override
  void initState() {
    super.initState();

    selectedMonth = DateFormat('yMMMM').format(DateTime.now());

    getData();
  }

  Future<void> getData() async {
    List<StudentData> studentData = [];
    List<FeeData> feeData = [];
    studentData = await dbHelper.getAllStudentsData();
    feeData = await dbHelper.getFeeData('sDate', selectedMonth);

    if (studentData.isNotEmpty) {
      stuIds = [];
      present = 0;
      paid = 0;
      unpaid = 0;

      present = studentData.length;
      for (int i = 0; i < studentData.length; i++) {
        stuIds.add(studentData[i].stuId);
        if (studentData[i].feeStatus == 'Paid') {
          paid = paid + 1;
        } else {
          unpaid = unpaid + 1;
        }
      }
      setState(() {});
    } else {
      setState(() {
        present = 0;
        paid = 0;
        unpaid = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff141026),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
                decoration: BoxDecoration(
                    color: Color(0xff251e37),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'PRESENT',
                              style: TextStyle(
                                  fontSize: 18.0, color: Color(0xffc7c8cd)),
                            ),
                            Text(
                              'STUDENTS',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '$present',
                              style: TextStyle(
                                  fontSize: 34.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'PAID',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                            Text(
                              'STUDENTS',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '$paid',
                              style: TextStyle(
                                  fontSize: 34.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'UNPAID',
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                            Text(
                              'STUDENTS',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '$unpaid',
                              style: TextStyle(
                                  fontSize: 34.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.white70,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 50.0,
                      ),
                      title: TextFormField(
                        controller: idController,
                        keyboardType: TextInputType.numberWithOptions(),
                        focusNode: FocusNode(),
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                        onChanged: (value) {
                          stuId = int.parse(value);
                        },
                        onFieldSubmitted: (value) {
                          stuId = int.parse(value);
                          if (stuIds.contains(stuId)) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StudentDataScreen(
                                          stuId: stuId,
                                        )));
                            idController.clear();
                          } else {
                            Fluttertoast.showToast(
                                msg: 'No student found with ID: $stuId',
                                fontSize: 18.0,
                                textColor: Colors.red,
                                gravity: ToastGravity.TOP);
                            idController.clear();
                          }
                        },
                        textAlign: TextAlign.center,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          fillColor: Color(0xff141026),
                          filled: true,
                          hintText: 'Enter Student ID',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          if (stuIds.contains(stuId)) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StudentDataScreen(
                                          stuId: stuId,
                                        )));
                            idController.clear();
                          } else {
                            Fluttertoast.showToast(
                                msg: 'No student found with ID: $stuId',
                                fontSize: 18.0,
                                textColor: Colors.red,
                                gravity: ToastGravity.TOP);
                          }
                        },
                        child: Text(
                          'Search',
                          style: TextStyle(color: Colors.white, fontSize: 22.0),
                          textAlign: TextAlign.center,
                        ),
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
                            future: dbHelper.getAllStudentsData(),
                            initialData: [],
                            builder: (context, snapShot) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapShot.data.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StudentDataScreen(
                                                      stuId: snapShot
                                                          .data[index].stuId,
                                                    ))).whenComplete(() {
                                          getData();
                                        });
                                      },
                                      child: Container(
                                        child: ListTile(
                                          leading: Text(
                                            snapShot.data[index].stuName,
                                            style: TextStyle(
                                                fontSize: 34.0,
                                                color: Colors.white),
                                          ),
                                          trailing: Text(
                                            snapShot.data[index].feeStatus,
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: snapShot.data[index]
                                                            .feeStatus ==
                                                        'Unpaid'
                                                    ? Colors.red
                                                    : Colors.green),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.0, horizontal: 5.0),
                                        margin: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          color: Color(0xff251e37),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    );
                                  });
                            }),
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)

  // More advanced TableCalendar configuration (using Builders & Styles)

  TextEditingController listController;
}
