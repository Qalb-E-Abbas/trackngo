import 'package:flutter/material.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:trackngo/models/BoxInfo.dart';
import 'package:trackngo/package_details.dart';
import './models/PackageInfo.dart';
import 'dart:convert';

class BoxPackages extends StatefulWidget {
  @override
  _BoxPackagesState createState() => _BoxPackagesState(this.box);

  BoxInfo box = new BoxInfo();
  BoxPackages({this.box}) {}
}

class _BoxPackagesState extends State<BoxPackages> {
  BoxInfo box = new BoxInfo();

  _BoxPackagesState(this.box) {}

  Future<List<PackageInfo>> fetchData() async {
    List<PackageInfo> parsedList = [];

    final ParseCloudFunction function = ParseCloudFunction('get_box_packages');
    final Map<String, String> params2 = <String, String>{'bid': box.id};

    final ParseResponse result = await function.execute(parameters: params2);
    if (result.success) {
      if (result.result is List) {
        for (var item in result.result) {
          //Map userMap = jsonDecode(item.toString());
          //List jsonResponse = item; //userMap["result"];
          var pa = new PackageInfo.fromJson(item);
          parsedList.add(pa);

          /*return jsonResponse
              .map((data) => new PackageInfo.fromJson(data))
              .toList();*/
        }

        //final List<PackageInfo> parsedList = parseObject;//parseObject.decode(res);

        /*List<PackageInfo> list =
            userMap[1].map((val) => PackageInfo.fromJson(val)).toList();
        print(list.length); */
      }
    }

    return parsedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packages in Box ' + box.name),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () => {}),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<PackageInfo>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<PackageInfo> data = snapshot.data;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Image.asset(data[index].locationstring),
                      enabled: true,
                      title: Text(data[index].item),
                      subtitle: Text('(' +
                          data[index].trackingno +
                          ') - ' +
                          data[index].fullname),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PackageDetails(package: data[index])),
                        );
                      },
                      trailing: Icon(
                        Icons.chevron_right,
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
