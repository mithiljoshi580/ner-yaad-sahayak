import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/game_model.dart';

class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add the initial games to Firestore
  Future<void> seedGamesData() async {
    final games = [
      GameModel(
        id: 'thang_ta',
        name: 'Thang Ta',
        description: 'A traditional martial art of Manipur.',
        howToPlay:
            'Learn the basic movements, attacks and defensive techniques.',
        imageAsset: 'assets/images/thang_ta.png',
        category: 'Martial Arts',
      ),
      GameModel(
        id: 'mukna',
        name: 'Mukna',
        description: 'A traditional wrestling sport of Manipur.',
        howToPlay: 'Use wrestling techniques to defeat your opponent.',
        imageAsset: 'assets/images/mukna.png',
        category: 'Wrestling',
      ),
      GameModel(
        id: 'insuknawr',
        name: 'Insuknawr',
        description: 'A traditional stick-fighting sport of Manipur.',
        howToPlay: 'Use a bamboo stick with skill and defensive techniques.',
        imageAsset: 'assets/images/insuknawr.png',
        category: 'Stick Fighting',
      ),
    ];

    for (final game in games) {
      await _firestore.collection('games').doc(game.id).set(game.toMap());
    }
  }

  // Fetch all games from Firestore
  Future<List<GameModel>> getAllGames() async {
    final snapshot = await _firestore.collection('games').get();

    return snapshot.docs.map((doc) {
      return GameModel.fromMap(doc.data());
    }).toList();
  }

  // Fetch a single game by ID
  Future<GameModel?> getGameById(String id) async {
    final doc = await _firestore.collection('games').doc(id).get();

    if (doc.exists && doc.data() != null) {
      return GameModel.fromMap(doc.data()!);
    }

    return null;
  }
}
