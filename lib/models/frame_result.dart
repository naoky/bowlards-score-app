class FrameResult {
  final int? id;
  final int sessionId;
  final int frameNumber;
  final int inning1Score;
  final int inning2Score;
  final int frameTotal;
  final bool isStrike;
  final bool isSpare;

  FrameResult({
    this.id,
    required this.sessionId,
    required this.frameNumber,
    required this.inning1Score,
    required this.inning2Score,
    required this.frameTotal,
    required this.isStrike,
    required this.isSpare,
  });

  // JSONからオブジェクトを作成
  factory FrameResult.fromJson(Map<String, dynamic> json) {
    return FrameResult(
      id: json['id'] as int?,
      sessionId: json['session_id'] as int,
      frameNumber: json['frame_number'] as int,
      inning1Score: json['inning1_score'] as int,
      inning2Score: json['inning2_score'] as int,
      frameTotal: json['frame_total'] as int,
      isStrike: (json['is_strike'] as int) == 1,
      isSpare: (json['is_spare'] as int) == 1,
    );
  }

  // オブジェクトをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'frame_number': frameNumber,
      'inning1_score': inning1Score,
      'inning2_score': inning2Score,
      'frame_total': frameTotal,
      'is_strike': isStrike ? 1 : 0,
      'is_spare': isSpare ? 1 : 0,
    };
  }

  // コピーを作成
  FrameResult copyWith({
    int? id,
    int? sessionId,
    int? frameNumber,
    int? inning1Score,
    int? inning2Score,
    int? frameTotal,
    bool? isStrike,
    bool? isSpare,
  }) {
    return FrameResult(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      frameNumber: frameNumber ?? this.frameNumber,
      inning1Score: inning1Score ?? this.inning1Score,
      inning2Score: inning2Score ?? this.inning2Score,
      frameTotal: frameTotal ?? this.frameTotal,
      isStrike: isStrike ?? this.isStrike,
      isSpare: isSpare ?? this.isSpare,
    );
  }

  // フレームの状態を取得
  FrameStatus get frameStatus {
    if (isStrike) return FrameStatus.strike;
    if (isSpare) return FrameStatus.spare;
    return FrameStatus.open;
  }

  // 1イニング目が完了しているか
  bool get isInning1Complete => inning1Score >= 0;

  // 2イニング目が完了しているか
  bool get isInning2Complete => inning2Score >= 0;

  // フレームが完了しているか
  bool get isFrameComplete => isInning1Complete && isInning2Complete;

  @override
  String toString() {
    return 'FrameResult(id: $id, sessionId: $sessionId, frameNumber: $frameNumber, '
        'inning1Score: $inning1Score, inning2Score: $inning2Score, '
        'frameTotal: $frameTotal, isStrike: $isStrike, isSpare: $isSpare)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FrameResult &&
        other.id == id &&
        other.sessionId == sessionId &&
        other.frameNumber == frameNumber &&
        other.inning1Score == inning1Score &&
        other.inning2Score == inning2Score &&
        other.frameTotal == frameTotal &&
        other.isStrike == isStrike &&
        other.isSpare == isSpare;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sessionId.hashCode ^
        frameNumber.hashCode ^
        inning1Score.hashCode ^
        inning2Score.hashCode ^
        frameTotal.hashCode ^
        isStrike.hashCode ^
        isSpare.hashCode;
  }
}

// フレームの状態を表す列挙型
enum FrameStatus {
  open,    // オープンフレーム
  spare,   // スペア
  strike,  // ストライク
} 