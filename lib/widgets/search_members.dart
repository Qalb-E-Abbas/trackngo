import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:trackngo/models/MemberInfo.dart';
import 'package:trackngo/package_details.dart';
import 'dart:convert';

import 'package:trackngo/widgets/member_details.dart';

class SearchMembers extends StatefulWidget {
  @override
  _SearchMembersState createState() => _SearchMembersState();
}

class _SearchMembersState extends State<SearchMembers> {
  Future<List<MemberInfo>> fetchData() async {
    List<MemberInfo> parsedList = [];

    final ParseCloudFunction function = ParseCloudFunction('get_all_members');
    final ParseResponse result =
        await function.executeObjectFunction<ParseObject>();
    if (result.success) {
      if (result.result is ParseObject) {
        Map userMap = jsonDecode(result.result.toString());
        List jsonResponse = userMap["result"];
        parsedList =
            jsonResponse.map((data) => new MemberInfo.fromJson(data)).toList();
        return jsonResponse
            .map((data) => new MemberInfo.fromJson(data))
            .toList();
        //final List<PackageInfo> parsedList = parseObject;//parseObject.decode(res);

        List<MemberInfo> list =
            userMap[1].map((val) => MemberInfo.fromJson(val)).toList();
        print(list.length);
      }
    } else {}

    return parsedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member Directory'),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () => {}),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<MemberInfo>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<MemberInfo> data = snapshot.data;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Image.asset(data[index].getMemberString()),
                      enabled: true,
                      title: Text(data[index].getFullName()),
                      subtitle: Text('TNGNO: ' + data[index].tngNo),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MemberDetails(member: data[index])),
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
