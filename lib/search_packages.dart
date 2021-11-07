import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'package:trackngo/helper/myalerts.dart';
import 'package:trackngo/package_details.dart';
import 'package:trackngo/widgets/refresh_widget.dart';
import './models/PackageInfo.dart';
import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'helper/HexColor.dart';
import 'models/FilterRequestData.dart';

class SearchPackages extends StatefulWidget {
  @override
  _SearchPackagesState createState() => _SearchPackagesState();
}

class _SearchPackagesState extends State<SearchPackages> {


  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  String _selectedLocation1;
  String _selectedLocation2;
  String date;
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  FilterRequestData _FilterData = FilterRequestData();

  List<String> _locations1 = [
    'Any Status',
    'Transit',
    'In Box',
    'Seized',
    'Delivered',
    'Out for Delivery',
    'Ready for Pickup',
    'Lost'
  ];
  List<String> _locations2 = [
    'Any Location',
    'At Miami Warehouse',
    'At MIA',
    'At JA Customs',
    'heading to store',
    'At Store',
    'Delivered'
  ];

  bool _conditionValue = false;
  bool _conditionValue1 = false;
  bool _conditionValue2 = false;


  @override
  void initState() {
    super.initState();

    fetchData();
  }


  void acceptCondition(bool value) {
    setState(() {
      _conditionValue = value; //Debug the choice in console
    });
  }

  void acceptCondition1(bool value) {
    setState(() {
      _conditionValue1 = value; //Debug the choice in console
    });
  }

  void acceptCondition2(bool value) {
    setState(() {
      _conditionValue2 = value; //Debug the choice in console
    });
  }

  final format = DateFormat("yyyy/MM/dd");



  // RefreshController _refreshController =
  // RefreshController(initialRefresh: false);
  //
  // void _onRefresh() async{
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use refreshFailed()
  //   _refreshController.refreshCompleted();
  // }
  //
  // void _onLoading() async{
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //
  //
  //   // parsedList.add((parsedList.length+1).toString());
  //
  //   if(mounted)
  //     setState(() {
  //
  //     });
  //   _refreshController.loadComplete();
  // }



  List<PackageInfo> parsedList = [];

  Future<List<PackageInfo>> fetchData() async {

    keyRefresh.currentState?.show();
    await Future.delayed(Duration(milliseconds: 2000));



    final ParseCloudFunction function = ParseCloudFunction('get_all_packages');
    final ParseResponse result =
    await function.executeObjectFunction<ParseObject>();
    if (result.success) {
      if (result.result is ParseObject) {
        Map userMap = jsonDecode(result.result.toString());
        List jsonResponse = userMap["result"];
        parsedList =
            jsonResponse.map((data) => new PackageInfo.fromJson(data)).toList();
        return jsonResponse
            .map((data) => new PackageInfo.fromJson(data))
            .toList();
        //final List<PackageInfo> parsedList = parseObject;//parseObject.decode(res);

        List<PackageInfo> list =
        userMap[1].map((val) => PackageInfo.fromJson(val)).toList();
        print(list.length);
      }
    }

    return parsedList;
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for Packages'),
        actions: [
          IconButton(
              icon: Icon(Icons.search), onPressed: () => {searchpopup()}),
        ],
      ),
      body: RefreshWidget(
        keyRefresh: keyRefresh,
        onRefresh: fetchData,
        child: Center(
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
                        title: Text(data[index].trackingno),
                        subtitle: Text('(' +
                            data[index].item +
                            ') - ' +
                            data[index].tngono +
                            ' ' +
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
      ),
    );
  }

