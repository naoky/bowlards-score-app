import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';

class DatabaseService {
  static Database? _database;
  
  // シングルトンパターン
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  
  // データベース取得
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  // データベース初期化
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), AppConstants.databaseName);
    
    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  // データベース作成
  Future<void> _onCreate(Database db, int version) async {
    // ゲームセッションテーブル
    await db.execute('''
      CREATE TABLE ${AppConstants.tableGameSessions} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_type TEXT NOT NULL,
        total_frames INTEGER NOT NULL,
        total_score INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    
    // フレーム結果テーブル
    await db.execute('''
      CREATE TABLE ${AppConstants.tableFrameResults} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        frame_number INTEGER NOT NULL,
        inning1_score INTEGER NOT NULL,
        inning2_score INTEGER NOT NULL,
        frame_total INTEGER NOT NULL,
        is_strike INTEGER NOT NULL,
        is_spare INTEGER NOT NULL,
        FOREIGN KEY (session_id) REFERENCES ${AppConstants.tableGameSessions} (id)
      )
    ''');
  }
  
  // データベースアップグレード
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 将来のアップグレード処理
  }
  
  // データベースクローズ
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
} 