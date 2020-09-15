
import 'dart:io';

import 'package:flutter/material.dart';

import 'constants.dart';

createTextField(TextEditingController controller, String label, IconData icon,
        {bool isObscure}) =>
    TextFormField(
        
        cursorColor: Colors.white,
        controller: controller,
        obscureText: isObscure ?? false,
        decoration: InputDecoration(
          focusColor: Colors.white,
            focusedBorder: UnderlineInputBorder(borderSide:BorderSide(color: Colors.white)),
            labelText: label,
            prefixIcon: Icon(icon),
            border: UnderlineInputBorder(),
            hintText: ' $label'));

String getSimpleName(String str){
  String name='';
  str.split('').forEach((ch){
    if(name.length<18){
      name+=ch;
    }
  });
  return name;
}

emailValidator(String email) {
  if (email.contains('@')) {
    if (email.split('@')[1].contains('.')) {
      return true;
    }
  }
  return false;
}
bool isTimeOut(SocketException e) =>
    e.osError.message.contains('Connection timed out');

SnackBar createSnackbar(String _msg)=>SnackBar(
      duration: Duration(seconds: 3),
      backgroundColor: backgroundLight,
      content: Material(
        type: MaterialType.transparency,
        child: Container(
          height: 50,
          child: Center(
              child: Row(
            children: [
              Expanded(
                child: Text(
                  _msg,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.black),
                ),
              ),
            ],
          )),
        ),
      ));

bool isEmptyMapText(Map<String,TextEditingController> map){
  for (TextEditingController item in map.values) {
    if(item.text.isEmpty){
      return true;
    }
  }
  return false;
}

confirmDelete(BuildContext context)=>AlertDialog(
                                        title: const Text("Confirm"),
                                        content: const Text(
                                            "Are you sure you wish to delete this item?"),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text("DELETE")),
                                          FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text("CANCEL"),
                                          ),
                                        ],
                                      );