import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Auth/Login/UI/login_page.dart';


class Splaschscreen extends StatefulWidget {
  @override
  _Splaschscreen createState() => _Splaschscreen();

}

class _Splaschscreen extends  State<Splaschscreen>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 4),
            (){
              Navigator.pop(context);
              Navigator.push(context,MaterialPageRoute(builder: (context)=> LoginPage()) );
            }
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width= MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/app_splash.png', height: 70.0, width: (width/2)+(width/6)),
          SizedBox(height: 10.0,),
          SpinKitRipple(
            size: 20,
            color: Colors.blue.shade800,
          ),

        ],
      ) ,

    );
  }


}
