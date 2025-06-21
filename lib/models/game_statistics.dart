import 'game_session.dart';
import 'frame_result.dart';

class GameStatistics {
  final int totalGames;
  final int totalFrames;
  final int totalScore;
  final double averageScore;
  final int highestScore;
  final int lowestScore;
  final int strikes;
  final int spares;
  final double strikeRate;
  final double spareRate;
  final int perfectGames; // 300点達成回数

  GameStatistics({
    required this.totalGames,
    required this.totalFrames,
    required this.totalScore,
    required this.averageScore,
    required this.highestScore,
    required this.lowestScore,
    required this.strikes,
    required this.spares,
    required this.strikeRate,
    required this.spareRate,
    required this.perfectGames,
  });

  // 空の統計情報を作成
  factory GameStatistics.empty() {
    return GameStatistics(
      totalGames: 0,
      totalFrames: 0,
      totalScore: 0,
      averageScore: 0.0,
      highestScore: 0,
      lowestScore: 0,
      strikes: 0,
      spares: 0,
      strikeRate: 0.0,
      spareRate: 0.0,
      perfectGames: 0,
    );
  }

  // ゲームセッションとフレーム結果から統計情報を作成
  factory GameStatistics.fromGameData(
    List<GameSession> sessions,
    List<FrameResult> frameResults,
  ) {
    if (sessions.isEmpty) return GameStatistics.empty();

    int totalGames = sessions.length;
    int totalFrames = frameResults.length;
    int totalScore = sessions.fold(0, (sum, session) => sum + (session.totalScore));
    double averageScore = totalGames > 0 ? totalScore / totalGames : 0.0;
    
    int highestScore = sessions.map((s) => s.totalScore).reduce((a, b) => a > b ? a : b);
    int lowestScore = sessions.map((s) => s.totalScore).reduce((a, b) => a < b ? a : b);
    
    int strikes = frameResults.where((frame) => frame.isStrike).length;
    int spares = frameResults.where((frame) => frame.isSpare).length;
    
    double strikeRate = totalFrames > 0 ? strikes / totalFrames : 0.0;
    double spareRate = totalFrames > 0 ? spares / totalFrames : 0.0;
    
    int perfectGames = sessions.where((session) => session.totalScore == 300).length;

    return GameStatistics(
      totalGames: totalGames,
      totalFrames: totalFrames,
      totalScore: totalScore,
      averageScore: averageScore,
      highestScore: highestScore,
      lowestScore: lowestScore,
      strikes: strikes,
      spares: spares,
      strikeRate: strikeRate,
      spareRate: spareRate,
      perfectGames: perfectGames,
    );
  }

  // JSONからオブジェクトを作成
  factory GameStatistics.fromJson(Map<String, dynamic> json) {
    return GameStatistics(
      totalGames: json['total_games'] as int,
      totalFrames: json['total_frames'] as int,
      totalScore: json['total_score'] as int,
      averageScore: (json['average_score'] as num).toDouble(),
      highestScore: json['highest_score'] as int,
      lowestScore: json['lowest_score'] as int,
      strikes: json['strikes'] as int,
      spares: json['spares'] as int,
      strikeRate: (json['strike_rate'] as num).toDouble(),
      spareRate: (json['spare_rate'] as num).toDouble(),
      perfectGames: json['perfect_games'] as int,
    );
  }

  // オブジェクトをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'total_games': totalGames,
      'total_frames': totalFrames,
      'total_score': totalScore,
      'average_score': averageScore,
      'highest_score': highestScore,
      'lowest_score': lowestScore,
      'strikes': strikes,
      'spares': spares,
      'strike_rate': strikeRate,
      'spare_rate': spareRate,
      'perfect_games': perfectGames,
    };
  }

  // コピーを作成
  GameStatistics copyWith({
    int? totalGames,
    int? totalFrames,
    int? totalScore,
    double? averageScore,
    int? highestScore,
    int? lowestScore,
    int? strikes,
    int? spares,
    double? strikeRate,
    double? spareRate,
    int? perfectGames,
  }) {
    return GameStatistics(
      totalGames: totalGames ?? this.totalGames,
      totalFrames: totalFrames ?? this.totalFrames,
      totalScore: totalScore ?? this.totalScore,
      averageScore: averageScore ?? this.averageScore,
      highestScore: highestScore ?? this.highestScore,
      lowestScore: lowestScore ?? this.lowestScore,
      strikes: strikes ?? this.strikes,
      spares: spares ?? this.spares,
      strikeRate: strikeRate ?? this.strikeRate,
      spareRate: spareRate ?? this.spareRate,
      perfectGames: perfectGames ?? this.perfectGames,
    );
  }

  @override
  String toString() {
    return 'GameStatistics(totalGames: $totalGames, totalFrames: $totalFrames, '
        'totalScore: $totalScore, averageScore: $averageScore, '
        'highestScore: $highestScore, lowestScore: $lowestScore, '
        'strikes: $strikes, spares: $spares, '
        'strikeRate: $strikeRate, spareRate: $spareRate, '
        'perfectGames: $perfectGames)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameStatistics &&
        other.totalGames == totalGames &&
        other.totalFrames == totalFrames &&
        other.totalScore == totalScore &&
        other.averageScore == averageScore &&
        other.highestScore == highestScore &&
        other.lowestScore == lowestScore &&
        other.strikes == strikes &&
        other.spares == spares &&
        other.strikeRate == strikeRate &&
        other.spareRate == spareRate &&
        other.perfectGames == perfectGames;
  }

  @override
  int get hashCode {
    return totalGames.hashCode ^
        totalFrames.hashCode ^
        totalScore.hashCode ^
        averageScore.hashCode ^
        highestScore.hashCode ^
        lowestScore.hashCode ^
        strikes.hashCode ^
        spares.hashCode ^
        strikeRate.hashCode ^
        spareRate.hashCode ^
        perfectGames.hashCode;
  }
} 