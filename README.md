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
├─ Makefile              # ビルド自動化（EPUB_OPTS/PDF_OPTS対応）
├─ Dockerfile            # コンテナ環境（Node.js 20 + Mermaid CLI）
├─ .textlintrc           # 文章校正設定
├─ .gitignore            # Git除外設定
├─ .github/
│  └─ workflows/
│     └─ build.yml       # GitHub Actions設定（自動リリース対応）
├─ shared/               # 共有リソース
│  ├─ assets/           # スタイルとフォント
│  │  ├─ epub.css       # EPUB用CSS
│  │  ├─ web.css        # Web用CSS
│  │  └─ fonts/         # フォントファイル
│  │     ├─ FiraCode-Regular.ttf
│  │     └─ NotoSansJP-Regular.otf
│  └─ filters/          # Pandocフィルター
│     ├─ autoid.lua     # 自動ID付与
│     ├─ mermaid.lua    # Mermaid図表対応
│     └─ number-chapter.lua # 章番号の多言語対応
├─ vol1/                # 第1巻
│  ├─ src/              # 原稿ファイル
│  │  ├─ ja/            # 日本語版
│  │  │  ├─ 00_01_preface.md      # はじめに
│  │  │  ├─ 01_intro.md           # イントロダクション
│  │  │  ├─ 02_keyword.md         # キーワード調査
│  │  │  └─ 03_theme.md           # テーマについて
│  │  └─ en/            # 英語版
│  │     └─ 01_theme.md           # Theme
│  ├─ assets/           # 巻固有のアセット
│  │  ├─ cover-ja.png   # 日本語版カバー
│  │  └─ cover-en.png   # 英語版カバー
│  └─ meta/             # メタデータ
│     ├─ ja.yaml        # 日本語版設定
│     ├─ en.yaml        # 英語版設定
│     ├─ ja_title.txt   # 日本語版タイトル
│     └─ en_title.txt   # 英語版タイトル
└─ vol2/                # 第2巻（拡張用）
```

## 必要な環境

### 基本環境

- [Pandoc](https://pandoc.org/) 3.7.0.2以降
- [Make](https://www.gnu.org/software/make/)
- [Node.js](https://nodejs.org/) 20.x以降

### オプション環境

- [Docker](https://www.docker.com/) （推奨: 環境統一のため）
- [TeX Live](https://www.tug.org/texlive/) 2025 （PDF出力時）
- [Mermaid CLI](https://github.com/mermaid-js/mermaid-cli) 10.9.1以降

## クイックスタート

### 1. リポジトリのクローン

```bash
git clone https://github.com/dicekanbe/pandoc-book-starter.git
cd pandoc-book-starter
```

### 2. 依存関係のインストール

#### ローカル環境の場合
```bash
# textlintのインストール
npm install -g textlint@14.2.1
npm install -g textlint-rule-preset-jtf-style@2.3.14
```

#### Docker環境の場合（推奨）
```bash
# Dockerイメージのビルド
docker build -t pandoc-book .
```

### 3. ビルド実行

#### ローカル環境
```bash
# 利用可能なターゲットを確認
make help

# 日本語EPUB
make epub

# 日本語PDF
make pdf

# 英語版
make epub-en
make pdf-en

# 全てのビルド
make epub-all pdf-all
```

#### Docker環境
```bash
# Dockerコンテナでビルド
docker run --rm -v $(pwd):/data --entrypoint="" pandoc-book sh -c \
  "pandoc /data/vol1/src/ja/*.md --to epub3 --css /data/shared/assets/epub.css \
   --metadata-file /data/vol1/meta/ja.yaml -o /data/book.epub"
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

## Docker環境の詳細

### Dockerイメージの構成
- ベース: `pandoc/latex:latest-ubuntu`
- Pandoc 3.7.0.2
- Node.js 20.x
- Mermaid CLI 10.9.1
- 日本語フォント対応

