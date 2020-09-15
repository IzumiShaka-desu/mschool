import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mschool/service/auth_service.dart';
import 'package:mschool/utils.dart';

class ProfileDetail extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileDetail> {
  Map<String, TextEditingController> controller = {
    'name': TextEditingController(),
    'email': TextEditingController(),
  };
  GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();
  User user;
  Map<String, String> mapUser;
  loadData() async {
    User _user = await AuthService().getCurrentUser();
    setState(() {
      user = _user;
      mapUser = {
        'name': _user.displayName,
        'email': _user.email,
      };
      setState(() {
        
      });
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Widget createUpdater(String identity, size, Function f) => Container(
          child: Card(
        child: ExpansionTile(
          trailing: Icon(Icons.edit),
          onExpansionChanged: (state) {
            if (state) {
              setState(() {
                controller[identity].text =
                    getValidString(mapUser[identity]) ?? '';
              });
            } else {
              setState(() {
                controller[identity].text = '';
              });
            }
          },
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.1,
                  right: size.width * 0.2,
                  top: 5,
                  bottom: 5),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: controller[identity],
                decoration: InputDecoration(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.6, right: size.width * 0.1, bottom: 10),
              child: FlatButton(
                  onPressed: () async {
                    f();
                  },
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      Text('save', style: TextStyle(color: Colors.white))
                    ],
                  )),
            )
          ],
          title: Text('$identity : ' +
              ((mapUser[identity] != null)
                  ? (mapUser[identity].isEmpty)
                      ? ' $identity not set'
                      : mapUser[identity]
                  : ' $identity not set')),
        ),
      ));

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _sk,
      appBar: AppBar(title: Text('Profile')),
      body: ListView(children: [
        createUpdater('name', size, () async {
          if (controller['name'].text.isEmpty) {
            _sk.currentState
                .showSnackBar(createSnackbar('field must not be empty'));
          } else {
            try {
              user.updateProfile(displayName: controller['name'].text);
              user.reload();
              _sk.currentState
                  .showSnackBar(createSnackbar('name successfully changed'));
            } catch (e) {
              _sk.currentState.showSnackBar(
                  createSnackbar('name not successfully changed'));
            }
          }
          loadData();
        }),
        createUpdater('email', size, () {
          if (controller['email'].text.isEmpty) {
            _sk.currentState
                .showSnackBar(createSnackbar('field must not be empty'));
          } else {
            try {
              user.updateEmail(controller['email'].text);
              user.reload();
              _sk.currentState
                  .showSnackBar(createSnackbar('email successfully changed'));
            } catch (e) {
              _sk.currentState.showSnackBar(
                  createSnackbar('email not successfully changed'));
            }
          }
          loadData();
        })
      ]),
    );
  }
}
