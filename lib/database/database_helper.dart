import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import '../models/flashcard.dart';
import 'package:path_provider/path_provider.dart';
import '../models/topic.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('flashcards.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    // Create the topics table
    await db.execute('''
CREATE TABLE topics ( 
  id $idType, 
  name $textType
)
''');

    // Create the flashcards table
    await db.execute('''
CREATE TABLE flashcards ( 
  id $idType, 
  topicId INTEGER NOT NULL,
  question $textType,
  answer $textType,
  FOREIGN KEY (topicId) REFERENCES topics (id) ON DELETE CASCADE
)
''');
  }

  //method checks if a topic exists by its name. if it does, it returns the existing topic's ID.
  //if not, it creates a new topic and returns its newly created ID
  Future<int> ensureTopicExists(String topicName) async {
    final db = await database;
    String trimmedTopicName = topicName.trim(); // Trim whitespace

    // Check if the topic already exists (case-insensitive comparison)
    final List<Map<String, dynamic>> maps = await db.query(
      'topics',
      columns: ['id'],
      where: 'LOWER(name) = LOWER(?)', // Case-insensitive comparison
      whereArgs: [trimmedTopicName],
    );

    if (maps.isNotEmpty) {
      // Topic exists, return its ID
      return maps.first['id'] as int;
    } else {
      // Topic doesn't exist, insert a new one and return its ID
      return await db.insert(
        'topics',
        {'name': trimmedTopicName}, // Insert trimmed name
      );
    }
  }

  //method adds a new flashcard to the 'flashcards' table, using a 'Flashcard' object which includes the 'topicId'
  Future<void> createFlashcard(Flashcard flashcard) async {
    final db = await database;
    await db.insert('flashcards', flashcard.toMap());
  }

  //method fetches all topics from the database, which is useful for listing topics
  Future<List<Topic>> getTopics() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('topics');

    return List.generate(maps.length, (i) {
      return Topic(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
      );
    });
  }

  //method retrieves all flashcards associated with a specific 'topicId'
  Future<List<Flashcard>> getFlashcardsForTopic(int topicId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'flashcards',
      where: 'topicId = ?',
      whereArgs: [topicId],
    );

    return List.generate(maps.length, (i) {
      return Flashcard.fromMap(maps[i]);
    });
  }

  //method deletes a flashcard based on the specified topic id
  Future<void> deleteFlashcard(int id) async {
    final db = await database;
    await db.delete(
      'flashcards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //method for deleting a topic and its associated flashcards
  Future<void> deleteTopicAndFlashcards(int topicId) async {
    final db = await database;
    await db.delete('topics', where: 'id = ?', whereArgs: [topicId]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}