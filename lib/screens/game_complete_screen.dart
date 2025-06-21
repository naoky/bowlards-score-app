import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../providers/statistics_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/game_session.dart';
import 'home_screen.dart';

class GameCompleteScreen extends StatelessWidget {
  final GameSession completedGame;

  const GameCompleteScreen({
    super.key,
    required this.completedGame,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 完了メッセージ
              Icon(
                Icons.emoji_events,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              
              Text(
                'ゲーム完了！',
                style: AppTextStyles.titleLarge.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                'お疲れさまでした',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 40),
              
              // 最終スコア
              _buildFinalScore(),
              const SizedBox(height: 32),
              
              // ゲーム統計
              _buildGameStats(),
              const SizedBox(height: 40),
              
              // アクションボタン
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinalScore() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '最終スコア',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${completedGame.totalScore}',
            style: AppTextStyles.titleLarge.copyWith(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            completedGame.gameType == GameType.full ? 'フルゲーム' : 'ハーフゲーム',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameStats() {
    final strikes = completedGame.frames.where((frame) => frame.firstThrow == 10).length;
    final spares = completedGame.frames.where((frame) => 
      frame.firstThrow != 10 && frame.firstThrow + frame.secondThrow == 10
    ).length;
    final average = completedGame.totalScore / completedGame.frames.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ゲーム統計',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'ストライク',
                  '$strikes',
                  Icons.star,
                  AppColors.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'スペア',
                  '$spares',
                  Icons.star_half,
                  AppColors.primary.withOpacity(0.7),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '平均',
                  average.toStringAsFixed(1),
                  Icons.trending_up,
                  AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // 新しいゲーム開始ボタン
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _startNewGame(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              '新しいゲームを開始',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // ホームに戻るボタン
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () => _goToHome(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'ホームに戻る',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _startNewGame(BuildContext context) {
    final gameProvider = Provider.of<GameStateProvider>(context, listen: false);
    gameProvider.startNewGame(completedGame.gameType);
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  void _goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }
} 