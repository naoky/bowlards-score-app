import 'game_session.dart';
import 'frame_result.dart';
import '../constants/app_constants.dart';

class GameState {
  final GameSession? currentSession;
  final List<FrameResult> frameResults;
  final int currentFrame;
  final int currentInning; // 1 or 2
  final bool isGameComplete;
  final int runningTotal;

  GameState({
    this.currentSession,
    required this.frameResults,
    required this.currentFrame,
    required this.currentInning,
    required this.isGameComplete,
    required this.runningTotal,
  });

  // 新しいゲームを開始
  factory GameState.newGame(String gameType) {
    int totalFrames = gameType == AppConstants.gameTypeFull 
        ? AppConstants.fullGameFrames 
        : AppConstants.halfGameFrames;
    
    GameSession session = GameSession(
      gameType: gameType,
      totalFrames: totalFrames,
      totalScore: 0,
      createdAt: DateTime.now(),
    );

    return GameState(
      currentSession: session,
      frameResults: [],
      currentFrame: 1,
      currentInning: 1,
      isGameComplete: false,
      runningTotal: 0,
    );
  }

  // 空のゲーム状態
  factory GameState.empty() {
    return GameState(
      currentSession: null,
      frameResults: [],
      currentFrame: 1,
      currentInning: 1,
      isGameComplete: false,
      runningTotal: 0,
    );
  }

  // 現在のフレームの結果を取得
  FrameResult? get currentFrameResult {
    if (frameResults.isEmpty) return null;
    return frameResults.lastWhere(
      (frame) => frame.frameNumber == currentFrame,
      orElse: () => FrameResult(
        sessionId: currentSession?.id ?? 0,
        frameNumber: currentFrame,
        inning1Score: -1,
        inning2Score: -1,
        frameTotal: 0,
        isStrike: false,
        isSpare: false,
      ),
    );
  }

  // 次のフレームに進む
  GameState nextFrame() {
    if (currentFrame >= (currentSession?.totalFrames ?? 10)) {
      return copyWith(isGameComplete: true);
    }
    
    return copyWith(
      currentFrame: currentFrame + 1,
      currentInning: 1,
    );
  }

  // 次のイニングに進む
  GameState nextInning() {
    if (currentInning == 1) {
      return copyWith(currentInning: 2);
    } else {
      return nextFrame();
    }
  }

  // フレーム結果を追加
  GameState addFrameResult(FrameResult result) {
    List<FrameResult> newResults = List.from(frameResults);
    
    // 既存のフレーム結果を更新または新しいフレーム結果を追加
    int existingIndex = newResults.indexWhere((f) => f.frameNumber == result.frameNumber);
    if (existingIndex >= 0) {
      newResults[existingIndex] = result;
    } else {
      newResults.add(result);
    }

    // ランニングトータルを計算
    int newRunningTotal = _calculateRunningTotal(newResults);

    return copyWith(
      frameResults: newResults,
      runningTotal: newRunningTotal,
    );
  }

  // ランニングトータルを計算
  int _calculateRunningTotal(List<FrameResult> results) {
    int total = 0;
    for (int i = 0; i < results.length; i++) {
      FrameResult frame = results[i];
      total += frame.frameTotal;
      
      // ストライクの場合は次の2フレームのボーナスを追加
      if (frame.isStrike && i + 2 < results.length) {
        total += results[i + 1].inning1Score;
        if (results[i + 1].isStrike && i + 2 < results.length) {
          total += results[i + 2].inning1Score;
        } else {
          total += results[i + 1].inning2Score;
        }
      }
      
      // スペアの場合は次のフレームのボーナスを追加
      if (frame.isSpare && i + 1 < results.length) {
        total += results[i + 1].inning1Score;
      }
    }
    return total;
  }

  // ゲームが完了しているかチェック
  bool get isGameFinished {
    if (currentSession == null) return false;
    return currentFrame > currentSession!.totalFrames || isGameComplete;
  }

  // 現在のフレームが完了しているか
  bool get isCurrentFrameComplete {
    FrameResult? current = currentFrameResult;
    if (current == null) return false;
    return current.isFrameComplete;
  }

  // コピーを作成
  GameState copyWith({
    GameSession? currentSession,
    List<FrameResult>? frameResults,
    int? currentFrame,
    int? currentInning,
    bool? isGameComplete,
    int? runningTotal,
  }) {
    return GameState(
      currentSession: currentSession ?? this.currentSession,
      frameResults: frameResults ?? this.frameResults,
      currentFrame: currentFrame ?? this.currentFrame,
      currentInning: currentInning ?? this.currentInning,
      isGameComplete: isGameComplete ?? this.isGameComplete,
      runningTotal: runningTotal ?? this.runningTotal,
    );
  }

  @override
  String toString() {
    return 'GameState(currentSession: $currentSession, '
        'frameResults: ${frameResults.length}, '
        'currentFrame: $currentFrame, currentInning: $currentInning, '
        'isGameComplete: $isGameComplete, runningTotal: $runningTotal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameState &&
        other.currentSession == currentSession &&
        other.frameResults.length == frameResults.length &&
        other.currentFrame == currentFrame &&
        other.currentInning == currentInning &&
        other.isGameComplete == isGameComplete &&
        other.runningTotal == runningTotal;
  }

  @override
  int get hashCode {
    return currentSession.hashCode ^
        frameResults.length.hashCode ^
        currentFrame.hashCode ^
        currentInning.hashCode ^
        isGameComplete.hashCode ^
        runningTotal.hashCode;
  }
} 