class Ciudad {
  final String nombre;
  final double latitud;
  final double longitud;

    Ciudad({
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });

  factory Ciudad.fromJson(Map<String, dynamic> json) {
    return Ciudad(
      nombre: json['nombre'],
      latitud: json['latitud'],
      longitud: json['longitud'],
    );
  }
}