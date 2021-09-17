import 'package:cloud_firestore/cloud_firestore.dart';

class Conversa {
  late String _idRemetente;
  late String _idDestinatario;
  late String _nome;
  late String _mensagem;
  late String _caminhoFoto;
  late String _tipoMensagem;

  Conversa();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idRemetente": this.idRemetente,
      "idDestinatario": this.idDestinatario,
      "nome": this.nome,
      "mensagem": this.mensagem,
      "caminhoFoto": this.caminhoFoto,
      "tipoMensagem": this.tipoMensagem,
    };
    return map;
  }

  salvar() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("conversas")
        .doc(this.idRemetente)
        .collection("ultima_conversa")
        .doc(this.idDestinatario)
        .set(this.toMap());
  }

  get idRemetente => this._idRemetente;

  set idRemetente(value) => this._idRemetente = value;

  get idDestinatario => this._idDestinatario;

  set idDestinatario(value) => this._idDestinatario = value;

  get nome => this._nome;

  set nome(value) => this._nome = value;

  get mensagem => this._mensagem;

  set mensagem(value) => this._mensagem = value;

  get caminhoFoto => this._caminhoFoto;

  set caminhoFoto(value) => this._caminhoFoto = value;

  get tipoMensagem => this._tipoMensagem;

  set tipoMensagem(value) => this._tipoMensagem = value;
}
