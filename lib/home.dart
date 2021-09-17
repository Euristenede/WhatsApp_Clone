import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/login.dart';
import 'package:whatsapp_clone/telas/aba_contatos.dart';
import 'package:whatsapp_clone/telas/aba_conversas.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<String> itensMenu = ["Configurações", "Deslogar"];
  String _emailUsuario = "";

  _recuperarDadosUsuario() async {
    Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser!;
    setState(() {
      _emailUsuario = usuarioLogado.email!;
    });
  }

  Future _verificarUsuarioLogado() async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();
    User usuarioLogado = await auth.currentUser!;
    if (usuarioLogado == null) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
    _recuperarDadosUsuario();

    _tabController = TabController(length: 2, vsync: this);
  }

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Configurações":
        Navigator.pushNamed(context, "/configuracoes");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("WhatsApp"),
          bottom: TabBar(
            indicatorWeight: 4,
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: "Conversas",
              ),
              Tab(
                text: "Contatos",
              )
            ],
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context) {
                return itensMenu.map((String item) {
                  return PopupMenuItem<String>(value: item, child: Text(item));
                }).toList();
              },
            )
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [AbaConversas(), AbaContatos()],
        ));
  }
}
