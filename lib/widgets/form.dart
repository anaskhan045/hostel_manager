class StudentForm {
  int stuId;

  String stuName;
  String stuPhone;
  String stuCNIC;
  String stuInst;
  String stuAddress;
  String stuRoom;
  String admMonth;
  String feeStatus;
  int admission;
  int security;
  int remaining;
  String choose;

  StudentForm({
    this.stuId,
    this.stuName,
    this.stuPhone,
    this.stuCNIC,
    this.stuInst,
    this.stuAddress,
    this.stuRoom,
    this.admMonth,
    this.feeStatus,
    this.admission,
    this.security,
    this.remaining,
    this.choose,
  });

  // Method to make GET parameters.
  String toParams() =>
      "?stuId=$stuId&stuName=$stuName&stuPhone=$stuPhone&stuCNIC=$stuCNIC&stuInst=$stuInst&stuAdd=$stuAddress&stuRoom=$stuRoom&admMonth=$admMonth&feeStatus=$feeStatus&addmission=$admission&security=$security&remaining=$remaining&choose=$choose";
}

class UpdateForm {
  int stuId;
  var value;
  String choose;

  UpdateForm({
    this.stuId,
    this.value,
    this.choose,
  });

  // Method to make GET parameters.
  String toParams() => "?stuId=$stuId&value=$value&choose=$choose";
}

class UpdateFeeForm {
  int stuId;
  int fee;
  String sDate;
  String choose;

  UpdateFeeForm({
    this.stuId,
    this.fee,
    this.sDate,
    this.choose,
  });

  // Method to make GET parameters.
  String toParams() => "?stuId=$stuId&fee=$fee&sDate=$sDate&choose=$choose";
}

class AddFeeForm {
  int stuId;
  String stuName;
  int fee;
  String sDate;
  String choose;

  AddFeeForm({
    this.stuId,
    this.stuName,
    this.fee,
    this.sDate,
    this.choose,
  });

  // Method to make GET parameters.
  String toParams() =>
      "?stuId=$stuId&stuName=$stuName&fee=$fee&feeMonth=$sDate&choose=$choose";
}

class AddExpForm {
  String sDate;
  String expName;
  int expAmount;
  int totalBalance;
  String choose;

  AddExpForm({
    this.sDate,
    this.expName,
    this.expAmount,
    this.totalBalance,
    this.choose,
  });

  // Method to make GET parameters.
  String toParams() =>
      "?sDate=$sDate&expName=$expName&expAmount=$expAmount&totalBalance=$totalBalance&choose=$choose";
}

class DeleteExpForm {
  String sDate;
  String expName;
  int expAmount;
  int totalBalance;
  String choose;

  DeleteExpForm({
    this.sDate,
    this.expName,
    this.expAmount,
    this.choose,
  });

  // Method to make GET parameters.
  String toParams() =>
      "?sDate=$sDate&expName=$expName&expAmount=$expAmount&choose=$choose";
}
