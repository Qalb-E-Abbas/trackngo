import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:trackngo/widgets/box_details.dart';
//import 'package:flutter_beep/flutter_beep.dart';

import 'helper/HexColor.dart';
import 'helper/ListData.dart';
import 'helper/myalerts.dart';
import 'models/BoxInfo.dart';
import 'models/BusRequestData.dart';

class ScanPage extends StatefulWidget {
  final String screen;
  final String params;
  ScanPage({this.screen, this.params});

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", "Cancel", true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  @override
  _ScanPageState createState() => _ScanPageState(screen, params);
}

class _ScanPageState extends State<ScanPage> {
  String screen;
  String params;
  Color bgcolor;
  bool manual = true;

  GlobalKey<FormState> _key = new GlobalKey();
  GlobalKey<FormState> _key2 = new GlobalKey();
  final _propkey = new GlobalKey<FormState>();

  String selectedCity;

  int _selectedtngo;
  String _selectedtracking;
  String _selectedmerchant;

  bool _validate = false;

  final TextEditingController controllerCategory = TextEditingController();

  var scantext = 'Choose an option from below:';
  String _scanBarcode = 'Unknown';

  var isbox = false;

  BusRequestData _BusData = BusRequestData();

  String _selectedLocation;
  List<String> _statuses = ListData.getPackageSatuses();

  List<String> _reallocs = ListData.getPackageLocations();
  /*List<String> _reallocs = [
    'Miami Warehouse',
    'Miami Airport',
    'In Transit to Jamaica',
    'JA Customs',
    'Ready for Pickup',
    'Out for Delivery',
    'Delivered'
  ];*/

  _ScanPageState(this.screen, [String params]) {
    switch (this.screen) {
      case "Scan New Package":
        bgcolor = Colors.pink;
        manual = true;
        isbox = false;
        break;

      case 'Update Box Location':
        bgcolor = Colors.deepOrange;
        isbox = true;
        manual = true;
        break;

      case 'Re-package Items':
        bgcolor = Colors.yellow;
        scantext = "Select Box to add packages via:";
        manual = true;
        isbox = true;
        break;

      case 'Update Box Status':
        bgcolor = Colors.blue;
        scantext = "Select Box to add packages via:";
        manual = true;
        isbox = true;
        break;

      case 'Add package to Box':
        bgcolor = Colors.blue;
        scantext = "Select Box to add packages via:";
        manual = true;
        isbox = true;
        break;

      default:
        bgcolor = Colors.lightBlue;
        break;
    }
  }

  camerascan() {
    scanBarcodeNormal();
  }

  devicescan() {
    domanual();
  }

  getBox(String id) async {
    final ParseCloudFunction function = ParseCloudFunction('box_get');

    final Map<String, String> params2 = <String, String>{'boxid': id};
    final ParseResponse result = await function.execute(parameters: params2);
    if (result.success) {
      //if (result.result is Map) {
      Map userMap = result.result[0];
      var bx = new BoxInfo.fromJson(userMap);
      return bx;
    }
  }

  progressapp(String id) async {
    switch (this.screen) {
      case "Scan New Package":
        bgcolor = Colors.pink;
        manual = true;
        isbox = false;
        break;

      case 'Update Box Location':
        await dolocpop();
        //take id and get box and pass to box screen
        /*var bx = await getBox(id);
        //on box screen call addpackage
        if (bx != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BoxDetails(
                        box: bx,
                        action: 'updatelocation',
                      )));*/
        //}
        break;

      case 'Re-package Items':
        //take id and get box and pass to box screen
        var bx = await getBox(id);
        //on box screen call addpackage
        if (bx != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BoxDetails(
                        box: bx,
                        action: 'packageadd',
                      )));
        }
        break;

      case 'Update Box Status':
        //take id and get box and pass to box screen
        dostatpop();

        break;

