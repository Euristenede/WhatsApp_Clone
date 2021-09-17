import 'package:flutter/material.dart';
import 'package:whatsapp_clone/cadastro.dart';
import 'package:whatsapp_clone/configuracoes.dart';
import 'package:whatsapp_clone/home.dart';
import 'package:whatsapp_clone/login.dart';
import 'package:whatsapp_clone/mensagens.dart';
import 'package:whatsapp_clone/model/usuario.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());
      case "/login":
        return MaterialPageRoute(builder: (_) => Login());
      case "/cadastro":
        return MaterialPageRoute(builder: (_) => Cadastro());
      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
      case "/configuracoes":
        return MaterialPageRoute(builder: (_) => Configuracoes());
      case "/mensagens":
        return MaterialPageRoute(
            builder: (_) => Mensagens(settings.arguments as Usuario));
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Tela não encontrada!"),
            ),
            body: Center(
              child: Text("Tela não encontrada!"),
            ),
          );
        });
    }
  }
}
