
import 'package:flutter/material.dart';
import 'package:mschool/constants.dart';
import 'package:mschool/service/auth_service.dart';


class LoginAndRegister extends StatefulWidget {
  @override
  _LoginAndRegisterState createState() => _LoginAndRegisterState();
}

class _LoginAndRegisterState extends State<LoginAndRegister> {
  Map<String, TextEditingController> controller = {
    'emailLogin': TextEditingController(),
    'emailRegister': TextEditingController(),
    'fullname': TextEditingController(),
    'passwordLogin': TextEditingController(),
    'confirmPassword': TextEditingController(),
    'password': TextEditingController(),
  };
  GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();
  setControllerEmpty() {
    for (String i in controller.keys) {
      controller[i].text = '';
    }
  }

  bool isExpanded = false;
  bool isSuccessfull = false;
  PageController _pageController = PageController();
  double currentPageValue = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentPageValue = _pageController.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _sk,
      backgroundColor: backgroundLight,
      body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text('MSchool',style:TextStyle(color:Colors.blueGrey,fontSize:50)),
               
                SizedBox(height: 50,),
                InkWell(
                  onTap: ()=>AuthService().signInWithGoogle(),
                                  child: Container(
                    
                    width: size.width*0.7,
                      padding: EdgeInsets.only(left:10,right:10,top:5,bottom:5),
                      height: 70,
                      child: Column(
                        children: [
                          Row(children:[
                            Image.asset(
                              
                              'images/google.png',height: 50,),
                            SizedBox(width:10),
                            Expanded(child: Center(child: Text('Login with Google')))
                          ]),
                        ],
                      ),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),border:Border.all(color:Colors.grey[200])),
                    ),
                )
              
              ]
            ),
          ),

      )
      );
  }
  }