  searchpopup() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 16,
          child: Container(
            height: 600.0,
            width: 700.0,
            child: Form(
              key: _key,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Search Parameters",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text('TrackingNo'),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          padding:
                          EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: HexColor('#E5E5E5'), width: 1)),
                          child: TextFormField(
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Enter Tracking Number"),
                            onChanged: (value) {
                              _FilterData.tracking = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text('TNG-No.'),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          padding:
                          EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: HexColor('#E5E5E5'), width: 1)),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Track-N-Go Number"),
                            onChanged: (value) {
                              _FilterData.tngno = int.parse(value);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text('Name'),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          padding:
                          EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: HexColor('#E5E5E5'), width: 1)),
                          child: TextFormField(
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Enter Owner Name"),
                            onChanged: (value) {
                              _FilterData.owner = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              Text('Created'),
                              //Text('between'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          padding:
                          EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          decoration:
                          BoxDecoration(border: Border.all(width: 1)),
                          child: DateTimeField(
                            format: format,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.calendar_today),
                              hintText: 'yyyy/MM/dd',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.all(5),
                            ),
                            onChanged: (DateTime currentValue) {
                              if (currentValue != null) {
                                setState(() {
                                  _FilterData.start_date = currentValue;
                                });
                              } else {
                                _FilterData.start_date = null;
                              }
                            },
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                context: context,
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: ColorScheme.light().copyWith(
                                        primary: HexColor("#f7ce0f"),
                                      ),
                                    ),
                                    child: child,
                                  );
                                },
                                firstDate: DateTime(2015),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100),
                                helpText: 'Select Purchase date',
                                errorFormatText: 'Enter valid date',
                                errorInvalidText: 'Enter date in valid range',
                                // confirmText: 'Book',
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          padding:
                          EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: HexColor('#E5E5E5'), width: 1)),
                          child: DateTimeField(
                            format: format,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.calendar_today),
                              hintText: 'yyyy/MM/dd',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.all(5),
                            ),
                            onChanged: (DateTime currentValue) {
                              if (currentValue != null) {
                                setState(() {
                                  _FilterData.end_date = currentValue;
                                  /*new DateFormat('yyyy/MM/dd')
                                      .format(currentValue);*/
                                });
                              } else {
                                _FilterData.end_date = null;
                              }
                            },
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                context: context,
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: ColorScheme.light().copyWith(
                                        primary: HexColor("#f7ce0f"),
                                      ),
                                    ),
                                    child: child,
                                  );
                                },
                                firstDate: DateTime(2015),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100),
                                helpText: 'Select Purchase date',
                                errorFormatText: 'Enter valid date',
                                errorInvalidText: 'Enter date in valid range',
                                // confirmText: 'Book',
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text('Status'),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          padding:
                          EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: HexColor('#E5E5E5'), width: 1)),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            decoration: InputDecoration.collapsed(hintText: ''),
                            value: _selectedLocation1,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedLocation1 = newValue;
                              });
                            },
                            onSaved: (newValue) {
                              setState(() {
                                _FilterData.status = newValue;
                              });
                            },
                            items: _locations1
                                .map<DropdownMenuItem<String>>(
                                    (value) => new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                ))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Text('Location'),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          padding:
                          EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: HexColor('#E5E5E5'), width: 1)),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            decoration: InputDecoration.collapsed(hintText: ''),
                            hint: Text('At Warehouse'),
                            value: _selectedLocation2,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedLocation2 = newValue;
                              });
                            },
                            onSaved: (newValue) {
                              setState(() {
                                _FilterData.location = newValue;
                              });
                            },
                            items: _locations2
                                .map<DropdownMenuItem<String>>(
                                    (value) => new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                ))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
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
                              child: new Text('Filter',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                              color: HexColor('#333333'),
                              onPressed: () async {
                                if (true) {
                                  //(_key.currentState.validate()) {
                                  // No any error in validation
                                  //_key.currentState.save();
                                  if (_FilterData.start_date != null &&
                                      _FilterData.end_date != null &&
                                      _FilterData.status != null &&
                                      _FilterData.location != null &&
                                      _FilterData.date_check != null &&
                                      _FilterData.status_check != null &&
                                      _FilterData.location_check != null) {
                                    TrackAlerts.showAlertLoading(
                                        'Searching....', context);

                                    final ParseCloudFunction function =
                                    ParseCloudFunction('get_all_packages');

                                    final Map<String, dynamic> params2 =
                                    new Map<String, dynamic>();
                                    if (_FilterData.start_date != null) {
                                      params2.addAll(<String, dynamic>{
                                        'sdate': _FilterData.start_date
                                      });
                                    }

                                    if (_FilterData.end_date != null) {
                                      params2.addAll(<String, dynamic>{
                                        'ndate': _FilterData.end_date
                                      });
                                    }

                                    if (_FilterData.status.toLowerCase() !=
                                        "" &&
                                        _FilterData.status.toLowerCase() !=
                                            'any status') {
                                      params2.addAll(<String, dynamic>{
                                        'status': _FilterData.status
                                      });
                                    }

                                    if (_FilterData.location.toLowerCase() !=
                                        "" &&
                                        _FilterData.location.toLowerCase() !=
                                            'any location') {
                                      params2.addAll(<String, dynamic>{
                                        'location': _FilterData.status
                                      });
                                    }

                                    final ParseResponse result = await function
                                        .execute(parameters: params2);
                                    //final ParseResponse result =
                                    //await function.executeObjectFunction<ParseObject>();

                                    //Response result = await Search(params);
                                    if (result.success) {
                                      Navigator.pop(context, result);
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      /*ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text("Location Updated")));*/

                                      //update results
                                      setState(() {});
                                    } else {
                                      /*  Map<String, dynamic> mapResponse = json.decode(result.body); */
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      TrackAlerts.showAlertError(
                                          'error: ' + result.error.message,
                                          context);
                                    }
                                  } else {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    TrackAlerts.showAlertError(
                                        'Error', context);
                                  }
                                } else {
                                  // validation error
                                  setState(() {
                                    _validate = true;
                                  });
                                }
                              }),
                          new SizedBox(
                            width: 10.0,
                          ),
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
}
