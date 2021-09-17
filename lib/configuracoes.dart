import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({Key? key}) : super(key: key);

  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  //Controladores
  TextEditingController _controllerNome = TextEditingController();

  late File _imagem;
  late String _idUsuarioLogado;
  late File imagemSelecionada;
  late bool _subindoImagen = false;
  late String _urlImagemRecuperada =
      "https://firebasestorage.googleapis.com/v0/b/whatsapp-70e48.appspot.com/o/person.png?alt=media&token=544a8013-246d-414f-a424-4d0cda9ad22e";
  Future _recuperarImagem(String origemImagem) async {
    switch (origemImagem) {
      case "camera":
        PickedFile? selectedFile =
            await ImagePicker().getImage(source: ImageSource.camera);
        imagemSelecionada = File(selectedFile!.path);
        break;
      case "galeria":
        PickedFile? selectedFile =
            await ImagePicker().getImage(source: ImageSource.gallery);
        imagemSelecionada = File(selectedFile!.path);
        break;
    }
    setState(() {
      _imagem = imagemSelecionada;
      if (_imagem != null) {
        _subindoImagen = true;
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arquivo =
        pastaRaiz.child("perfil").child(_idUsuarioLogado + ".jpg");
    //Upload da imagem de perfil
    UploadTask task = arquivo.putFile(_imagem);
    //Controlar o progresso do upload
    task.snapshotEvents.listen((TaskSnapshot snapshot) async {
      if (snapshot.state == TaskState.running) {
        setState(() {
          _subindoImagen = true;
        });
      } else if (snapshot.state == TaskState.success) {
        setState(() {
          _subindoImagen = false;
        });
      }
      //Recuperar a url da imagem
      String url = await snapshot.ref.getDownloadURL();
      _atualizarUrlImagemFirestore(url);
      setState(() {
        _urlImagemRecuperada = url;
      });
    }, onError: (Object e) {
      print(e); // FirebaseException
    });
  }

  _atualizarNomeFirestore() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String nome = _controllerNome.text;
    Map<String, dynamic> dadosAtualizar = {"nome": nome};
    db.collection("usuarios").doc(_idUsuarioLogado).update(dadosAtualizar);
  }

  _atualizarUrlImagemFirestore(String url) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Map<String, dynamic> dadosAtualizar = {"urlImagem": url};
    db.collection("usuarios").doc(_idUsuarioLogado).update(dadosAtualizar);
  }

  _recuperarDadosUsuario() async {
    Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser!;
    _idUsuarioLogado = usuarioLogado.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(_idUsuarioLogado).get();

    _controllerNome.text = snapshot.get("nome");
    if (snapshot.get("urlImagem") != null) {
      setState(() {
        _urlImagemRecuperada = snapshot.get("urlImagem");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: _subindoImagen
                      ? CircularProgressIndicator()
                      : Container(),
                ),
                CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey,
                    backgroundImage: _urlImagemRecuperada != null
                        ? NetworkImage(_urlImagemRecuperada)
                        : null),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      child: Text("Câmera"),
                      onPressed: () {
                        _recuperarImagem("camera");
                      },
                    ),
                    FlatButton(
                      child: Text("Galeria"),
                      onPressed: () {
                        _recuperarImagem("galeria");
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      _atualizarNomeFirestore();
                      Navigator.pushReplacementNamed(context, "/home");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
