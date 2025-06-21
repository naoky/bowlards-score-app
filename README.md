# ボーラードスコアアプリ

ビリヤードのボーラードゲーム（10フレーム制、300点満点）のスコアを記録し、プレイヤーの上達を可視化するためのモバイルアプリケーションです。

## 機能

- フルゲーム（10フレーム）またはハーフゲーム（5フレーム）の選択
- リアルタイムスコア入力と表示
- ストライク・スペアの判定
- 統計情報とグラフ表示
- ゲーム履歴の管理
- ローカルデータ保存

## 開発環境

### 必要なツール

- Flutter 3.32.4以上
- Dart 3.8.1以上
- Android Studio / VS Code
- iOS開発の場合はXcode

### セットアップ

1. リポジトリをクローン
```bash
git clone [repository-url]
cd bowlards_score_app
```

2. 依存関係をインストール
```bash
flutter pub get
```

3. アプリを実行
```bash
# Web版
flutter run -d chrome

# iOS版
flutter run -d ios

# Android版
flutter run -d android
```

## プロジェクト構造

```
lib/
├── constants/          # 定数定義
│   ├── app_constants.dart
│   ├── app_colors.dart
│   └── app_text_styles.dart
├── models/            # データモデル
├── providers/         # 状態管理
├── screens/           # 画面
├── services/          # サービス
│   └── database_service.dart
├── utils/             # ユーティリティ
└── widgets/           # ウィジェット
```

## 使用ライブラリ

- **sqflite**: SQLiteデータベース
- **provider**: 状態管理
- **fl_chart**: グラフ表示
- **intl**: 国際化・日付処理
- **shared_preferences**: 共有設定

## 開発状況

- [x] プロジェクトセットアップ
- [x] 基本構造作成
- [x] データベース設計
- [ ] データモデル作成
- [ ] 状態管理実装
- [ ] UI画面作成
- [ ] スコア入力機能
- [ ] 統計・グラフ機能
- [ ] 履歴管理機能
- [ ] テスト実装

## ライセンス

このプロジェクトは個人開発用です。
