import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/frame_result.dart';

class ScoreBoard extends StatelessWidget {
  final List<FrameResult> frames;
  final int currentFrame;

  const ScoreBoard({
    super.key,
    required this.frames,
    required this.currentFrame,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          // フレーム番号行
          _buildFrameNumbers(),
          
          // スコア行
          _buildScoreRow(),
          
          // 合計スコア行
          _buildTotalScoreRow(),
        ],
      ),
    );
  }

  Widget _buildFrameNumbers() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: List.generate(10, (index) {
          final isCurrentFrame = index + 1 == currentFrame;
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: index < 9 
                    ? BorderSide(color: AppColors.outline)
                    : BorderSide.none,
                ),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isCurrentFrame ? AppColors.primary : AppColors.onSurface,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildScoreRow() {
    return Expanded(
      child: Row(
        children: List.generate(10, (index) {
          final frame = index < frames.length ? frames[index] : null;
          final isCurrentFrame = index + 1 == currentFrame;
          
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isCurrentFrame ? AppColors.primary.withOpacity(0.05) : null,
                border: Border(
                  right: index < 9 
                    ? BorderSide(color: AppColors.outline)
                    : BorderSide.none,
                ),
              ),
              child: _buildFrameScore(frame, index == 9), // 10フレーム目は特別
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFrameScore(FrameResult? frame, bool isLastFrame) {
    if (frame == null) {
      return Container();
    }

    return Column(
      children: [
        // 1投目と2投目
        Expanded(
          child: Row(
            children: [
              // 1投目
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: AppColors.outline),
                      bottom: BorderSide(color: AppColors.outline),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _getThrowDisplay(frame.firstThrow),
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // 2投目
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.outline),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _getSecondThrowDisplay(frame.firstThrow, frame.secondThrow),
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalScoreRow() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: List.generate(10, (index) {
          final totalScore = _calculateTotalScore(index);
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: index < 9 
                    ? BorderSide(color: AppColors.outline)
                    : BorderSide.none,
                ),
              ),
              child: Center(
                child: Text(
                  totalScore > 0 ? '$totalScore' : '',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  String _getThrowDisplay(int score) {
    if (score == 10) return 'X';
    if (score == 0) return '-';
    return '$score';
  }

  String _getSecondThrowDisplay(int firstThrow, int secondThrow) {
    if (secondThrow == 0) return '-';
    if (firstThrow + secondThrow == 10) return '/';
    return '$secondThrow';
  }

  int _calculateTotalScore(int frameIndex) {
    int total = 0;
    for (int i = 0; i <= frameIndex && i < frames.length; i++) {
      final frame = frames[i];
      total += frame.firstThrow + frame.secondThrow;
      
      // ストライクのボーナス
      if (frame.firstThrow == 10 && i < frames.length - 1) {
        total += frames[i + 1].firstThrow;
        if (i < frames.length - 2) {
          total += frames[i + 1].secondThrow;
        }
      }
      // スペアのボーナス
      else if (frame.firstThrow + frame.secondThrow == 10 && i < frames.length - 1) {
        total += frames[i + 1].firstThrow;
      }
    }
    return total;
  }
} 