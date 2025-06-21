class AppConstants {
  // アプリ情報
  static const String appName = 'ボーラードスコア';
  static const String appVersion = '1.0.0';
  
  // ゲーム設定
  static const int fullGameFrames = 10;
  static const int halfGameFrames = 5;
  static const int maxScore = 300;
  
  // データベース
  static const String databaseName = 'bowlards_score.db';
  static const int databaseVersion = 1;
  
  // テーブル名
  static const String tableGameSessions = 'game_sessions';
  static const String tableFrameResults = 'frame_results';
  
  // 共有設定キー
  static const String keyGameType = 'game_type';
  static const String keyDefaultGameType = 'default_game_type';
  
  // ゲームタイプ
  static const String gameTypeFull = 'full';
  static const String gameTypeHalf = 'half';
} 