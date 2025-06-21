# ボーラードスコアアプリ

ビリヤードのボーラードゲームのスコア記録アプリです。

## 機能

- フルゲーム（10フレーム）とハーフゲーム（5フレーム）の選択
- ボーリングのようなスコア表示（ストライク: X、スペア: /）
- 数値入力によるスコア記録
- 端末内でのデータ保存（SQLite）
- スコア推移のグラフ表示
- iOS/Android対応

## 開発状況

- [x] プロジェクト初期化
- [x] 依存関係の設定
- [x] データモデル作成
- [x] 状態管理実装
- [x] UI画面作成
  - [x] ホーム画面
  - [x] ゲーム画面
  - [x] 統計画面
  - [x] ゲーム完了画面
  - [x] スコアボードウィジェット
  - [x] フレーム入力ウィジェット
  - [x] 統計チャートウィジェット
  - [x] ゲーム履歴リストウィジェット

## 技術スタック

- Flutter 3.19.0
- Dart 3.3.0
- Provider (状態管理)
- sqflite (データベース)
- fl_chart (グラフ表示)

## セットアップ

1. Flutter環境の確認
```bash
flutter doctor
```

2. 依存関係のインストール
```bash
flutter pub get
```

3. アプリの実行
```bash
flutter run
```

## プロジェクト構造

```
lib/
├── constants/          # アプリ定数
├── models/            # データモデル
├── providers/         # 状態管理
├── screens/           # 画面
├── services/          # サービス
├── utils/             # ユーティリティ
├── widgets/           # ウィジェット
└── main.dart          # エントリーポイント
```

## 今後の予定

- [ ] データベースサービスの実装
- [ ] エラーハンドリングの追加
- [ ] ユニットテストの作成
- [ ] UI/UXの改善
- [ ] パフォーマンス最適化

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

## ライセンス

このプロジェクトは個人開発用です。
