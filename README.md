# Pandoc Book Starter

A starter template for technical book writing using Pandoc

> [日本語版はこちら](README-jp.md) / [Japanese version is here](README-jp.md)

## Overview

This project is a template for efficiently writing and publishing technical books using Pandoc. You can convert manuscripts written in Markdown to multiple formats such as EPUB, PDF, and HTML.

## Features

- 📝 **Markdown-based writing**: Write using simple Markdown syntax
- 🌍 **Multi-language support**: Supports multiple languages including Japanese and English
- 📚 **Multiple output formats**: Supports EPUB, PDF, and HTML output
- 🎨 **Customizable styles**: Customization through CSS and Lua filters
- 🔄 **CI/CD support**: Automated builds with GitHub Actions
- 📖 **Multi-volume support**: Manage series books

## File Structure

```
pandoc-book-starter/
├─ README.md              # This file
├─ Makefile              # Build automation (EPUB_OPTS/PDF_OPTS support)
├─ Dockerfile            # Container environment (Node.js 20 + Mermaid CLI)
├─ .textlintrc           # Text linting configuration
├─ .gitignore            # Git ignore settings
├─ .github/
│  └─ workflows/
│     └─ build.yml       # GitHub Actions configuration (auto-release support)
├─ shared/               # Shared resources
│  ├─ assets/           # Styles and fonts
│  │  ├─ epub.css       # EPUB CSS
│  │  ├─ web.css        # Web CSS
│  │  └─ fonts/         # Font files
│  │     ├─ FiraCode-Regular.ttf
│  │     └─ NotoSansJP-Regular.otf
│  └─ filters/          # Pandoc filters
│     ├─ autoid.lua     # Auto ID assignment
│     ├─ mermaid.lua    # Mermaid diagram support
│     └─ number-chapter.lua # Multi-language chapter numbering
├─ vol1/                # Volume 1
│  ├─ src/              # Manuscript files
│  │  ├─ ja/            # Japanese version
│  │  │  ├─ 00_01_preface.md      # Preface
│  │  │  ├─ 01_intro.md           # Introduction
│  │  │  ├─ 02_keyword.md         # Keyword research
│  │  │  └─ 03_theme.md           # About the theme
│  │  └─ en/            # English version
│  │     └─ 01_theme.md           # Theme
│  ├─ assets/           # Volume-specific assets
│  │  ├─ cover-ja.png   # Japanese cover
│  │  └─ cover-en.png   # English cover
│  └─ meta/             # Metadata
│     ├─ ja.yaml        # Japanese settings
│     ├─ en.yaml        # English settings
│     ├─ ja_title.txt   # Japanese title
│     └─ en_title.txt   # English title
└─ vol2/                # Volume 2 (for expansion)
```

## Required Environment

### Basic Environment

