# キーワード

## 重要なキーワード一覧

本書で使用する重要なキーワードについて説明します。

## Pandoc

**Pandoc**は、様々なマークアップ形式間でドキュメントを変換するためのコマンドラインツールです。

### 特徴

- **多様な入力形式**: Markdown、LaTeX、HTML、Word docxなど
- **豊富な出力形式**: PDF、EPUB、HTML、Word docxなど
- **拡張可能**: Luaフィルターによるカスタマイズ
- **高品質な出力**: 学術論文レベルの品質

### 使用例

```bash
# MarkdownからEPUBへの変換
pandoc input.md -o output.epub

# 複数ファイルの結合と変換
pandoc chapter*.md -o book.pdf

# CSSスタイルの適用
pandoc input.md --css=style.css -o output.html
```

## Markdown

**Markdown**は、軽量マークアップ言語の一つです。

### 基本構文

```markdown
# 見出し1
## 見出し2

**太字** *斜体*

- リスト項目1
- リスト項目2

[リンク](https://example.com)

![画像](image.png)
```

### 拡張構文

本プロジェクトでは以下の拡張を使用します：

- **テーブル**: GitHubスタイルのテーブル記法
- **コードブロック**: シンタックスハイライト対応
- **数式**: LaTeX記法による数式表現
- **脚注**: 学術的な文書に対応

## EPUB

**EPUB**は、電子書籍の標準的なファイル形式です。

### EPUBの特徴

- **リフロー**: 画面サイズに応じたレイアウト調整
- **アクセシビリティ**: スクリーンリーダー対応
- **メタデータ**: 書籍情報の埋め込み
- **DRM対応**: デジタル著作権管理

### EPUBの構造

```
book.epub
├── META-INF/
│   └── container.xml
├── OEBPS/
│   ├── content.opf
│   ├── toc.ncx
│   ├── chapters/
│   ├── images/
│   └── styles/
└── mimetype
```

## CI/CD

**継続的インテグレーション/継続的デプロイメント**による自動化です。

### GitHub Actions

本プロジェクトでは以下の自動化を行います：

1. **リント**: textlintによる文章校正
2. **ビルド**: Pandocによる書籍生成
3. **テスト**: 出力ファイルの検証
4. **デプロイ**: 成果物の配布

### ワークフロー例

```mermaid
graph LR
    A[Push] --> B[Lint]
    B --> C[Build]
    C --> D[Test]
    D --> E[Deploy]
```

## まとめ

これらのキーワードを理解することで、効率的な技術書執筆が可能になります。

---

::: tip
**ヒント**: 各キーワードの詳細な使い方は、後続の章で実践的に学んでいきます。
:::

次の章からは、実際の環境構築について説明します。
