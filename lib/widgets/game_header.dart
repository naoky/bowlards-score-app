import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/game_session.dart';

class GameHeader extends StatelessWidget {
  final GameType gameType;
  final int currentFrame;
  final int totalFrames;

  const GameHeader({
    super.key,
    required this.gameType,
    required this.currentFrame,
    required this.totalFrames,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.outline),
        ),
      ),
      child: Row(
        children: [
          // ゲームタイプ
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              gameType == GameType.full ? 'フルゲーム' : 'ハーフゲーム',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          
          // フレーム進捗
          Text(
            'フレーム $currentFrame / $totalFrames',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 