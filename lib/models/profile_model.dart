// profile_model.dart
class Profile {
  int? id; // Alterado para nullable
  String name;
  String imagePath;

  Profile({
    this.id, // ID agora é opcional
    required this.name,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
    };
  }

  // Adicionar factory method para conversão do Map
  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as int?, // Conversão segura
      name: map['name'] as String,
      imagePath: map['imagePath'] as String,
    );
  }
}