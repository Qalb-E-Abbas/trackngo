class MemberInfo {
  final String id;
  final String fname;
  final String lname;
  final String email;
  final String dateJoined;
  final String tngNo;
  final String accType;
  final String phone;

  String getFullName() {
    return this.fname + ' ' + this.lname;
  }

  String getMemberString() {
    switch (accType) {
      case 'admin':
        return 'assets/images/admin.png';
        break;

      default:
        return 'assets/images/members.png';
        break;
    }
  }

  MemberInfo(
      {this.fname,
      this.id,
      this.phone,
      this.lname,
      this.email,
      this.dateJoined,
      this.tngNo,
      this.accType});

  factory MemberInfo.fromJson(Map<String, dynamic> parsedJson) {
    return MemberInfo(
        id: parsedJson['id'].toString(),
        fname: parsedJson['fname'].toString(),
        phone: parsedJson['phone'].toString(),
        lname: parsedJson['lname'].toString(),
        tngNo: parsedJson['tngno'].toString(),
        email: parsedJson['email'].toString(),
        dateJoined: parsedJson['joined'].toString(),
        accType: parsedJson['accType'].toString());
  }
}
