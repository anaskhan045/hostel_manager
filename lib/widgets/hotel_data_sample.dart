class RoomData {
  String roomName;
  String floorName;
  int roomCapacity;
  int reserved;

  RoomData({this.roomName, this.floorName, this.roomCapacity, this.reserved});
  Map<String, dynamic> toMapRoom() {
    return {
      'roomName': roomName,
      'roomCapacity': roomCapacity,
      'floorName': floorName,
      'reserved': reserved,
    };
  }
}

class StudentData {
  int stuId;
  String stuCNIC;
  String stuName;
  String stuPhone;
  String stuAddress;
  String stuRoom;
  String stuInst;
  String feeStatus;
  int admission;
  int security;
  String admMonth;
  int remaining;

  StudentData({
    this.stuId,
    this.stuName,
    this.stuPhone,
    this.stuAddress,
    this.stuRoom,
    this.stuCNIC,
    this.feeStatus,
    this.stuInst,
    this.admission,
    this.security,
    this.admMonth,
    this.remaining,
  });
  Map<String, dynamic> toMapStudent() {
    return {
      'stuId': stuId,
      'stuCNIC': stuCNIC,
      'stuName': stuName,
      'stuPhone': stuPhone,
      'stuAddress': stuAddress,
      'stuRoom': stuRoom,
      'stuInst': stuInst,
      'feeStatus': feeStatus,
      'admission': admission,
      'security': security,
      'admMonth': admMonth,
      'remaining': remaining,
    };
  }
}

class FeeData {
  int stuId;
  int fee;
  String sDate;

  FeeData({this.stuId, this.fee, this.sDate});
  Map<String, dynamic> toMapFee() {
    return {
      'stuId': stuId,
      'fee': fee,
      'sDate': sDate,
    };
  }
}

class ExpData {
  String sDate;
  String expName;
  int expAmount;

  ExpData({
    this.sDate,
    this.expName,
    this.expAmount,
  });
  Map<String, dynamic> toMapExp() {
    return {
      'expName': expName,
      'expAmount': expAmount,
      'sDate': sDate,
    };
  }
}

class UserData {
  int isLoggedIn;

  UserData({this.isLoggedIn});
  Map<String, dynamic> toMapUser() {
    return {
      'isLoggedIn': isLoggedIn,
    };
  }
}
