class StatusUpdate {
  final String created;
  final String doneby;
  final String status;

  StatusUpdate({this.status, this.created, this.doneby});

  factory StatusUpdate.fromJson(Map<String, dynamic> parsedJson) {
    return StatusUpdate(
        status: parsedJson['status'].toString(),
        doneby: parsedJson['doneby'].toString(),
        created: parsedJson['created'].toString());
  }
}
