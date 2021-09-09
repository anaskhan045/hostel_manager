import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hostel_manager/Screens/add_screen.dart';
import 'package:hostel_manager/Screens/student_screen.dart';
import 'package:hostel_manager/widgets/database_helper.dart';
import 'package:hostel_manager/widgets/hotel_data_sample.dart';

class RoomsScreen extends StatefulWidget {
  @override
  _RoomsScreenState createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  int totalRooms = 0;
  int availableRooms = 0;
  int reservedRooms = 0;
  DateTime selectedDate;
  String selectedMonth;
  int isReserved = 0;
  DatabaseHelper dbHelper = DatabaseHelper();
  List floorsList = [
    'GROUND FLOOR',
    'BASEMENT',
    '1ST FLOOR',
    '2ND FLOOR',
    '3RD FLOOR',
    '4TH FLOOR',
    '5TH FLOOR',
    '6TH FLOOR',
    '7TH FLOOR',
    '8TH FLOOR',
    '9TH FLOOR',
    '10TH FLOOR',
  ];
  String selectedFloor;
  int sFloorIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedFloor = floorsList[sFloorIndex];
    getData();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  void selectFloor(int direction) {
    reservedRooms = 0;
    availableRooms = 0;
    if (direction == 1) {
      if (sFloorIndex < floorsList.length - 1) {
        sFloorIndex = sFloorIndex + 1;
        setState(() {
          selectedFloor = floorsList[sFloorIndex];
        });
      }
    } else {
      if (sFloorIndex > 0) {
        sFloorIndex = sFloorIndex - 1;
        setState(() {
          selectedFloor = floorsList[sFloorIndex];
        });
      }
    }
  }

  List roomNames = [];
  Future<void> getData() async {
    roomNames = [];
    List<RoomData> roomData = [];
    roomData = await dbHelper.getRoomData('floorName', selectedFloor);

    if (roomData.isNotEmpty) {
      roomNames = [];
      setState(() {
        totalRooms = roomData.length;
      });
      for (int i = 0; i < roomData.length; i++) {
        roomNames.add(roomData[i].roomName);
        if (roomData[i].reserved > 0) {
          reservedRooms = reservedRooms + 1;
        }
      }
    } else {
      setState(() {
        totalRooms = 0;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                builder: (context) => AddRooms(
                      roomNames: roomNames,
                      sFloor: selectedFloor,
                    )).whenComplete(() {
              getData();
            });
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
                          top: 10.0, bottom: 30.0, left: 5.0, right: 5.0),
                      child: Column(
                        children: [
                          Text(
                            'ROOMS',
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
                                        fontSize: 18.0, color: Colors.white),
                                  ),
                                  Text(
                                    'ROOMS',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    '$totalRooms',
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
                                    'ROOMS',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    '$reservedRooms',
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
                                    'ROOMS',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    '${totalRooms - reservedRooms}',
                                    style: TextStyle(
                                        fontSize: 34.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
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
              Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.blue),
                      onPressed: () {
                        selectFloor(-1);
                        getData();
                      }),
                  Text(
                    selectedFloor,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        selectFloor(1);
                        getData();
                      }),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(top: 10.0),
                      child: ListView(
                        children: [
                          FutureBuilder(
                              future: dbHelper.getRoomData(
                                  'floorName', selectedFloor),
                              initialData: [],
                              builder: (context, snapShot) {
                                return GridView.builder(
                                    addAutomaticKeepAlives: false,
                                    physics:
                                        ScrollPhysics(), // to disable GridView's scrolling
                                    shrinkWrap: true,
                                    itemCount: snapShot.data.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudentScreen(
                                                        stuRoom: snapShot
                                                            .data[index]
                                                            .roomName,
                                                      )));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15.0),
                                                child: Text(
                                                  snapShot.data[index].roomName,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 24.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.0),
                                                ),
                                              ),
                                              Flexible(
                                                child: GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 4),
                                                  itemBuilder:
                                                      (context, index2) =>
                                                          Container(
                                                    margin: EdgeInsets.all(2.0),
                                                    child: CircleAvatar(
                                                      radius: 5.0,
                                                      backgroundColor: index2 <
                                                              snapShot
                                                                  .data[index]
                                                                  .reserved
                                                          ? Colors.red
                                                          : Colors.green,
                                                    ),
                                                  ),
                                                  itemCount: snapShot
                                                      .data[index].roomCapacity,
                                                ),
                                              ),
                                            ],
                                          ),
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
                        ],
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
