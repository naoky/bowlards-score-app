import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/score_board.dart';
import '../widgets/frame_input.dart';
import '../widgets/game_header.dart';
import 'game_complete_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<GameStateProvider>(
          builder: (context, gameProvider, child) {
            if (gameProvider.currentGame == null) {
              return const Center(
                child: Text('ゲームが開始されていません'),
              );
            }

            // ゲーム完了時の処理
            if (gameProvider.isGameFinished) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameCompleteScreen(
                      completedGame: gameProvider.currentGame!,
                    ),
                  ),
                );
              });
            }

            return Column(
              children: [
                // ゲームヘッダー
                GameHeader(
                  gameType: gameProvider.currentGame!.gameType,
                  currentFrame: gameProvider.currentFrame,
                  totalFrames: gameProvider.currentGame!.totalFrames,
                ),
                
                // スコアボード
                Expanded(
                  flex: 2,
                  child: ScoreBoard(
                    frames: gameProvider.currentGame!.frames,
                    currentFrame: gameProvider.currentFrame,
                  ),
                ),
                
                // フレーム入力
                Expanded(
                  flex: 1,
                  child: FrameInput(
                    onScoreSubmitted: (firstThrow, secondThrow) {
                      gameProvider.addFrameResult(firstThrow, secondThrow);
                    },
                    currentFrame: gameProvider.currentFrame,
                    isLastFrame: gameProvider.currentFrame == gameProvider.currentGame!.totalFrames,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
} 