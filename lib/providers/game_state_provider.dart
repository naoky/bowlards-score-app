import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class GameStateProvider extends ChangeNotifier {
  GameSession? _currentGame;
  int _currentFrame = 1;
  final DatabaseService _databaseService = DatabaseService();

  GameSession? get currentGame => _currentGame;
  int get currentFrame => _currentFrame;

  // 新しいゲームを開始
  void startNewGame(GameType gameType) {
    _currentGame = GameSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      gameType: gameType,
      frames: [],
      totalScore: 0,
      createdAt: DateTime.now(),
    );
    _currentFrame = 1;
    notifyListeners();
  }

  // フレーム結果を追加
  void addFrameResult(int firstThrow, int secondThrow) {
    if (_currentGame == null) return;

    final frameResult = FrameResult(
      firstThrow: firstThrow,
      secondThrow: secondThrow,
    );

    _currentGame!.frames.add(frameResult);
    _currentGame!.totalScore = _calculateTotalScore();

    // 次のフレームへ
    if (_currentFrame < _currentGame!.totalFrames) {
      _currentFrame++;
    } else {
      // ゲーム完了
      _completeGame();
    }

    notifyListeners();
  }

  // ゲーム完了処理
  void _completeGame() async {
    if (_currentGame == null) return;

    // データベースに保存
    await _databaseService.saveGameSession(_currentGame!);
    
    // 統計プロバイダーに通知（必要に応じて）
    // ここでは直接通知せず、StatisticsProviderがデータベースから読み込む
  }

  // 合計スコアを計算
  int _calculateTotalScore() {
    if (_currentGame == null) return 0;

    int total = 0;
    for (int i = 0; i < _currentGame!.frames.length; i++) {
      final frame = _currentGame!.frames[i];
      total += frame.firstThrow + frame.secondThrow;
      
      // ストライクのボーナス
      if (frame.firstThrow == 10 && i < _currentGame!.frames.length - 1) {
        total += _currentGame!.frames[i + 1].firstThrow;
        if (i < _currentGame!.frames.length - 2) {
          total += _currentGame!.frames[i + 1].secondThrow;
        }
      }
      // スペアのボーナス
      else if (frame.firstThrow + frame.secondThrow == 10 && i < _currentGame!.frames.length - 1) {
        total += _currentGame!.frames[i + 1].firstThrow;
      }
    }
    return total;
  }

  // ゲームが完了しているか
  bool get isGameFinished {
    if (_currentGame == null) return false;
    return _currentFrame > _currentGame!.totalFrames;
  }

  // 現在のフレームが完了しているか
  bool get isCurrentFrameComplete {
    if (_currentGame == null) return false;
    if (_currentFrame > _currentGame!.frames.length) return false;
    
    final frame = _currentGame!.frames[_currentFrame - 1];
    return frame.firstThrow == 10 || frame.secondThrow > 0;
  }

  // ゲームをリセット
  void resetGame() {
    _currentGame = null;
    _currentFrame = 1;
    notifyListeners();
  }
} 