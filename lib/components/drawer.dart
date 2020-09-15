import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mschool/screens/pagecontainer.dart';
import 'package:mschool/service/auth_service.dart';

import '../utils.dart';

class DrawerCust extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    AuthService().getCurrentUser().then((value) {
      
      if(value!=null) value.reload();});
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              children: [
                DrawerHeader(
                    child: StreamBuilder<User>(
                  stream: AuthService().auth.userChanges(),
                  builder: (ctx, snapshot) {
                    
                    if(!snapshot.hasData &&
                          snapshot.data == null)
                      {
                        return Container();
                        }
                      else{
                         return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                  child: Center(child: Icon(Icons.person))),
                              SizedBox(height: 10),
                              Text("Welcome back " +
                                  (((snapshot.data.displayName??'').isEmpty)
                                      ? 'No Name'
                                      : snapshot.data.displayName)),
                              Column( children: [
                                Text(snapshot.data.email),
                                (snapshot.data.emailVerified)
                                    ? SizedBox()
                                    : Container(
                                        height: 30,
                                        child: FlatButton(
                                            color: Colors.redAccent,
                                            onPressed: () {
                                              print(snapshot.data);
                                              Scaffold.of(context).showSnackBar(
                                                  createSnackbar(
                                                      'verification mail has sent'));
                                              snapshot.data
                                                  .sendEmailVerification();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('verified this mail')))
                              ]),
                            ],
                          ),
                        );
  }
  }
  )),
                Container(height: 2, color: Colors.grey),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              await AuthService().signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => PageContainer()));
            },
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.redAccent.withAlpha(100),
              height: 50,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Logout'), Icon(Icons.exit_to_app)]),
            ),
          )
        ],
      ),
    );
  }
}
