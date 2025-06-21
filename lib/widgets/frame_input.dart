import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class FrameInput extends StatefulWidget {
  final Function(int firstThrow, int secondThrow) onScoreSubmitted;
  final int currentFrame;
  final bool isLastFrame;

  const FrameInput({
    super.key,
    required this.onScoreSubmitted,
    required this.currentFrame,
    required this.isLastFrame,
  });

  @override
  State<FrameInput> createState() => _FrameInputState();
}

class _FrameInputState extends State<FrameInput> {
  final TextEditingController _firstThrowController = TextEditingController();
  final TextEditingController _secondThrowController = TextEditingController();
  final FocusNode _firstThrowFocus = FocusNode();
  final FocusNode _secondThrowFocus = FocusNode();

  @override
  void dispose() {
    _firstThrowController.dispose();
    _secondThrowController.dispose();
    _firstThrowFocus.dispose();
    _secondThrowFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.outline),
        ),
      ),
      child: Column(
        children: [
          // フレーム番号表示
          Text(
            'フレーム ${widget.currentFrame}',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // 入力フィールド
          Row(
            children: [
              // 1投目
              Expanded(
                child: _buildInputField(
                  controller: _firstThrowController,
                  focusNode: _firstThrowFocus,
                  label: '1投目',
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final score = int.tryParse(value);
                      if (score != null && score >= 0 && score <= 10) {
                        if (score == 10) {
                          // ストライクの場合は2投目を0に設定
                          _secondThrowController.text = '0';
                          _submitScore();
                        } else {
                          _secondThrowFocus.requestFocus();
                        }
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              
              // 2投目
              Expanded(
                child: _buildInputField(
                  controller: _secondThrowController,
                  focusNode: _secondThrowFocus,
                  label: '2投目',
                  enabled: _firstThrowController.text.isNotEmpty,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final firstScore = int.tryParse(_firstThrowController.text) ?? 0;
                      final secondScore = int.tryParse(value);
                      if (secondScore != null && secondScore >= 0 && secondScore <= 10 - firstScore) {
                        _submitScore();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 送信ボタン
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _canSubmit() ? _submitScore : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'スコアを記録',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    bool enabled = true,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            hintText: '0-10',
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  bool _canSubmit() {
    final firstScore = int.tryParse(_firstThrowController.text);
    final secondScore = int.tryParse(_secondThrowController.text);
    
    if (firstScore == null) return false;
    if (firstScore == 10) return true; // ストライク
    if (secondScore == null) return false;
    
    return firstScore + secondScore <= 10;
  }

  void _submitScore() {
    final firstScore = int.tryParse(_firstThrowController.text) ?? 0;
    final secondScore = int.tryParse(_secondThrowController.text) ?? 0;
    
    if (_canSubmit()) {
      widget.onScoreSubmitted(firstScore, secondScore);
      
      // 入力フィールドをクリア
      _firstThrowController.clear();
      _secondThrowController.clear();
      _firstThrowFocus.requestFocus();
    }
  }
} 