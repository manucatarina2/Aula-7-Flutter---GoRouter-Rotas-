class TabuadaModel {
  final int id;
  final int numero;
  final int multiplicador;
  final int resultado;
  final String nivel;

  TabuadaModel({
    required this.id,
    required this.numero,
    required this.multiplicador,
    required this.resultado,
    required this.nivel,
  });

  factory TabuadaModel.fromJson(Map<String, dynamic> json, String nivel) {
    return TabuadaModel(
      id: json['id'],
      numero: json['numero'],
      multiplicador: json['multiplicador'],
      resultado: json['resultado'],
      nivel: nivel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero': numero,
      'multiplicador': multiplicador,
      'resultado': resultado,
      'nivel': nivel,
    };
  }
}