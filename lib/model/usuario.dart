class Usuario {
  late String _idUsuario;
  late String _nome;
  late String _email;
  late String _senha;
  late String _urlImagem;

  Usuario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this._nome,
      "email": this._email,
      "urlImagem": this._urlImagem,
    };
    return map;
  }

  get idUsuario => this._idUsuario;

  set idUsuario(value) => this._idUsuario = value;

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get urlImagem => _urlImagem;

  set urlImagem(String value) {
    _urlImagem = value;
  }
}
