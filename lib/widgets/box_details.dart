import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:trackngo/box_packages.dart';
import 'package:trackngo/helper/HexColor.dart';
import 'package:trackngo/helper/ListData.dart';
import 'package:trackngo/helper/myalerts.dart';
import 'package:trackngo/models/BusRequestData.dart';
import 'package:trackngo/models/BoxInfo.dart';
import 'package:trackngo/models/StatusUpdate.dart';
import 'package:trackngo/widgets/BoxPrint.dart';

import '../scan_page.dart';

class BoxDetails extends StatefulWidget {
  BoxInfo box = new BoxInfo();
  String action = '';
  BoxDetails({this.box, this.action}) {}

  @override
  _BoxDetailsState createState() => _BoxDetailsState(this.box, this.action);
}

String _chosenValue = 'I\'m not able to help';

class _BoxDetailsState extends State<BoxDetails> {
  BoxInfo box = new BoxInfo();
  String action = '';
  _BoxDetailsState(this.box, this.action) {
    /*for (var item in package.updates) {
      StatusUpdate su = new StatusUpdate(
          created: item['created'],
          status: item['status'],
          doneby: item['doneby']);
      this.statuses.add(su);
    }
    this.statuses = this.statuses.reversed.toList();*/
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (action != null) {
        if (action.toLowerCase() == "packageadd") {
          dopackagescan();
        }
      }
    });
  }

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  final _propkey = new GlobalKey<FormState>();

  String selectedCity;

  final TextEditingController controllerCategory = TextEditingController();

  String _selectedLocation;
  String _selectedStatus;

  List<String> _locations = ListData.getPackageSatuses();

  List<String> _reallocs = ListData.getPackageLocations();

  BusRequestData _BusData = BusRequestData();

  String _scanBarcode = 'Unknown';
  List<StatusUpdate> statuses = [];

  Future changeStatusDialog(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select the new item status'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                new DropdownButton<String>(
                  items: <String>['A', 'B', 'C', 'D'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    if (value != null) {
                      setState() => print(value);
                    }
                  },
                )
                //your code dropdown button here
              ]);
            },
          ),
        );
      },
    );
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
                      "Change Box Status",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    decoration: BoxDecoration(
                        border:
                        Border.all(color: HexColor('#E5E5E5'), width: 1)),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      decoration: InputDecoration.collapsed(hintText: ''),
                      hint: Text('Please Select'),
                      value: _selectedStatus,
                      onChanged: (String newValue) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                      },
                      onSaved: (String newValue) {
                        setState(() {
                          if (newValue != null) {
                            _BusData.select_network = newValue;
                          }
                        });
                      },
                      items: _locations
                          .map<DropdownMenuItem<String>>(
                              (value) => new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          ))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new MaterialButton(
                                elevation: 0,
                                height: 40.0,
                                child: new Text('Change Status',
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
                                    if (_BusData.select_network != null) {
                                      _showAlertLoading("Loading...");
                                      //Update an existing task

                                      final ParseCloudFunction function =
                                      ParseCloudFunction('update_box');
                                      final Map<String, String> params2 =
                                      <String, String>{'boxid': box.id};
                                      params2.addAll(<String, String>{
                                        'status': _BusData.select_network
                                      });
                                      final ParseResponse result = await function
                                          .execute(parameters: params2);
                                      //final ParseResponse result =
                                      //await function.executeObjectFunction<ParseObject>();

                                      //Response result = await Search(params);
                                      if (result.success) {
                                        Navigator.pop(context, result);
                                        Navigator.of(context, rootNavigator: true)
                                            .pop();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                            content: Text("Status Updated")));

                                        //update table
                                        setState(() {
                                          this.box =
                                              BoxInfo.fromJson(result.result);
                                        });
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

  dolocpop() {
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
                      "Change Box Location",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    decoration: BoxDecoration(
                        border:
                        Border.all(color: HexColor('#E5E5E5'), width: 1)),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      decoration: InputDecoration.collapsed(hintText: ''),
                      hint: Text('Please Select'),
                      value: _selectedLocation,
                      onChanged: (String newValue) {
                        setState(() {
                          _selectedLocation = newValue;
                        });
                      },
                      onSaved: (String newValue) {
                        setState(() {
                          if (newValue != null) {
                            _BusData.select_network = newValue;
                          }
                        });
                      },
                      items: _reallocs
                          .map<DropdownMenuItem<String>>(
                              (value) => new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          ))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  FittedBox(
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new MaterialButton(
                                elevation: 0,
                                height: 40.0,
                                child: new Text('Change Location',
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
                                    if (_BusData.select_network != null) {
                                      _showAlertLoading("Loading...");
                                      //Update an existing task

                                      final ParseCloudFunction function =
                                      ParseCloudFunction('update_box');
                                      final Map<String, String> params2 =
                                      <String, String>{'boxid': box.id};
                                      params2.addAll(<String, String>{
                                        'location': _BusData.select_network
                                      });
                                      final ParseResponse result = await function
                                          .execute(parameters: params2);
                                      //final ParseResponse result =
                                      //await function.executeObjectFunction<ParseObject>();

                                      //Response result = await Search(params);
                                      if (result.success) {
                                        Navigator.pop(context, result);
                                        Navigator.of(context, rootNavigator: true)
                                            .pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                            content:
                                            Text("Location Updated")));

                                        //update table
                                        setState(() {
                                          this.box =
                                              BoxInfo.fromJson(result.result);
                                        });
                                      } else {
                                        /*  Map<String, dynamic> mapResponse = json.decode(result.body); */
                                        Navigator.of(context, rootNavigator: true)
                                            .pop();
                                        _showAlertError(
                                            'error: ' + result.error.message);
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

  camerascan() {
    scanBarcodeNormal();
  }

  dopackagescan() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ScanPage(
            screen: 'Add Package to Box via:',
          )),
    );
  }

  devicescan() {
    print('device scan');
  }

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        "#ff6666", "Cancel", true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

/*
  doChangeProperties() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 16,
            child: Container(
              height: 450,
              padding: EdgeInsets.all(24),
              child: Form(
                key: _propkey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30),
                    Center(
                      child: Text(
                        "Update Package Properties",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                            child: TypeAheadFormField<String>(
                          textFieldConfiguration: TextFieldConfiguration(
                              decoration: InputDecoration(
                                  labelText: 'Item Category',
                                  border: OutlineInputBorder()),
                              controller: controllerCategory),
                          suggestionsCallback: CategoriesList.getSuggestions,
                          itemBuilder: (context, String suggestion) => ListTile(
                            title: Text(suggestion),
                          ),
                          onSuggestionSelected: (String suggestion) =>
                              (controllerCategory.text = suggestion),
                          validator: (value) {
                            return (value != null && value.isEmpty
                                ? 'Please select an Item Category'
                                : null);
                          },
                          onSaved: (value) => pp.category = value,
                        )),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Enter Item Weight',
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => {
                                if (value != '' && value != null)
                                  {pp.weight = double.parse(value)}
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: 'Enter Item Cost',
                                    border: OutlineInputBorder()),
                                keyboardType: TextInputType.number,
                                onSaved: (value) => {
                                      if (value != '' && value != null)
                                        {pp.cost = double.parse(value)}
                                    }),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () async {
                                  final form = _propkey.currentState;
                                  if (form.validate()) {
                                    form.save();

                                    //do parse update
                                    final ParseCloudFunction function =
                                        ParseCloudFunction('update_package');

                                    Map<String, String> params2 =
                                        <String, String>{
                                      'tracking': package.trackingno
                                    };

                                    if (pp.category != null) {
                                      params2.addAll(<String, String>{
                                        'category': pp.category
                                      });
                                    }

                                    if (pp.cost != null) {
                                      params2.addAll(<String, String>{
                                        'cost': pp.cost.toString()
                                      });
                                    }

                                    if (pp.weight != null) {
                                      params2.addAll(<String, String>{
                                        'weight': pp.weight.toString()
                                      });
                                    }

                                    _showAlertLoading("Loading...");

                                    final ParseResponse result = await function
                                        .execute(parameters: params2);

                                    if (result.success) {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text("Properties Updated")));
                                      //update table
                                      setState(() {
                                        this.package =
                                            PackageInfo.fromJson(result.result);
                                      });
                                    } else {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text("Update failed")));
                                    }
                                  }
                                },
                                child: Text("Submit")),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: Text("Cancel")),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
*/
// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes = '';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE)
          .then((value) async {
        barcodeScanRes = value;
        if (value != "-1") {
          print(value);
          //FlutterBeep.beep();
          final ParseCloudFunction function = ParseCloudFunction('add_to_box');
          final Map<String, String> params2 = <String, String>{
            'memberid': box.id
          };
          params2.addAll(<String, String>{'boxid': value});

          try {
            final ParseResponse result =
            await function.execute(parameters: params2);

            if (result.success) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Added to Box")));
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(result.error.message)));
            }
          } on Exception catch (_) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Error adding to Box")));
          }
        }
      });
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(box.id),
        ),
        body: Builder(
          builder: (context) => SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 1),
                  //child: new Center(
                  child: Wrap(
                    spacing: 3,
                    runSpacing: 5,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      new ElevatedButton(
                        child: new Text('Add Package'),
                        onPressed: dopackagescan,
                      ),
                      new ElevatedButton(
                        child: new Text('Update Location'),
                        onPressed: dolocpop,
                      ),
                      new ElevatedButton(
                        child: new Text('Update Status'),
                        onPressed: dopop,
                      ),
                      new ElevatedButton(
                        child: new Text('Print Label'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BoxPrint(this.box)),
                          );
                        },
                      ),
                    ],
                  ),
                  //),
                ),
                new ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  //alignment: MainAxisAlignment.center,// this will take space as minimum as posible(to center)
                  children: <Widget>[],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: SingleChildScrollView(
                    child: Table(
                      // textDirection: TextDirection.rtl,
                      // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                      columnWidths: {
                        0: FlexColumnWidth(1),
                        // this column has a fixed width of 50
                        1: FlexColumnWidth(2),
                        // take 1/3 of the remaining space
                      },
                      border:
                      TableBorder.all(width: 1.0, color: Colors.blueGrey),
                      children: [
                        TableRow(children: [
                          Text("ID",
                              textScaleFactor: 1.5,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(this.box.id, textScaleFactor: 1.5),
                        ]),
                        TableRow(children: [
                          Text("Nickname",
                              textScaleFactor: 1.5,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(this.box.name, textScaleFactor: 1.5),
                        ]),
                        TableRow(children: [
                          Text("Location",
                              textScaleFactor: 1.5,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(this.box.location, textScaleFactor: 1.5),
                        ]),
                        TableRow(children: [
                          Text("Status",
                              textScaleFactor: 1.5,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(this.box.status, textScaleFactor: 1.5),
                        ]),
                        TableRow(children: [
                          Text("Packages",
                              textScaleFactor: 1.5,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BoxPackages(box: this.box)),
                              );
                            },
                            child: Text(
                                'See all ' +
                                    this.box.packageCount +
                                    ' packages',
                                textScaleFactor: 1.5),
                          )
                        ]),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(25),
                    child: SingleChildScrollView(
                      child: Table(

                        // textDirection: TextDirection.rtl,
                        // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                          columnWidths: {
                            0: FlexColumnWidth(1),
                            // this column has a fixed width of 50
                            1: FlexColumnWidth(2),
                            // take 1/3 of the remaining space
                          }, children: [
                        TableRow(children: [
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: statuses.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    title: Text(statuses[index].status),
                                    subtitle: Text(statuses[index].doneby +
                                        ' ' +
                                        statuses[index].created),
                                  ),
                                );
                              })
                        ])
                      ]),
                    ))
              ],
            ),
          ),
        ));
  }
}
