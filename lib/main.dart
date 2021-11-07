import 'package:flutter/cupertino.dart';

import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Login',
        theme: ThemeData(
            primaryColor: Colors.lightBlue[800],
            accentColor: Colors.cyan[600],
            fontFamily: 'SourceSansPro'),
        home: LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future doLogin() async {
    /*var init = await Parse()
        .initialize('Trackngo', 'http://192.168.100.231:4040/parse',
            debug: true, //
            autoSendSessionId: true,
            clientKey: 'trackckey');*/

    var init =
        await Parse().initialize('Trackngo', 'http://34.121.245.89:4040/parse',
            debug: true, //
            autoSendSessionId: true,
            clientKey: 'trackckey');

    print(init);

    final ParseResponse response = await Parse().healthCheck();

    var user = await ParseUser.currentUser();
    if (user == null) {
      ParseUser user = ParseUser('trackngo876@gmail.com', 'Password123', '');
      ParseResponse response1 = await user.login();

      if (response1.success) {
        user = response1.result;
      } else {
        AlertDialog(title: Text(response1.error.message));
      }
      //var response = await new ParseUser('Trackngo876@gmail.com','Password123','Trackngo876@gmail.com').login();
      print(response1);
      //if(response1.success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      //}else{

      //}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ListView(
      padding: EdgeInsets.symmetric(horizontal: 18),
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Image.asset('assets/images/tng.png'),
            SizedBox(
              height: 30,
            ),
            Text(
              'Track-N-Go',
              style: TextStyle(fontSize: 25, color: Colors.blueAccent),
            )
          ],
        ),
        SizedBox(height: 60.0),
        Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Email",
                  border: InputBorder.none,
                  labelStyle: TextStyle(fontSize: 20),
                  filled: true),
            )),
        SizedBox(height: 20),
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: InputBorder.none,
                  labelStyle: TextStyle(fontSize: 20),
                  filled: true)),
        ),
        SizedBox(height: 30),
        Column(
          children: <Widget>[
            ButtonTheme(
                height: 30,
                disabledColor: Colors.blueGrey,
                buttonColor: Colors.blue,
                child: ElevatedButton(
                  onPressed: doLogin,
                  child: Text('Login',
                      style: TextStyle(fontSize: 25, color: Colors.white)),
                ))
          ],
        )
      ],
    )));
  }
}
