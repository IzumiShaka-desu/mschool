import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mschool/screens/home.dart';
import 'package:mschool/screens/login_register.dart';
import 'package:mschool/service/auth_service.dart';

class PageContainer extends StatefulWidget {
  @override
  _PageContainerState createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User>(
            stream: AuthService().auth.authStateChanges(),
            builder: (ctx, snapshot) => (!snapshot.hasData || snapshot.data == null) ? LoginAndRegister() : Home()));
  }
}
