# Pandoc Book Starter Makefile

# Variables
PANDOC = pandoc
BUILD_DIR = build
SHARED_DIR = shared


# Common options
# +fenced_divs: :::tip等のカスタムブロック
# +bracketed_spans: [text]{.class}形式のインラインスタイル
EPUB_OPTS = --to=epub3 \
  -f markdown+grid_tables+multiline_tables+fenced_divs+bracketed_spans \
	--standalone \
	--toc \
	--toc-depth=3 \
	--css=../$(SHARED_DIR)/assets/epub.css \
	--lua-filter=../$(SHARED_DIR)/filters/number-chapter.lua \
	--lua-filter=../$(SHARED_DIR)/filters/autoid.lua \
	--lua-filter=../$(SHARED_DIR)/filters/mermaid.lua \
	--epub-embed-font ../$(SHARED_DIR)/assets/fonts/FiraCode-Regular.ttf


PDF_OPTS = --to=pdf \
	--metadata lang=ja \
	--lua-filter=../$(SHARED_DIR)/filters/number-chapter.lua \
	--lua-filter=../$(SHARED_DIR)/filters/autoid.lua \
	--lua-filter=../$(SHARED_DIR)/filters/mermaid.lua \
	--pdf-engine=lualatex \
	--top-level-division=chapter \
	--template=meta/template/custom-template.tex \
	--toc \
	--toc-depth=3

# Help target
help:
	@echo "Available targets:"
	@echo "  epub     - Build Japanese EPUB version"
	@echo "  epub-en     - Build English EPUB version"
	@echo "  epub-all    - Build all EPUB versions"
	@echo "  pdf       - Build Japanese PDF version"
	@echo "  pdf-en       - Build English PDF version"
	@echo "  pdf-all      - Build all PDF versions"
	@echo "  clean        - Clean build directory"
	@echo "  help         - Show this help"

#  syntax highlight styles
# --highlight-style=monochrome 
# --highlight-style=pygments
# --highlight-style=tango
# --highlight-style=espresso
# --highlight-style=zenburn
# --highlight-style=autumn
# --highlight-style=breezedark
# --highlight-style=github
# --highlight-style=solarized-dark
# --highlight-style=solarized-light

# Build targets
epub:
	@echo "Building Japanese version..."
	mkdir -p $(BUILD_DIR)/vol1/ja
	cd vol1 && $(PANDOC) \
		--to=epub3 \
		-f markdown+grid_tables+multiline_tables \
		--standalone \
		--toc \
		--toc-depth=3 \
		--css=../$(SHARED_DIR)/assets/epub.css \
		--lua-filter=../$(SHARED_DIR)/filters/number-chapter.lua \
		--lua-filter=../$(SHARED_DIR)/filters/autoid.lua \
		--lua-filter=../$(SHARED_DIR)/filters/mermaid.lua \
		--epub-embed-font ../$(SHARED_DIR)/assets/fonts/FiraCode-Regular.ttf \
		-o ../$(BUILD_DIR)/vol1/ja/book.epub \
		src/ja/*.md \
		--metadata-file=meta/ja.yaml 
	@echo "Cleaning up temporary mermaid files..."
	cd vol1 && rm -f mermaid-*.png

epub-en:
	@echo "Building English version..."
	mkdir -p $(BUILD_DIR)/vol1/en
	cd vol1 && $(PANDOC) \
		--to=epub3 \
		--toc \
		--toc-depth=3 \
		--css=../$(SHARED_DIR)/assets/epub.css \
		--lua-filter=../$(SHARED_DIR)/filters/number-chapter.lua \
		--lua-filter=../$(SHARED_DIR)/filters/autoid.lua \
		--lua-filter=../$(SHARED_DIR)/filters/mermaid.lua \
		--epub-embed-font ../$(SHARED_DIR)/assets/fonts/FiraCode-Regular.ttf \
		-o ../$(BUILD_DIR)/vol1/en/book.epub \
		src/en/*.md \
		--metadata-file=meta/en.yaml
	@echo "Cleaning up temporary mermaid files..."
	cd vol1 && rm -f mermaid-*.png

# PDF build targets
pdf:
	@echo "Building Japanese PDF version..."
	mkdir -p $(BUILD_DIR)/vol1/ja
	cd vol1 && $(PANDOC) \
		-f markdown+fenced_divs \
		--to=pdf \
		--metadata lang=ja \
		--lua-filter=../$(SHARED_DIR)/filters/number-chapter.lua \
		--lua-filter=../$(SHARED_DIR)/filters/autoid.lua \
		--lua-filter=../$(SHARED_DIR)/filters/mermaid.lua \
		--lua-filter=../$(SHARED_DIR)/filters/custom-divs.lua \
		--pdf-engine=lualatex \
		--top-level-division=chapter \
		--template=meta/template/custom-template.tex \
		--toc \
		--toc-depth=3 \
		-o ../$(BUILD_DIR)/vol1/ja/book.pdf \
		src/ja/*.md \
		meta/ja.yaml 
	@echo "Cleaning up temporary mermaid files..."
	cd vol1 && rm -f mermaid-*.png

pdf-en:
	@echo "Building English PDF version..."
	mkdir -p $(BUILD_DIR)/vol1/en
	cd vol1 && $(PANDOC) \
		--to=pdf \
		--metadata lang=en \
		--lua-filter=../$(SHARED_DIR)/filters/number-chapter.lua \
		--lua-filter=../$(SHARED_DIR)/filters/autoid.lua \
		--lua-filter=../$(SHARED_DIR)/filters/mermaid.lua \
		--pdf-engine=lualatex \
		--top-level-division=chapter \
		--template=meta/template/custom-template.tex \
		--toc \
		--toc-depth=3 \
		-o ../$(BUILD_DIR)/vol1/en/book.pdf \
		src/en/*.md \
		meta/en.yaml 
	@echo "Cleaning up temporary mermaid files..."
	cd vol1 && rm -f mermaid-*.png

pdf-all: pdf pdf-en

epub-all: epub epub-en

all: epub-all pdf-all

build-all: all

# Clean target
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all help build-ja build-en build-all pdf-ja pdf-en pdf-all clean
