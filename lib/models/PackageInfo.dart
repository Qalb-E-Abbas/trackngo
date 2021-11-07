import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:trackngo/models/StatusUpdate.dart';

class PackageInfo {
  final String id;
  final String owner;
  final String location;
  final String status;
  final List updates;
  final String item;
  final String category;
  final String invoiceFile;
  final String weight;
  final String created;
  final String trackingno;
  final String locationstring;
  final String fullname;
  final String boxId;
  final String cost;
  final String tngono;

  PackageInfo(
      {this.owner,
      this.id,
      this.location,
      this.status,
      this.updates,
      this.trackingno,
      this.item,
      this.weight,
      this.created,
      this.invoiceFile,
      this.category,
      this.locationstring,
      this.boxId,
      this.cost,
      this.fullname,
      this.tngono});

  factory PackageInfo.fromJson(Map<String, dynamic> parsedJson) {
    return PackageInfo(
        id: parsedJson['id'].toString(),
        owner: parsedJson['owner'].toString(),
        location: parsedJson['location'].toString(),
        status: parsedJson['status'].toString(),
        updates: (parsedJson['updates'] as List<dynamic>),
        fullname: parsedJson['fullname'].toString(),
        item: parsedJson['item'].toString(),
        category: parsedJson['category'].toString(),
        invoiceFile: parsedJson['invoiceFile'].toString(),
        weight: parsedJson['weight'].toString(),
        locationstring: parsedJson['locationstring'].toString(),
        created: parsedJson['created'].toString(),
        trackingno: parsedJson['trackingno'].toString(),
        boxId: parsedJson['Boxid'].toString(),
        tngono: parsedJson['tngono'].toString());
  }
}
