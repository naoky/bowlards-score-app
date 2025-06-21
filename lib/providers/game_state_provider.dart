import 'package:flutter/material.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';

class GameStateProvider extends ChangeNotifier {
  GameState _gameState = GameState.empty();

  GameState get gameState => _gameState;

  // 新しいゲームを開始
  void startNewGame(String gameType) {
    _gameState = GameState.newGame(gameType);
    notifyListeners();
  }

  // フレーム結果を追加・更新
  void addOrUpdateFrameResult(FrameResult result) {
    _gameState = _gameState.addFrameResult(result);
    notifyListeners();
  }

  // 次のイニングへ
  void nextInning() {
    _gameState = _gameState.nextInning();
    notifyListeners();
  }

  // 次のフレームへ
  void nextFrame() {
    _gameState = _gameState.nextFrame();
    notifyListeners();
  }

  // ゲームをリセット
  void resetGame() {
    _gameState = GameState.empty();
    notifyListeners();
  }

  // 現在のフレームが完了しているか
  bool get isCurrentFrameComplete => _gameState.isCurrentFrameComplete;

  // ゲームが完了しているか
  bool get isGameFinished => _gameState.isGameFinished;

  // 現在のフレーム番号
  int get currentFrame => _gameState.currentFrame;

  // 現在のイニング番号
  int get currentInning => _gameState.currentInning;

  // 現在のフレームの結果
  FrameResult? get currentFrameResult => _gameState.currentFrameResult;

  // ランニングトータル
  int get runningTotal => _gameState.runningTotal;
} 