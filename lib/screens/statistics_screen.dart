import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/statistics_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/statistics_chart.dart';
import '../widgets/game_history_list.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '統計',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.onSurface),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurface.withOpacity(0.6),
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'グラフ'),
            Tab(text: '履歴'),
          ],
        ),
      ),
      body: Consumer<StatisticsProvider>(
        builder: (context, statisticsProvider, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              // グラフタブ
              _buildGraphTab(statisticsProvider),
              
              // 履歴タブ
              _buildHistoryTab(statisticsProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGraphTab(StatisticsProvider statisticsProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 統計サマリー
          _buildStatisticsSummary(statisticsProvider),
          const SizedBox(height: 24),
          
          // グラフ
          Expanded(
            child: StatisticsChart(
              gameSessions: statisticsProvider.gameSessions,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(StatisticsProvider statisticsProvider) {
    return GameHistoryList(
      gameSessions: statisticsProvider.gameSessions,
    );
  }

  Widget _buildStatisticsSummary(StatisticsProvider statisticsProvider) {
    final stats = statisticsProvider.getStatistics();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '統計サマリー',
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '総ゲーム数',
                  '${stats.totalGames}',
                  Icons.games,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '平均スコア',
                  '${stats.averageScore.toStringAsFixed(1)}',
                  Icons.trending_up,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '最高スコア',
                  '${stats.highestScore}',
                  Icons.emoji_events,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
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
} 