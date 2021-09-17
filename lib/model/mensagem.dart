import 'package:flutter/material.dart';

class Mensagem {
  late String _idUsuario;
  late String _mensagem;
  late String _urlImagem;
  late String _tipo;
  late DateTime _time;

  Mensagem();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUsuario": this.idUsuario,
      "mensagem": this.mensagem,
      "urlImagem": this.urlImagem,
      "tipo": this.tipo,
      "time": this.time,
    };
    return map;
  }

  DateTime get time => _time;

  set time(DateTime value) {
    _time = value.toUtc();
  }

  get idUsuario => this._idUsuario;

  set idUsuario(value) => this._idUsuario = value;

  get mensagem => this._mensagem;

  set mensagem(value) => this._mensagem = value;

  get urlImagem => this._urlImagem;

  set urlImagem(value) => this._urlImagem = value;

  get tipo => this._tipo;

  set tipo(value) => this._tipo = value;
}
