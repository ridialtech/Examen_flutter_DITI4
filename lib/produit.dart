class Produit {
  final int id;
  final String code;
  final String designation;
  final double prix;
  final String? dateExpiration;
  final String? description;

  Produit({
    required this.id,
    required this.code,
    required this.designation,
    required this.prix,
    this.dateExpiration,
    this.description,
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    // Conversion de l'id en int, qu'il soit déjà un int ou une String
    int idValue;
    if (json['id'] is int) {
      idValue = json['id'];
    } else if (json['id'] is String) {
      idValue = int.tryParse(json['id']) ?? 0;
    } else {
      idValue = 0;
    }

    // Conversion du prix en double, qu'il soit un nombre ou une String
    double prixValue;
    if (json['prix'] is num) {
      prixValue = (json['prix'] as num).toDouble();
    } else if (json['prix'] is String) {
      prixValue = double.tryParse(json['prix']) ?? 0.0;
    } else {
      prixValue = 0.0;
    }

    return Produit(
      id: idValue,
      code: json['code'] ?? '',
      designation: json['designation'] ?? '',
      prix: prixValue,
      dateExpiration: json['date_expiration'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'designation': designation,
      'prix': prix,
      'date_expiration': dateExpiration,
      'description': description,
    };
  }
}
