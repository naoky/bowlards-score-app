import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class StatisticsProvider extends ChangeNotifier {
  List<GameSession> _sessions = [];
  List<FrameResult> _frameResults = [];
  GameStatistics _statistics = GameStatistics.empty();

  List<GameSession> get sessions => _sessions;
  List<FrameResult> get frameResults => _frameResults;
  GameStatistics get statistics => _statistics;

  // データベースから履歴を取得
  Future<void> loadHistory() async {
    final db = await DatabaseService().database;
    final sessionList = await db.query('game_sessions', orderBy: 'created_at DESC');
    final frameList = await db.query('frame_results');

    _sessions = sessionList.map((e) => GameSession.fromJson(e)).toList();
    _frameResults = frameList.map((e) => FrameResult.fromJson(e)).toList();
    _statistics = GameStatistics.fromGameData(_sessions, _frameResults);
    notifyListeners();
  }

  // 新しいセッション・フレームを追加
  Future<void> addSessionAndFrames(GameSession session, List<FrameResult> frames) async {
    final db = await DatabaseService().database;
    int sessionId = await db.insert('game_sessions', session.toJson());
    for (final frame in frames) {
      await db.insert('frame_results', frame.copyWith(sessionId: sessionId).toJson());
    }
    await loadHistory();
  }

  // 履歴を削除
  Future<void> deleteSession(int sessionId) async {
    final db = await DatabaseService().database;
    await db.delete('frame_results', where: 'session_id = ?', whereArgs: [sessionId]);
    await db.delete('game_sessions', where: 'id = ?', whereArgs: [sessionId]);
    await loadHistory();
  }
} 