import 'dart:async';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/conversa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:core';

class AbaConversas extends StatefulWidget {
  const AbaConversas({Key? key}) : super(key: key);

  @override
  _AbaConversasState createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {
  late List<Conversa> _listaConversas = [];
  final _controler = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String _idUsuarioLogado;

  Stream<QuerySnapshot>? _adicionarListenerConversas() {
    final stream =
        db.collection("conversas").doc("ultima_conversa").snapshots();
    stream.listen((dados) {
      _controler.add(dados as QuerySnapshot<Object?>);
    });
  }

  _recuperarDadosUsuario() async {
    Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser!;
    setState(() {
      _idUsuarioLogado = usuarioLogado.uid;
    });
    _adicionarListenerConversas();
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _controler.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: [
                    Text("Carregando conversas"),
                    CircularProgressIndicator()
                  ],
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
              if (snapshot.hasError) {
                return Expanded(child: Text("Erro ao carregar os dados!"));
              } else {
                if (querySnapshot.docs.length == 0) {
                  return Center(
                    child: Text(
                      "Você ainda não tem mensagens :( ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (context, indice) {
                      List<DocumentSnapshot> conversas =
                          querySnapshot.docs.toList();
                      DocumentSnapshot item = conversas[indice];

                      String urlImagem = item["caminhoFoto"];
                      String tipo = item["tipoMensagem"];
                      String mensagem = item["mensagem"];
                      String nome = item["nome"];

                      return ListTile(
                          contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          leading: CircleAvatar(
                            maxRadius: 30,
                            backgroundColor: Colors.grey,
                            backgroundImage: urlImagem != null
                                ? NetworkImage(urlImagem)
                                : null,
                          ),
                          title: Text(
                            nome,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            tipo == "texto" ? mensagem : "Imagem...",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ));
                    });
              }
          }
        });
  }
}
