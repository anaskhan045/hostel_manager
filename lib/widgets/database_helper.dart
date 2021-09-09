import 'dart:async';

import 'package:hostel_manager/widgets/hotel_data_sample.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
// Open the database and store the reference.
  Future<Database> database() async {
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'hostelManager.db'),
      onCreate: (db, version) => _createDb(db),
      version: 1,
    );
  }

  static void _createDb(Database db) {

    UserData userData = UserData(isLoggedIn: 0);
    db.execute('CREATE TABLE IF NOT EXISTS user(isLoggedIn INTEGER)');
    db.insert('user', userData.toMapUser());
    db.execute(
        'CREATE TABLE room(roomName TEXT PRIMARY KEY, roomCapacity INTEGER,floorName TEXT,reserved INTEGER)');
    db.execute(
        'CREATE TABLE student(stuId INTEGER PRIMARY KEY AUTOINCREMENT, stuCNIC TEXT, stuName TEXT, stuPhone TEXT,stuRoom TEXT, stuAddress TEXT,stuInst TEXT,feeStatus TEXT,admission INTEGER,security INTEGER,admMonth TEXT,remaining INTEGER)');
    db.execute('CREATE TABLE feeData(stuId INTEGER, fee INTEGER,sDate TEXT)');
    db.execute(
        'CREATE TABLE expData(expName TEXT, expAmount INTEGER,sDate TEXT)');
  }

  Future<void> insertListToRoom(RoomData roomData) async {
    Database _db = await database();
    _db.insert('room', roomData.toMapRoom(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertListToExp(ExpData expData) async {
    Database _db = await database();
    _db.insert('expData', expData.toMapExp(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertListToStudent(StudentData studentData) async {
    Database _db = await database();
    _db.insert('student', studentData.toMapStudent(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertListToFeeData(FeeData feeData) async {
    Database _db = await database();
    _db.insert('feeData', feeData.toMapFee(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<RoomData>> getRoomData(String variable, String value) async {
    Database _db = await database();
    List<Map<String, dynamic>> listMap =
        await _db.query('room', where: '$variable =?', whereArgs: [value]);

    return List.generate(listMap.length, (index) {
      return RoomData(
        roomName: listMap[index]['roomName'],
        roomCapacity: listMap[index]['roomCapacity'],
        floorName: listMap[index]['floorName'],
        reserved: listMap[index]['reserved'],
      );
    });
  }

  Future<List<RoomData>> getAllRoomData() async {
    Database _db = await database();
    List<Map<String, dynamic>> listMap = await _db.query('room');

    return List.generate(listMap.length, (index) {
      return RoomData(
        roomCapacity: listMap[index]['roomCapacity'],
      );
    });
  }

  Future<List<StudentData>> getStudentsData(String variable, var value) async {
    Database _db = await database();
    List<Map<String, dynamic>> listMap =
        await _db.query('student', where: '$variable =?', whereArgs: [value]);

    return List.generate(listMap.length, (index) {
      return StudentData(
        stuId: listMap[index]['stuId'],
        stuCNIC: listMap[index]['stuCNIC'],
        stuName: listMap[index]['stuName'],
        stuPhone: listMap[index]['stuPhone'],
        stuAddress: listMap[index]['stuAddress'],
        stuRoom: listMap[index]['stuRoom'],
        stuInst: listMap[index]['stuInst'],
        feeStatus: listMap[index]['feeStatus'],
        admission: listMap[index]['admission'],
        security: listMap[index]['security'],
        admMonth: listMap[index]['admMonth'],
        remaining: listMap[index]['remaining'],
      );
    });
  }

  Future<List<StudentData>> getAllStudentsData() async {
    Database _db = await database();
    List<Map<String, dynamic>> listMap =
        await _db.rawQuery('SELECT * FROM student');

    return List.generate(listMap.length, (index) {
      return StudentData(
        stuId: listMap[index]['stuId'],
        stuCNIC: listMap[index]['stuCNIC'],
        stuName: listMap[index]['stuName'],
        stuPhone: listMap[index]['stuPhone'],
        stuAddress: listMap[index]['stuAddress'],
        stuRoom: listMap[index]['stuRoom'],
        stuInst: listMap[index]['stuInst'],
        feeStatus: listMap[index]['feeStatus'],
        admission: listMap[index]['admission'],
        security: listMap[index]['security'],
        admMonth: listMap[index]['admMonth'],
        remaining: listMap[index]['remaining'],
      );
    });
  }

  Future<List<StudentData>> getStudentData(int stuId) async {
    Database _db = await database();
    List<Map<String, dynamic>> listMap =
        await _db.query('student', where: 'stuId =?', whereArgs: [stuId]);

    return List.generate(listMap.length, (index) {
      return StudentData(
        stuId: listMap[index]['stuId'],
        stuCNIC: listMap[index]['stuCNIC'],
        stuName: listMap[index]['stuName'],
        stuPhone: listMap[index]['stuPhone'],
        stuAddress: listMap[index]['stuAddress'],
        stuRoom: listMap[index]['stuRoom'],
        stuInst: listMap[index]['stuInst'],
        feeStatus: listMap[index]['feeStatus'],
        admission: listMap[index]['admission'],
        security: listMap[index]['security'],
        admMonth: listMap[index]['admMonth'],
        remaining: listMap[index]['remaining'],
      );
    });
  }

  Future<List<FeeData>> getFeeData(String variable, var value) async {
    Database _db = await database();
    List<Map<String, dynamic>> listMap =
        await _db.query('feeData', where: '$variable =?', whereArgs: [value]);

    return List.generate(listMap.length, (index) {
      return FeeData(
        stuId: listMap[index]['stuId'],
        fee: listMap[index]['fee'],
        sDate: listMap[index]['sDate'],
      );
    });
  }

  Future<List<ExpData>> getExpData(String sDate) async {
    Database _db = await database();
    List<Map<String, dynamic>> listMap =
        await _db.query('expData', where: 'sDate=?', whereArgs: [sDate]);

    return List.generate(listMap.length, (index) {
      return ExpData(
        expName: listMap[index]['expName'],
        expAmount: listMap[index]['expAmount'],
        sDate: listMap[index]['sDate'],
      );
    });
  }

  Future<void> deleteRoom(
    String roomName,
  ) async {
    Database _db = await database();

    // Remove the Dog from the Database.
    await _db.delete(
      'room',
      // Use a `where` clause to delete a specific dog.
      where: "roomName = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [roomName],
    );
  }

  Future<void> updateRoom(
    String variable,
    int value,
    String roomName,
  ) async {
    // Get a reference to the database.
    Database _db = await database();

    // Update the given Dog.
    await _db.rawUpdate(
        'UPDATE room SET $variable = ? WHERE roomName = ?', [value, roomName]);
  }

  Future<void> updateUser(
    int value,
  ) async {
    // Get a reference to the database.
    Database _db = await database();

    // Update the given Dog.
    await _db.rawUpdate('UPDATE user SET isLoggedIn = ?', [
      value,
    ]);
  }

  Future<List<UserData>> getUser() async {
    // Get a reference to the database.
    Database _db = await database();

    List<Map<String, dynamic>> listMap =
        await _db.rawQuery('SELECT * FROM user');

    return List.generate(listMap.length, (index) {
      return UserData(
        isLoggedIn: listMap[index]['isLoggedIn'],
      );
    });

    // Update the given Dog.
  }

  Future<void> updateFee(int fee, int stuId, String sDate) async {
    // Get a reference to the database.
    Database _db = await database();

    // Update the given Dog.
    await _db.rawUpdate(
        'UPDATE feeData SET fee = ? WHERE stuId = ? and sDate=?',
        [fee, stuId, sDate]);
  }

  Future<void> updateStudent(String variable, var value, int stuId) async {
    // Get a reference to the database.
    Database _db = await database();

    // Update the given Dog.
    await _db.rawUpdate(
        'UPDATE student SET $variable = ? WHERE stuId = ?', [value, stuId]);
  }

  Future<void> deleteStudent(
    int stuId,
  ) async {
    Database _db = await database();

    // Remove the Dog from the Database.
    await _db.delete(
      'student',
      // Use a `where` clause to delete a specific dog.
      where: "stuId = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [stuId],
    );
  }

  Future<void> deleteExpense(
      String expName, String sDate, int expAmount) async {
    Database _db = await database();

    // Remove the Dog from the Database.
    await _db.delete(
      'expData',
      // Use a `where` clause to delete a specific dog.
      where: "expName = ? and sDate=? and expAmount=?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [expName, sDate, expAmount],
    );
  }
}