- [Pandoc](https://pandoc.org/) 3.7.0.2 or later
- [Make](https://www.gnu.org/software/make/)
- [Node.js](https://nodejs.org/) 20.x or later

### Optional Environment

- [Docker](https://www.docker.com/) (Recommended: for environment consistency)
- [TeX Live](https://www.tug.org/texlive/) 2025 (for PDF output)
- [Mermaid CLI](https://github.com/mermaid-js/mermaid-cli) 10.9.1 or later

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/dicekanbe/pandoc-book-starter.git
cd pandoc-book-starter
```

### 2. Install dependencies

#### For local environment
```bash
# Install textlint
npm install -g textlint@14.2.1
npm install -g textlint-rule-preset-jtf-style@2.3.14
```

#### For Docker environment (Recommended)
```bash
# Build Docker image
docker build -t pandoc-book .
```

### 3. Execute build

#### Local environment
```bash
# Check available targets
make help

# Japanese EPUB
make epub

# Japanese PDF
make pdf

# English version
make epub-en
make pdf-en

# Build all
make all
```

#### Docker environment
```bash
# Build with Docker container
docker run --rm -v $(pwd):/data --entrypoint="" pandoc-book sh -c \
  "cd /data/vol1 && pandoc src/ja/*.md --to epub3 --css /data/shared/assets/epub.css \
   --metadata-file meta/ja.yaml -o /data/book.epub"
```

### 4. Check output files

Built files are output to the `build/` directory.

## Writing Guide

### How to write manuscripts

1. Place Markdown files in `vol1/src/ja/` or `vol1/src/en/`
2. Start file names with chapter numbers (e.g., `01_theme.md`, `02_keyword.md`)
3. Start headings with `#`

### Metadata configuration

Configure metadata in `vol1/meta/ja.yaml` or `vol1/meta/en.yaml`:

```yaml
title: "Book Title"
author: "Author Name"
date: "Publication Date"
description: "Book Description"
```

### Style customization

- EPUB: `shared/assets/epub.css`
- Web: `shared/assets/web.css`
- Filters: `shared/filters/*.lua`

## Docker Environment Details

### Docker Image Configuration
- Base: `pandoc/latex:latest-ubuntu`
- Pandoc 3.7.0.2
- Node.js 20.x
- Mermaid CLI 10.9.1
- Japanese font support

### Usage Examples
```bash
# Build image
docker build -t pandoc-book .

# Generate EPUB
docker run --rm -v $(pwd):/data --entrypoint="" pandoc-book sh -c \
  "cd /data/vol1 && pandoc src/ja/*.md --to epub3 \
   --css /data/shared/assets/epub.css \
   --metadata-file meta/ja.yaml \
   --epub-cover-image assets/cover-ja.png \
   -o /data/book.epub"

# Generate PDF (Japanese support)
docker run --rm -v $(pwd):/data --entrypoint="" pandoc-book sh -c \
  "cd /data/vol1 && pandoc src/ja/*.md --to pdf \
   --pdf-engine=lualatex \
   --metadata-file=meta/ja.yaml \
   --metadata lang=ja \
   --metadata documentclass=article \
   --metadata mainfont='Noto Sans CJK JP' \
   --metadata sansfont='Noto Sans CJK JP' \
   --metadata monofont='Noto Sans Mono CJK JP' \
   -o /data/book.pdf"
```

## CI/CD

GitHub Actions automatically:

1. **On push**:
   - Run textlint for proofreading
   - Execute EPUB/PDF builds
   - Validate with EPUBCheck
   - Save artifacts

2. **On tag push**:
   - Create automatic releases in addition to the above
   - Attach EPUB/PDF to GitHub Releases
   - Release both Japanese and English versions

### How to create releases
```bash
# Create version tag
git tag v1.0.0
git push origin v1.0.0
```

## Customization

### Adding new volumes

1. Create directories like `vol2/`, `vol3/`, etc.
2. Place files with the same structure as `vol1/`
3. Add build targets to `Makefile`

### Adding output formats

1. Add formats supported by Pandoc to `Makefile`
2. Create CSS and filters as needed

## Troubleshooting

### Common Issues

1. **Font not found (PDF)**:
   - Solution: Use system fonts or place font files in `shared/assets/fonts/`
   - Japanese fonts: `Noto Sans CJK JP`, `Hiragino Sans`, `Yu Gothic`, etc.
   - Code block fonts: `Noto Sans Mono CJK JP`, `Source Han Code JP`, etc. for Japanese-compatible monospace fonts

2. **Mermaid diagrams not displaying**:
   - Solution: Install `mermaid-cli` 10.9.1 or later
   - Automatically installed in Docker environment

3. **PDF generation errors**:
   - Solution: Install TeX Live 2025, use `article` class
   - Japanese PDF: Recommended LuaLaTeX + command line font specification
   - `ltjsbook.cls` error: Use `--metadata documentclass=article`
   - Japanese characters in code blocks error: Set `monofont` to Japanese-compatible font

4. **EPUB validation errors**:
   - Solution: Validate with EPUBCheck and fix HTML tag and CSS issues
   - Check image file format and size

5. **GitHub Actions failures**:
   - Solution: Check `GITHUB_TOKEN` permissions, verify file paths
   - `contents: write` permission required for release creation

6. **Japanese characters not displaying in code blocks**:
   - Cause: Monospace font (monofont) not compatible with Japanese
   - Solution: Add `--metadata monofont='Noto Sans Mono CJK JP'`
   - Alternative fonts: `Source Han Code JP`, `Ricty Diminished`, etc.

7. **Complete solution for Japanese PDF generation**:
   - Recommended command (no external files required):
   ```bash
   docker run --rm -v $(pwd):/data --entrypoint="" pandoc-book sh -c \
     "cd /data/vol1 && pandoc src/ja/*.md --to pdf \
      --pdf-engine=lualatex \
      --metadata lang=ja \
      --metadata documentclass=article \
      --metadata mainfont='Noto Sans CJK JP' \
      --metadata sansfont='Noto Sans CJK JP' \
      --metadata monofont='Noto Sans Mono CJK JP' \
      -o /data/book.pdf"
   ```
   - For `ltjsbook.cls` errors: Use `article` class
   - For font warnings: Specify all three fonts (main/sans/mono)

### Checking logs

```bash
# Build in debug mode
make epub PANDOC_OPTS="--verbose"

# Debug in Docker environment (EPUB)
docker run --rm -v $(pwd):/data --entrypoint="" pandoc-book sh -c \
  "cd /data/vol1 && pandoc src/ja/*.md --to epub3 --verbose \
   --css /data/shared/assets/epub.css \
   --metadata-file meta/ja.yaml \
   -o /data/debug.epub"

# Debug in Docker environment (PDF with Japanese font support)
docker run --rm -v $(pwd):/data --entrypoint="" pandoc-book sh -c \
  "cd /data/vol1 && pandoc src/ja/*.md --to pdf  --verbose \
   --pdf-engine=lualatex \
   --metadata lang=ja \
   --metadata documentclass=article \
   --metadata mainfont='Noto Sans CJK JP' \
   --metadata sansfont='Noto Sans CJK JP' \
   --metadata monofont='Noto Sans Mono CJK JP' \
   -o /data/debug.pdf"
```

### Environment-specific settings

#### macOS
```bash
# Environment setup with Homebrew
brew install pandoc
brew install --cask mactex
npm install -g @mermaid-js/mermaid-cli
```

#### Ubuntu/Debian
```bash
# Environment setup with system packages
sudo apt update
sudo apt install pandoc texlive-full
npm install -g @mermaid-js/mermaid-cli
```

#### Windows
```bash
# Environment setup with Chocolatey
choco install pandoc
choco install miktex
npm install -g @mermaid-js/mermaid-cli
```

## License

Apache License 2.0 - See [LICENSE](LICENSE) file for details

## Contributing

Pull requests and issue reports are welcome.

## References

### Official Documentation
- [Pandoc User's Guide](https://pandoc.org/MANUAL.html) - Pandoc official manual
- [Pandoc Lua Filters](https://pandoc.org/lua-filters.html) - Lua filter creation guide
- [EPUB 3.3 Specification](https://www.w3.org/TR/epub-33/) - EPUB specification
- [GitHub Actions Documentation](https://docs.github.com/en/actions) - GitHub Actions official documentation

### Technical Resources
- [Markdown Guide](https://www.markdownguide.org/) - Markdown syntax guide
- [textlint](https://textlint.github.io/) - Text linting tool
- [Mermaid](https://mermaid.js.org/) - Diagram creation tool
- [LaTeX Japanese Typesetting](https://texwiki.texjp.org/) - LaTeX Japanese typesetting

### Related Tools
- [EPUBCheck](https://github.com/w3c/epubcheck) - EPUB validation tool
- [Calibre](https://calibre-ebook.com/) - E-book management tool
- [Sigil](https://sigil-ebook.com/) - EPUB editor