import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/game_session.dart';

class GameHistoryList extends StatelessWidget {
  final List<GameSession> gameSessions;

  const GameHistoryList({
    super.key,
    required this.gameSessions,
  });

  @override
  Widget build(BuildContext context) {
    if (gameSessions.isEmpty) {
      return const Center(
        child: Text('ゲーム履歴がありません'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: gameSessions.length,
      itemBuilder: (context, index) {
        final session = gameSessions[index];
        return _buildGameHistoryItem(session, index);
      },
    );
  }

  Widget _buildGameHistoryItem(GameSession session, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー行
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    session.gameType == GameType.full ? 'フルゲーム' : 'ハーフゲーム',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'スコア: ${session.totalScore}',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // 詳細情報
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    '日付',
                    _formatDate(session.createdAt),
                    Icons.calendar_today,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    'フレーム数',
                    '${session.frames.length}',
                    Icons.games,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    '平均',
                    '${(session.totalScore / session.frames.length).toStringAsFixed(1)}',
                    Icons.trending_up,
                  ),
                ),
              ],
            ),
            
            // フレーム詳細（折りたたみ可能）
            if (session.frames.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildFrameDetails(session.frames),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.onSurface.withOpacity(0.6),
          size: 16,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildFrameDetails(List<FrameResult> frames) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'フレーム詳細',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: frames.asMap().entries.map((entry) {
              final index = entry.key;
              final frame = entry.value;
              return _buildFrameChip(index + 1, frame);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFrameChip(int frameNumber, FrameResult frame) {
    final isStrike = frame.firstThrow == 10;
    final isSpare = !isStrike && frame.firstThrow + frame.secondThrow == 10;
    
    String displayText;
    Color chipColor;
    
    if (isStrike) {
      displayText = 'X';
      chipColor = AppColors.primary;
    } else if (isSpare) {
      displayText = '${frame.firstThrow}/';
      chipColor = AppColors.primary.withOpacity(0.7);
    } else {
      displayText = '${frame.firstThrow}-${frame.secondThrow}';
      chipColor = AppColors.onSurface.withOpacity(0.1);
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$frameNumber: $displayText',
        style: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w500,
          color: isStrike || isSpare ? Colors.white : AppColors.onSurface,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
} 