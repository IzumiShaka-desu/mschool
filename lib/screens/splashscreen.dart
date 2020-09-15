
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mschool/constants.dart';
import 'package:mschool/screens/pagecontainer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAnimate=false;
  setFull() {
    setState(() {
     isAnimate=true;
    });
  }

  @override
  void initState() {
    super.initState();
    
    delayMethod(2940, setFull);
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned.fill(
            child: Container(
              color: Colors.white,
          child: Center(
            child: Text('SchoolApp',style: TextStyle(fontSize:30,fontWeight:FontWeight.w800,color: primaryBlue),)
          ),
        )),
        AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          top: (isAnimate)?-height:-2,
          left: (isAnimate)?-width:-2,
                  child: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            
            decoration: BoxDecoration(color:primaryBlue,shape: BoxShape.circle),
            height: (isAnimate)?height*3:0,
            width: (isAnimate)?width*3:0,
            onEnd: ()=>gotoHome(),
          ),
        )
      ],
    );
  }
  Future delayMethod(int delayMillis,Function method)async{
      return Timer(Duration(milliseconds: delayMillis),method);
}
  void gotoHome() async{
 
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => PageContainer()));
  }
}
