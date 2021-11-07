import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:trackngo/helper/HexColor.dart';
import 'package:trackngo/models/BoxInfo.dart';
import 'package:trackngo/widgets/box_details.dart';
import 'dart:convert';

class SearchBoxes extends StatefulWidget {
  @override
  _SearchBoxesState createState() => _SearchBoxesState();
}

class _SearchBoxesState extends State<SearchBoxes> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  String newBoxName = '';
  final _propkey = new GlobalKey<FormState>();

  String selectedCity;

  Future<List<BoxInfo>> fetchData() async {
    List<BoxInfo> parsedList = [];

    final ParseCloudFunction function = ParseCloudFunction('get_all_boxes');
    final ParseResponse result =
        await function.executeObjectFunction<ParseObject>();
    if (result.success) {
      if (result.result is ParseObject) {
        Map userMap = jsonDecode(result.result.toString());
        List jsonResponse = userMap["result"];
        parsedList =
            jsonResponse.map((data) => new BoxInfo.fromJson(data)).toList();
        return jsonResponse.map((data) => new BoxInfo.fromJson(data)).toList();
        //final List<PackageInfo> parsedList = parseObject;//parseObject.decode(res);

        List<BoxInfo> list =
            userMap[1].map((val) => BoxInfo.fromJson(val)).toList();
        print(list.length);
      }
    } else {
      _showAlertError('Error getting packages for Box selected');
    }

    return parsedList;
  }

  _showAlertLoading(message) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
//                title: Text('Error!!'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 30),
                          Text(
                            message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {},
    );
  }

  _showAlertError(message) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
//                title: Text('Error!!'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(
                                    color: (Colors.grey[700]), width: 2.0)),
                            child: new RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: EdgeInsets.only(left: 30.0, right: 30.0),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK',
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500)),
                            ),
                          )
                        ])
                  ],
                )),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {},
    );
  }

  dopop() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 16,
          child: Container(
            height: 250.0,
            width: 300.0,
            child: Form(
              key: _key,
              autovalidate: _validate,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Create New Shipping Box",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        style: TextStyle(fontSize: 24),
                        onChanged: (String newValue) {
                          if (newValue != null) {
                            newBoxName = newValue;
                          }
                        },
                        onSaved: (String newValue) {
                          if (newValue != null) {
                            newBoxName = newValue;
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 25.0, horizontal: 10.0),
                          hintText: "Enter a Nickname",
                        )),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new MaterialButton(
                              elevation: 0,
                              height: 40.0,
                              child: new Text('Create Box',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                              color: HexColor('#333333'),
                              onPressed: () async {
                                if (_key.currentState.validate()) {
                                  // No any error in validation
                                  _key.currentState.save();
                                  if (newBoxName != null) {
                                    _showAlertLoading("Loading...");
                                    //Update an existing task

                                    final ParseCloudFunction function =
                                        ParseCloudFunction('create_box');
                                    final Map<String, String> params2 =
                                        <String, String>{'name': newBoxName};

                                    final ParseResponse result = await function
                                        .execute(parameters: params2);

                                    if (result.success) {
                                      Navigator.pop(context, result);
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();

                                      /*ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text("Box Updated")));

                                              */

                                      //navigate to Box Details

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BoxDetails(
                                                box: BoxInfo.fromJson(
                                                    result.result))),
                                      );

                                      /*Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => new MyApp()));*/
                                    } else {
                                      /*  Map<String, dynamic> mapResponse = json.decode(result.body); */
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      if (result.error != null) {
                                        _showAlertError(
                                            'error: ' + result.error.message);
                                      }
                                    }
                                  }
                                } else {
                                  // validation error
                                  setState(() {
                                    _validate = true;
                                  });
                                }
                              }),
                          new SizedBox(width: 10.0),
                          new MaterialButton(
                              elevation: 0,
                              height: 40.0,
                              child: new Text('Cancel',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                              color: HexColor('#333333'),
                              onPressed: () async {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          dopop();
        },
      ),
      appBar: AppBar(
        title: Text('Box Listing'),
      ),
      body: Center(
        child: FutureBuilder<List<BoxInfo>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<BoxInfo> data = snapshot.data;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      isThreeLine: true,
                      leading: Image.asset(data[index].getBoxInfo()),
                      enabled: true,
                      title: Text(data[index].name),
                      subtitle: Text(data[index].location +
                          '  (' +
                          data[index].status +
                          ')\n Package Count: ' +
                          data[index].packageCount.toString()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BoxDetails(
                                    box: data[index],
                                    action: '',
                                  )),
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
