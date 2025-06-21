class GameSession {
  final int? id;
  final String gameType;
  final int totalFrames;
  final int totalScore;
  final DateTime createdAt;

  GameSession({
    this.id,
    required this.gameType,
    required this.totalFrames,
    required this.totalScore,
    required this.createdAt,
  });

  // JSONからオブジェクトを作成
  factory GameSession.fromJson(Map<String, dynamic> json) {
    return GameSession(
      id: json['id'] as int?,
      gameType: json['game_type'] as String,
      totalFrames: json['total_frames'] as int,
      totalScore: json['total_score'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // オブジェクトをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_type': gameType,
      'total_frames': totalFrames,
      'total_score': totalScore,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // コピーを作成（IDを除く）
  GameSession copyWith({
    int? id,
    String? gameType,
    int? totalFrames,
    int? totalScore,
    DateTime? createdAt,
  }) {
    return GameSession(
      id: id ?? this.id,
      gameType: gameType ?? this.gameType,
      totalFrames: totalFrames ?? this.totalFrames,
      totalScore: totalScore ?? this.totalScore,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'GameSession(id: $id, gameType: $gameType, totalFrames: $totalFrames, totalScore: $totalScore, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameSession &&
        other.id == id &&
        other.gameType == gameType &&
        other.totalFrames == totalFrames &&
        other.totalScore == totalScore &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        gameType.hashCode ^
        totalFrames.hashCode ^
        totalScore.hashCode ^
        createdAt.hashCode;
  }
} 