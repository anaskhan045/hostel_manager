import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_manager/Screens/add_student_screen.dart';
import 'package:hostel_manager/Screens/rooms_screen.dart';
import 'package:hostel_manager/Screens/student_data_screen.dart';
import 'package:hostel_manager/widgets/database_helper.dart';
import 'package:hostel_manager/widgets/hotel_data_sample.dart';

class StudentScreen extends StatefulWidget {
  final String stuRoom;

  StudentScreen({
    this.stuRoom,
  });
  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen>
    with TickerProviderStateMixin {
  int reservedSeats = 0;
  int newCapacity = 0;

  DatabaseHelper dbHelper = DatabaseHelper();

  int sFloorIndex = 0;
  int totalSeats = 0;
  List<StudentData> studentData = [];
  List<RoomData> roomData = [];

  @override
  void initState() {
    super.initState();
    newCapacity = totalSeats;

    getData();
  }

  Future<void> getData() async {
    studentData = [];
    studentData = await dbHelper.getStudentsData('stuRoom', widget.stuRoom);
    roomData = await dbHelper.getRoomData('roomName', widget.stuRoom);

    if (roomData.isNotEmpty) {
      setState(() {
        reservedSeats = roomData[0].reserved;
        totalSeats = roomData[0].roomCapacity;
      });
    } else {
      setState(() {
        reservedSeats = 0;
      });
    }
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
            if (reservedSeats < totalSeats) {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => AddStudents(
                        stuRoom: widget.stuRoom,
                      )).whenComplete(() {
                getData();
              });
            } else {
              Fluttertoast.showToast(
                  msg: 'No more seats available here!',
                  textColor: Colors.red,
                  fontSize: 18.0,
                  gravity: ToastGravity.CENTER);
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Color(0xff251e37),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
                      child: Column(
                        children: [
                          Text(
                            'ROOM ${widget.stuRoom}',
                            style: TextStyle(
                                fontSize: 34.0,
                                color: Color(0xffc7c8cd),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'TOTAL',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ),
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
                                    'RESERVED',
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white),
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
                                    '$reservedSeats',
                                    style: TextStyle(
                                        fontSize: 34.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'AVAILABLE',
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white),
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
                                    '${totalSeats - reservedSeats}',
                                    style: TextStyle(
                                        fontSize: 34.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible:
                                          true, // user must tap button!
                                      builder: (BuildContext context) {
                                        int newFee;
                                        return AlertDialog(
                                          backgroundColor: Color(0xff251e37),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0))),
                                          title: Text(
                                            'UPDATE  ${widget.stuRoom}?',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: TextField(
                                            onSubmitted: (value) async {
                                              newCapacity = int.parse(value);
                                              if (newCapacity < totalSeats) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'New capacity can not be less then old capacity which is \"$totalSeats\"',
                                                    textColor: Colors.red,
                                                    fontSize: 18.0,
                                                    gravity:
                                                        ToastGravity.CENTER);
                                              } else {
                                                await dbHelper
                                                    .updateRoom(
                                                        'roomCapacity',
                                                        newCapacity,
                                                        widget.stuRoom)
                                                    .whenComplete(() {
                                                  Navigator.of(context).pop();
                                                  getData();
                                                });
                                              }
                                            },
                                            keyboardType: TextInputType.number,

                                            style: TextStyle(
                                                fontSize: 30.0,
                                                color: Colors.white),
                                            decoration: InputDecoration(
                                              hintText: 'Enter New Capacity',
                                              hintStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0),
                                              filled: true,
                                              fillColor: Colors.white10,
                                            ),

                                            // controller: controller,

                                            onChanged: (newValue) {
                                              newCapacity = int.parse(newValue);
                                            },
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                'CANCEL',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                'UPDATE',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () async {
                                                if (newCapacity < totalSeats) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'New capacity can not be less then old capacity which is \"$totalSeats\"',
                                                      textColor: Colors.red,
                                                      fontSize: 18.0,
                                                      gravity:
                                                          ToastGravity.CENTER);
                                                } else {
                                                  await dbHelper
                                                      .updateRoom(
                                                          'roomCapacity',
                                                          newCapacity,
                                                          widget.stuRoom)
                                                      .whenComplete(() {
                                                    Navigator.of(context).pop();
                                                    getData();
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'UPDATE ${widget.stuRoom}',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 18.0),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible:
                                          true, // user must tap button!
                                      builder: (BuildContext context) {
                                        int newFee;
                                        return AlertDialog(
                                          backgroundColor: Color(0xff251e37),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0))),
                                          title: Text(
                                            'Do you want to delete \"${widget.stuRoom}\" ?',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'WARNING!',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 22.0),
                                              ),
                                              Text(
                                                'BY Deleting \"${widget.stuRoom}\" All Students In This Room Will Be Deleted',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 18.0),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                'CANCEL',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                'DELETE',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () async {
                                                await dbHelper
                                                    .deleteRoom(widget.stuRoom)
                                                    .whenComplete(() async {
                                                  for (int i = 0;
                                                      i < studentData.length;
                                                      i++) {
                                                    await dbHelper
                                                        .deleteStudent(
                                                            studentData[i]
                                                                .stuId);
                                                  }
                                                }).whenComplete(() {
                                                  Navigator.of(context).pop();
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              RoomsScreen()));
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'DELETE ${widget.stuRoom}',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 18.0),
                                  ))
                            ],
                          )
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
                            future: dbHelper.getStudentsData(
                                'stuRoom', widget.stuRoom),
                            initialData: [],
                            builder: (context, snapShot) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapShot.data.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StudentDataScreen(
                                                stuId:
                                                    snapShot.data[index].stuId,
                                              ),
                                            ),
                                          );
                                        },
                                        onLongPress: () async {
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
                                                  'Do you want to Delete ${snapShot.data[index].stuName}?',
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
                                                      Navigator.of(context)
                                                          .pop();
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
                                                          .deleteStudent(
                                                              snapShot
                                                                  .data[index]
                                                                  .stuId)
                                                          .whenComplete(
                                                              () async {
                                                        await dbHelper
                                                            .updateRoom(
                                                                'reserved',
                                                                reservedSeats -
                                                                    1,
                                                                widget.stuRoom);
                                                      }).whenComplete(() {
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
