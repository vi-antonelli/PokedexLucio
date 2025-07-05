class Pokemon {
  final int id;
  final String nome;
  final String tipo;
  final String imagem;

  Pokemon({required this.id, required this.nome, required this.tipo, required this.imagem});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      nome: json['nome'],
      tipo: json['tipo'],
      imagem: json['imagem'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'imagem': imagem,
    };
  }
}