      case 'Add package to Box':
        //take id and get box and pass to box screen
        final ParseCloudFunction function = ParseCloudFunction('add_to_box');
        var pid = this.params;
        var bid = _selectedtracking;
        final Map<String, String> params2 = <String, String>{
          'boxid': bid,
          'tracking': pid
        };
        final ParseResponse result =
            await function.execute(parameters: params2);
        if (result.success) {
          //if (result.result is Map) {

          /* Map userMap =
                                          jsonDecode(result.result.toString());
                                      var bx = new BoxInfo.fromJson(userMap);
                                      List jsonResponse = userMap["result"];
                                      parsedList = jsonResponse
                                          .map((data) =>
                                              new BoxInfo.fromJson(data))
                                          .toList();*/
          //return jsonResponse.map((data) => new BoxInfo.fromJson(data)).toList();
          //final List<PackageInfo> parsedList = parseObject;//parseObject.decode(res);

          //}
        } else {
          _showAlertError('Error adding package to Box');
        }

        break;

      default:
        bgcolor = Colors.lightBlue;
        break;
    }
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

  Future <void> scanBarcodeNormal() async {

    try{
      final barCode = await FlutterBarcodeScanner.scanBarcode("#ff6666",
          "Cancel", true, ScanMode.BARCODE);

      if(!mounted) return;

      setState(() {
        domanual();
        this._scanBarcode = barCode;
      });
    } on PlatformException{
      _scanBarcode = 'Failed to get';
    }


  }
