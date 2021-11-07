import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trackngo/search_packages.dart';
import 'package:trackngo/widgets/search_boxes.dart';
import 'package:trackngo/widgets/search_members.dart';
import 'scan_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  searchpressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPackages()),
    );

  }

  scanpressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ScanPage(
            screen: 'Scan New Package',
          )),
    );
  }

  updateloc() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ScanPage(
            screen: 'Update Box Location',
          )),
    );
  }

  repackagepack() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ScanPage(
            screen: 'Re-package Items',
          )),
    );
  }

  updatepackstatus() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ScanPage(
            screen: 'Update Box Status',
          )),
    );
  }

  memberdirectory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchMembers()),
    );
  }

  boxlist() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchBoxes()),
    );
  }

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _colorFromHex('#262b2f'),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage('assets/images/top_header.png'))),
          ),
          SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 64,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: AssetImage('assets/images/tng.png'),
                          ),
                          SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Michael McDermott',
                                style: TextStyle(
                                    fontFamily: 'NotoSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                              Text('Administrator',
                                  style: TextStyle(
                                      fontFamily: 'OpenSans-Regular',
                                      fontSize: 15,
                                      color: Colors.white))
                            ],
                          )
                        ],
                      ),
                    ),
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
                                onTap: searchpressed,
                                child: FittedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Image.asset(
                                        'assets/images/Search_pack.png',
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(height: 5),
                                      Text('Search Packages',
                                          style: TextStyle(
                                              fontFamily: 'NotoSans',
                                              fontSize: 16,
                                              color: Colors.black)),
                                    ],
                                  ),
                                ),
                              )),


                          Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: new InkWell(
                                onTap: scanpressed,
                                child: FittedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Image.asset(
                                        'assets/images/scan_pack.png',
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(height: 5),
                                      Text('Add New Packages',
                                          style: TextStyle(
                                              fontFamily: 'NotoSans',
                                              fontSize: 15,
                                              color: Colors.black))
                                    ],
                                  ),
                                ),
                              )),



                          Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: new InkWell(
                                  onTap: repackagepack,
                                  child: FittedBox(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Image.asset(
                                        'assets/images/pack_bag.png',
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(height: 5),
                                      Text('Re-package Items',
                                          style: TextStyle(
                                              fontFamily: 'NotoSans',
                                              fontSize: 18,
                                              color: Colors.black))
                                    ],
                                  ),)
                              )),
                          Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: new InkWell(
                                onTap: updateloc,
                                child: FittedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Image.asset(
                                        'assets/images/update_loc.png',
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(height: 5),
                                      Text('Update Location',
                                          style: TextStyle(
                                              fontFamily: 'NotoSans',
                                              fontSize: 18,
                                              color: Colors.black))
                                    ],
                                  ),
                                ),
                              )),
                          Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: new InkWell(
                                onTap: updatepackstatus,
                                child: FittedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Image.asset(
                                        'assets/images/update_status.png',
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(height: 5),
                                      Text('Update Status',
                                          style: TextStyle(
                                              fontFamily: 'NotoSans',
                                              fontSize: 18,
                                              color: Colors.black))
                                    ],
                                  ),
                                ),
                              )),
                          Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: new InkWell(
                                onTap: memberdirectory,
                                child: FittedBox(child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: 10),
                                    Image.asset(
                                      'assets/images/members.png',
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.fill,
                                    ),
                                    SizedBox(height: 5),
                                    Text('Member Directory',
                                        style: TextStyle(
                                            fontFamily: 'NotoSans',
                                            fontSize: 18,
                                            color: Colors.black))
                                  ],
                                ),),
                              )),
                          Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: new InkWell(
                                onTap: boxlist,
                                child: FittedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Image.asset(
                                        'assets/images/box.png',
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(height: 5),
                                      Text('Box List',
                                          style: TextStyle(
                                              fontFamily: 'NotoSans',
                                              fontSize: 18,
                                              color: Colors.black))
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
