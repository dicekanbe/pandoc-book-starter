# AGENTS.md

AI エージェント共通の指示書です。Codex、Cursor、GitHub Copilot、Claude Code などで利用できます。

## プロジェクト概要

Pandoc を使った技術書執筆のガイドブック。Markdown で書いた原稿を EPUB/PDF に変換します。

## 執筆ルール

| ルール | 内容 |
|--------|------|
| 文体 | です・ます調 |
| 一文の長さ | 200 文字以内 |
| 半角/全角間 | スペースを入れる |
| 漢字連続 | 10 文字以内 |
| 見出し | `#`（章）、`##`（節）、`###`（項） |
| コードブロック | 言語指定を必ず付ける |
| 画像配置 | `vol1/src/ja/img/` |

## ビルドコマンド

```bash
make epub          # EPUB 生成
make pdf           # PDF 生成
make clean         # ビルド成果物削除
npx textlint vol1/src/ja/*.md       # 文章チェック
npx textlint --fix vol1/src/ja/*.md # 自動修正
```

## ファイル構成

```
vol1/src/ja/*.md   - 原稿ファイル
vol1/meta/         - メタデータ（YAML）
shared/assets/     - CSS、フォント
shared/filters/    - Pandoc Lua フィルター
build/             - 出力先（編集禁止）
```

## 禁止事項

- `build/` ディレクトリへの直接編集
- `node_modules/` の変更
- `.textlintrc` の警告無効化（相談なしに）
- `prh.yml` の表記ルール削除

## コミットメッセージ

```
例: vol1/03章 執筆環境の説明を追加
例: fix: textlint errors in chapter 03
```

## 参考ファイル

- `README-jp.md` - プロジェクト詳細説明
- `.textlintrc` - textlint 設定
- `prh.yml` - 表記ゆれ辞書
- `Makefile` - ビルドコマンド定義