//
// // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> scanBarcodeNormal() async {
//     String barcodeScanRes = '';
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       FlutterBarcodeScanner.scanBarcode(
//               "#ff6666", "Cancel", true, ScanMode.BARCODE)
//           .then((value) async {
//         barcodeScanRes = value;
//         //if (value != "-1") {
//         print(value);
//         //FlutterBeep.beep();
//         _selectedtracking = value;
//         await progressapp(value);
//         //}
//       });
//     } on PlatformException {
//       barcodeScanRes = 'Failed to get platform version.';
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     setState(() {
//       domanual();
//       _scanBarcode = barcodeScanRes;
//     });
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.screen),
        backgroundColor: this.bgcolor,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(scantext,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black)),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                primary: false,
                children: [
                  Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: new InkWell(
                        onTap: devicescan,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 10),
                            Image.asset(
                              'assets/images/device.png',
                              height: 120,
                              width: 120,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(height: 5),
                            Text('Device Scan',
                                style: TextStyle(
                                    fontFamily: 'NotoSans',
                                    fontSize: 18,
                                    color: Colors.black))
                          ],
                        ),
                      )),
                  Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: new InkWell(
                        onTap: camerascan,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 10),
                            Image.asset(
                              'assets/images/camera.png',
                              height: 120,
                              width: 120,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(height: 5),
                            Text('Camera Scan',
                                style: TextStyle(
                                    fontFamily: 'NotoSans',
                                    fontSize: 18,
                                    color: Colors.black))
                          ],
                        ),
                      )),

                  Visibility(
                    child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: new InkWell(
                          onTap: domanual,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 10),
                              Image.asset(
                                'assets/images/pencil.png',
                                height: 120,
                                width: 120,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(height: 5),
                              Text('Manual add',
                                  style: TextStyle(
                                      fontFamily: 'NotoSans',
                                      fontSize: 18,
                                      color: Colors.black))
                            ],
                          ),
                        )),
                    visible: manual,
                  ),
                  //ElevatedButton(onPressed: null, child: Text('Set Properties'))
                ]),
          ),
          /*ToggleSwitch(
            minWidth: 90.0,
            cornerRadius: 20.0,
            activeBgColor: Colors.cyan,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            labels: ['Multiple Scans', 'Single Scan'],
            icons: [FontAwesomeIcons.check, FontAwesomeIcons.times],
            onToggle: (index) {
              print('switched to: $index');
            },
          ),*/
        ],
      ),
    );
  }

  Future performAction(String value) async {
    switch (this.screen) {
      case "Scan New Package":
        //Ask for TNGNO

        //Merchant

        //Tracking No

        //Call register_new_package
        break;

      case 'Update Box Location':
        // popup for location
        dolocpop();

        // call update_box_location with boxid and cation

        break;

      case 'Re-package Items':
        break;

      case 'Update Package Status':
        bgcolor = Colors.blue;
        break;

      default:
        bgcolor = Colors.lightBlue;
        break;
    }
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

  manualtracking() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 16,
          child: Container(
            height: 500.0,
            width: 400.0,
            child: Form(
              key: _key,
              autovalidate: _validate,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Manually Add Package",
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
                        autofocus: true,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: _scanBarcode,
                          border: OutlineInputBorder(),
                          labelText: 'Enter Tracking Number here',
                          contentPadding: EdgeInsets.all(20.0),
                        ),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        onChanged: (String newValue) {
                          _selectedtracking = newValue;
                        },
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter a Tracking Number';
                          }
                        }),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Member No.',
                        contentPadding: EdgeInsets.all(20.0),
                      ),
                      onChanged: (String newValue) {
                        _selectedtngo = int.parse(newValue);
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter a Memeber number';
                        }
                        try {
                          int.parse(value);
                          return null;
                        } catch (exception) {
                          return 'invalid number';
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Merchant',
                        contentPadding: EdgeInsets.all(20.0),
                      ),
                      onChanged: (String newValue) {
                        _selectedmerchant = newValue;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter Merchant';
                        }
                      },
                    ),
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
                              child: new Text('Add Package',
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
                                        ParseCloudFunction(
                                            'register_new_package');
                                    final Map<String, dynamic> params2 =
                                        <String, dynamic>{
                                      'tracking': _selectedtracking
                                    };
                                    params2.addAll(<String, dynamic>{
                                      'tngono': _selectedtngo,
                                      'merchant': _selectedmerchant
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
                                        // this.box =
                                        // BoxInfo.fromJson(result.result);
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
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  domanual() {
    if (isbox == true) {
      manualbox();
    } else {
      manualtracking();
    }
  }

  manualbox() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 16,
          child: Container(
            height: 500.0,
            width: 400.0,
            child: Form(
              key: _key2,
              autovalidate: _validate,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Enter Box Details",
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
                        autofocus: true,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Box ID here',
                          contentPadding: EdgeInsets.all(20.0),
                        ),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        onChanged: (String newValue) {
                          _selectedtracking = newValue;
                        },
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter a Box ID';
                          }
                        }),
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
                              child: new Text('Next',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                              color: HexColor('#333333'),
                              onPressed: () {
                                progressapp(_selectedtracking);
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

  dostatpop() {
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
                      items: _statuses
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
                                        <String, String>{
                                      'boxid': _selectedtracking
                                    };
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
                                      /* setState(() {
                                        this.box =
                                            BoxInfo.fromJson(result.result);
                                      });
                                     Navigator.push(
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
                      "Change Package Location",
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
                          if (newValue != null)
                            _BusData.select_network = newValue;
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
                              child: new Text('Change Loc.',
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
                                    TrackAlerts.showAlertLoading(
                                        "Loading...", context);
                                    //Update an existing task
                                    Map<String, dynamic> params =
                                        Map<String, dynamic>();
                                    // params["select_status"] =  _BusData.select_network;

                                    final ParseCloudFunction function =
                                        ParseCloudFunction('update_box');
                                    final Map<String, String> params2 =
                                        <String, String>{
                                      'boxid': _selectedtracking
                                    };
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
                                        //this.package = PackageInfo.fromJson(result.result);
                                      });
                                    } else {
                                      /*  Map<String, dynamic> mapResponse = json.decode(result.body); */
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      if (result.error != null) {
                                        TrackAlerts.showAlertError(
                                            'error: ' + result.error.message,
                                            context);
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
}
