class BoxInfo {
  final String id;
  final String name;
  final String packageCount;
  final String location;
  final String status;
  final String created;
  final List<dynamic> updates;

  String getBoxInfo() {
    return 'assets/images/box.png';
  }

  BoxInfo({
    this.id,
    this.name,
    this.packageCount,
    this.location,
    this.status,
    this.created,
    this.updates,
  });

  factory BoxInfo.fromJson(Map<String, dynamic> parsedJson) {
    return BoxInfo(
        id: parsedJson['id'].toString(),
        location: parsedJson['Location'].toString(),
        status: parsedJson['status'].toString(),
        updates: (parsedJson['StatusUpdates'] as List<dynamic>),
        name: parsedJson['Name'].toString(),
        packageCount: parsedJson['packagecount'].toString(),
        created: parsedJson['createdAt'].toString());
  }
}
