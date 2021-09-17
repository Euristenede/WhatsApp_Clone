import 'package:flutter/material.dart';
import 'package:whatsapp_clone/login.dart';
import 'package:whatsapp_clone/telas/route_generator.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(
        primaryColor: Color(0xff075E54), accentColor: Color(0xff25D366)),
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
