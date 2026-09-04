class GameModel {
  final String id;
  final String name;
  final String description;
  final String howToPlay;
  final String imageAsset;
  final String category;

  GameModel({
    required this.id,
    required this.name,
    required this.description,
    required this.howToPlay,
    required this.imageAsset,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'howToPlay': howToPlay,
      'imageAsset': imageAsset,
      'category': category,
    };
  }

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      howToPlay: map['howToPlay'] ?? '',
      imageAsset: map['imageAsset'] ?? '',
      category: map['category'] ?? '',
    );
  }
}
