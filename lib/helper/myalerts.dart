import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrackAlerts {
  static showAlertLoading(message, BuildContext context) {
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

  static showAlertError(message, BuildContext context) {
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
      pageBuilder: (context, animation1, animation2) {
        return null;
      },
    );
  }
}
