// lib/data/model/plant.dart
class Plant {
  final String? id;
  final String name;
  final String species;
  final String description;
  final DateTime? plantingDate;
  final DateTime? harvestDate;
  final String? imageUrl;

  Plant({
    this.id,
    required this.name,
    required this.species,
    required this.description,
    this.plantingDate,
    this.harvestDate,
    this.imageUrl,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      description: json['description'],
      plantingDate: json['plantingDate'] != null
          ? DateTime.parse(json['plantingDate'])
          : null,
      harvestDate: json['harvestDate'] != null
          ? DateTime.parse(json['harvestDate'])
          : null,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'description': description,
      'plantingDate': plantingDate?.toIso8601String(),
      'harvestDate': harvestDate?.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  Plant copyWith({
    String? id,
    String? name,
    String? species,
    String? description,
    DateTime? plantingDate,
    DateTime? harvestDate,
    String? imageUrl,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      description: description ?? this.description,
      plantingDate: plantingDate ?? this.plantingDate,
      harvestDate: harvestDate ?? this.harvestDate,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
