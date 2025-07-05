# Pandoc Book Starter

Pandocを使用した技術書執筆のためのスターターテンプレート

## 概要

このプロジェクトは、Pandocを使って効率的に技術書を執筆・出版するためのテンプレートです。Markdownで書いた原稿を、EPUB、PDF、HTMLなど複数の形式に変換できます。

## 特徴

- 📝 **Markdownベースの執筆**: シンプルなMarkdown記法で執筆
- 🌍 **多言語対応**: 日本語・英語など複数言語に対応
- 📚 **複数出力形式**: EPUB、PDF、HTML出力をサポート
- 🎨 **カスタマイズ可能なスタイル**: CSS、Luaフィルターによるカスタマイズ
- 🔄 **CI/CD対応**: GitHub Actionsによる自動ビルド
- 📖 **複数巻対応**: シリーズ本の管理が可能

## ファイル構成

```
pandoc-book-starter/
├─ README.md              # このファイル
├─ Makefile              # ビルド自動化
├─ Dockerfile            # コンテナ環境
├─ .textlintrc           # 文章校正設定
├─ .gitignore            # Git除外設定
├─ .github/
│  └─ workflows/
│     └─ build.yml       # GitHub Actions設定
├─ shared/               # 共有リソース
│  ├─ assets/           # スタイルとフォント
│  │  ├─ epub.css       # EPUB用CSS
│  │  ├─ web.css        # Web用CSS
│  │  └─ fonts/         # フォントファイル
│  └─ filters/          # Pandocフィルター
│     ├─ autoid.lua     # 自動ID付与
│     └─ mermaid.lua    # Mermaid図表対応
├─ vol1/                # 第1巻
│  ├─ src/              # 原稿ファイル
│  │  ├─ ja/            # 日本語版
│  │  └─ en/            # 英語版
│  ├─ assets/           # 巻固有のアセット
│  └─ meta/             # メタデータ
└─ vol2/                # 第2巻（拡張用）
```

## 必要な環境

### 基本環境

- [Pandoc](https://pandoc.org/) 3.7以降
- [Make](https://www.gnu.org/software/make/)
- [Node.js](https://nodejs.org/) （textlint用）

### オプション環境

- [Docker](https://www.docker.com/) （コンテナ使用時）
- [TeX Live](https://www.tug.org/texlive/) （PDF出力時）
- [Mermaid CLI](https://github.com/mermaid-js/mermaid-cli) （図表生成時）

## クイックスタート

### 1. リポジトリのクローン

```bash
git clone https://github.com/yourusername/pandoc-book-starter.git
cd pandoc-book-starter
```

### 2. 依存関係のインストール

```bash
# textlintのインストール
npm install -g textlint
npm install -g textlint-rule-preset-ja-technical-writing
npm install -g textlint-rule-preset-ja-spacing
npm install -g textlint-rule-prh
```

### 3. ビルド実行

```bash
# 全ての形式でビルド
make build-all

# 日本語版のみビルド
make build-ja

# 英語版のみビルド
make build-en
```

### 4. 出力ファイルの確認

ビルドされたファイルは `build/` ディレクトリに出力されます。

## 執筆ガイド

### 原稿の書き方

1. `vol1/src/ja/` または `vol1/src/en/` にMarkdownファイルを配置
2. ファイル名は章番号で始める（例: `01_theme.md`, `02_keyword.md`）
3. 見出しは `#` から開始

### メタデータの設定

`vol1/meta/ja.yaml` または `vol1/meta/en.yaml` でメタデータを設定：

```yaml
title: "書籍タイトル"
author: "著者名"
date: "出版日"
description: "書籍の説明"
```

### スタイルのカスタマイズ

- EPUB用: `shared/assets/epub.css`
- Web用: `shared/assets/web.css`
- フィルター: `shared/filters/*.lua`

## Docker使用

```bash
# イメージのビルド
docker build -t pandoc-book .

# コンテナでビルド実行
docker run --rm -v $(pwd):/workspace pandoc-book make build-all
```

## CI/CD

GitHub Actionsが自動的に：

1. プッシュ時にtextlintによる校正を実行
2. 全形式でのビルドを実行
3. 成果物をアーティファクトとして保存

## カスタマイズ

### 新しい巻の追加

1. `vol2/`, `vol3/` などのディレクトリを作成
2. `vol1/` と同じ構造でファイルを配置
3. `Makefile` にビルドターゲットを追加

### 出力形式の追加

1. Pandocがサポートする形式を `Makefile` に追加
2. 必要に応じてCSSやフィルターを作成

## トラブルシューティング

### よくある問題

1. **フォントが見つからない**: `shared/assets/fonts/` に適切なフォントファイルを配置
2. **Mermaid図表が表示されない**: `mermaid-cli` をインストール
3. **PDF生成エラー**: TeX Liveをインストール

### ログの確認

```bash
# デバッグモードでビルド
make build-ja PANDOC_OPTS="--verbose"
```

## ライセンス

MIT License - 詳細は [LICENSE](LICENSE) ファイルを参照

## 貢献

プルリクエストやイシューの報告を歓迎します。

## 参考資料

- [Pandoc User's Guide](https://pandoc.org/MANUAL.html)
- [Markdown記法](https://www.markdownguide.org/)
- [textlint](https://textlint.github.io/)
- [GitHub Actions](https://docs.github.com/en/actions)