### 使用例
```bash
# イメージのビルド
docker build -t pandoc-book .

# EPUBの生成
docker run --rm -v $(pwd):/data --entrypoint="" pandoc-book sh -c \
  "pandoc /data/vol1/src/ja/*.md --to epub3 \
   --css /data/shared/assets/epub.css \
   --metadata-file /data/vol1/meta/ja.yaml \
   --epub-cover-image /data/vol1/assets/cover-ja.png \
   -o /data/book.epub"

# PDFの生成（フォント指定あり）
docker run --rm -v $(pwd):/data --entrypoint="" pandoc-book sh -c \
  "pandoc /data/vol1/src/ja/*.md --to pdf \
   --pdf-engine=xelatex \
   --metadata lang=ja \
   --metadata mainfont='Noto Sans Japanese' \
   -o /data/book.pdf"
```

## CI/CD

GitHub Actionsが自動的に：

1. **プッシュ時**:
   - textlintによる校正を実行
   - EPUB/PDFのビルドを実行
   - EPUBCheckによる検証
   - 成果物をアーティファクトとして保存

2. **タグプッシュ時**:
   - 上記に加えて自動リリース作成
   - GitHub ReleasesにEPUB/PDFを添付
   - 日本語版・英語版の両方をリリース

### リリースの作成方法
```bash
# バージョンタグを作成
git tag v1.0.0
git push origin v1.0.0
```

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

1. **フォントが見つからない（PDF）**:
   - 解決策: システムフォントを使用するか、`shared/assets/fonts/` にフォントファイルを配置
   - 日本語フォント: `Noto Sans Japanese`, `Hiragino Sans`, `Yu Gothic`など

2. **Mermaid図表が表示されない**:
   - 解決策: `mermaid-cli` 10.9.1以降をインストール
   - Docker環境では自動的にインストール済み

3. **PDF生成エラー**:
   - 解決策: TeX Live 2025をインストール、または`ltjsbook`クラスを使用
   - 日本語PDF: LuaLaTeX + luatexja-fontspecを推奨

4. **EPUB検証エラー**:
   - 解決策: EPUBCheckで検証し、HTMLタグやCSSの問題を修正
   - 画像ファイルの形式・サイズを確認

5. **GitHub Actions失敗**:
   - 解決策: `GITHUB_TOKEN`の権限確認、ファイルパスの確認
   - リリース作成時は`contents: write`権限が必要

### ログの確認

```bash
# デバッグモードでビルド
make epub PANDOC_OPTS="--verbose"

# Docker環境でのデバッグ
docker run --rm -v $(pwd):/data --entrypoint="" pandoc-book sh -c \
  "pandoc /data/vol1/src/ja/*.md --to epub3 --verbose \
   --css /data/shared/assets/epub.css \
   --metadata-file /data/vol1/meta/ja.yaml \
   -o /data/debug.epub"
```

### 環境別の設定

#### macOS
```bash
# Homebrewでの環境構築
brew install pandoc
brew install --cask mactex
npm install -g @mermaid-js/mermaid-cli
```

#### Ubuntu/Debian
```bash
# システムパッケージでの環境構築
sudo apt update
sudo apt install pandoc texlive-full
npm install -g @mermaid-js/mermaid-cli
```

#### Windows
```bash
# Chocolateyでの環境構築
choco install pandoc
choco install miktex
npm install -g @mermaid-js/mermaid-cli
```

## ライセンス

MIT License - 詳細は [LICENSE](LICENSE) ファイルを参照

## 貢献

プルリクエストやイシューの報告を歓迎します。

## 参考資料

### 公式ドキュメント
- [Pandoc User's Guide](https://pandoc.org/MANUAL.html) - Pandoc公式マニュアル
- [Pandoc Lua Filters](https://pandoc.org/lua-filters.html) - Luaフィルター作成ガイド
- [EPUB 3.3 Specification](https://www.w3.org/TR/epub-33/) - EPUB仕様書
- [GitHub Actions Documentation](https://docs.github.com/en/actions) - GitHub Actions公式ドキュメント

### 技術資料
- [Markdown記法](https://www.markdownguide.org/) - Markdown記法ガイド
- [textlint](https://textlint.github.io/) - 文章校正ツール
- [Mermaid](https://mermaid.js.org/) - 図表作成ツール
- [LaTeX日本語処理](https://texwiki.texjp.org/) - LaTeX日本語組版

### 関連ツール
- [EPUBCheck](https://github.com/w3c/epubcheck) - EPUB検証ツール
- [Calibre](https://calibre-ebook.com/) - 電子書籍管理ツール
- [Sigil](https://sigil-ebook.com/) - EPUBエディタ