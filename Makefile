# Pandoc Book Starter Makefile

# Variables
PANDOC = pandoc
BUILD_DIR = build
SHARED_DIR = shared

# Common options
EPUB_OPTS = --to=epub3 \
	--toc \
	--toc-depth=3 \
	--css=../$(SHARED_DIR)/assets/epub.css \
	--lua-filter=../$(SHARED_DIR)/filters/number-chapter.lua \
	--lua-filter=../$(SHARED_DIR)/filters/autoid.lua \
	--lua-filter=../$(SHARED_DIR)/filters/mermaid.lua \
	--epub-embed-font ../$(SHARED_DIR)/assets/fonts/FiraCode-Regular.ttf

PDF_OPTS = --to=pdf \
	--pdf-engine=xelatex \
	--toc \
	--toc-depth=3 \
	--lua-filter=../$(SHARED_DIR)/filters/number-chapter.lua \
	--lua-filter=../$(SHARED_DIR)/filters/autoid.lua \
	--lua-filter=../$(SHARED_DIR)/filters/mermaid.lua


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

# Build targets
epub:
	@echo "Building Japanese version..."
	mkdir -p $(BUILD_DIR)/vol1/ja
	cd vol1 && $(PANDOC) $(EPUB_OPTS) \
		--metadata-file=meta/ja.yaml \
		-o ../$(BUILD_DIR)/vol1/ja/book.epub \
		src/ja/*.md \
		meta/ja_title.txt
	@echo "Cleaning up temporary mermaid files..."
	cd vol1 && rm -f mermaid-*.png

epub-en:
	@echo "Building English version..."
	mkdir -p $(BUILD_DIR)/vol1/en
	cd vol1 && $(PANDOC) $(EPUB_OPTS) \
		--metadata-file=meta/en.yaml \
		-o ../$(BUILD_DIR)/vol1/en/book.epub \
		src/en/*.md \
		meta/en_title.txt
	@echo "Cleaning up temporary mermaid files..."
	cd vol1 && rm -f mermaid-*.png

# PDF build targets
pdf:
	@echo "Building Japanese PDF version..."
	mkdir -p $(BUILD_DIR)/vol1/ja
	cd vol1 && $(PANDOC) $(PDF_OPTS) \
		--metadata lang=ja \
		--metadata-file=meta/ja.yaml \
		-o ../$(BUILD_DIR)/vol1/ja/book.pdf \
		src/ja/*.md \
		meta/ja_title.txt
	@echo "Cleaning up temporary mermaid files..."
	cd vol1 && rm -f mermaid-*.png

pdf-en:
	@echo "Building English PDF version..."
	mkdir -p $(BUILD_DIR)/vol1/en
	cd vol1 && $(PANDOC) $(PDF_OPTS) \
		--metadata lang=en \
		--metadata-file=meta/en.yaml \
		-o ../$(BUILD_DIR)/vol1/en/book.pdf \
		src/en/*.md \
		meta/en_title.txt
	@echo "Cleaning up temporary mermaid files..."
	cd vol1 && rm -f mermaid-*.png

pdf-all: pdf pdf-en

epub-all: epub epub-en

# Clean target
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all help build-ja build-en build-all pdf-ja pdf-en pdf-all clean
