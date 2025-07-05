# Pandoc Book Starter Makefile

# Variables
PANDOC = pandoc
BUILD_DIR = build
SHARED_DIR = shared

# Default target
all: help

# Help target
help:
	@echo "Available targets:"
	@echo "  build-ja     - Build Japanese EPUB version"
	@echo "  build-en     - Build English EPUB version"
	@echo "  build-all    - Build all EPUB versions"
	@echo "  pdf-ja       - Build Japanese PDF version"
	@echo "  pdf-en       - Build English PDF version"
	@echo "  pdf-all      - Build all PDF versions"
	@echo "  clean        - Clean build directory"
	@echo "  help         - Show this help"

# Build targets
build-ja:
	@echo "Building Japanese version..."
	mkdir -p $(BUILD_DIR)/vol1/ja
	cd vol1 && $(PANDOC) --metadata-file=meta/ja.yaml \
		--css=../$(SHARED_DIR)/assets/epub.css \
		--lua-filter=../$(SHARED_DIR)/filters/autoid.lua \
		--lua-filter=../$(SHARED_DIR)/filters/mermaid.lua \
		-o ../$(BUILD_DIR)/vol1/ja/book.epub \
		src/ja/*.md
	@echo "Cleaning up temporary mermaid files..."
	cd vol1 && rm -f mermaid-*.png

build-en:
	@echo "Building English version..."
	mkdir -p $(BUILD_DIR)/vol1/en
	cd vol1 && $(PANDOC) --metadata-file=meta/en.yaml \
		--css=../$(SHARED_DIR)/assets/epub.css \
		--lua-filter=../$(SHARED_DIR)/filters/autoid.lua \
		--lua-filter=../$(SHARED_DIR)/filters/mermaid.lua \
		-o ../$(BUILD_DIR)/vol1/en/book.epub \
		src/en/*.md
	@echo "Cleaning up temporary mermaid files..."
	cd vol1 && rm -f mermaid-*.png

# PDF build targets
pdf-ja:
	@echo "Building Japanese PDF version..."
	mkdir -p $(BUILD_DIR)/vol1/ja
	cd vol1 && $(PANDOC) --metadata-file=meta/ja.yaml \
		--lua-filter=../$(SHARED_DIR)/filters/autoid.lua \
		--lua-filter=../$(SHARED_DIR)/filters/mermaid.lua \
		--pdf-engine=xelatex \
		--toc \
		--toc-depth=3 \
		--number-sections \
		-o ../$(BUILD_DIR)/vol1/ja/book.pdf \
		src/ja/*.md
	@echo "Cleaning up temporary mermaid files..."
	cd vol1 && rm -f mermaid-*.png

pdf-en:
	@echo "Building English PDF version..."
	mkdir -p $(BUILD_DIR)/vol1/en
	cd vol1 && $(PANDOC) --metadata-file=meta/en.yaml \
		--lua-filter=../$(SHARED_DIR)/filters/autoid.lua \
		--lua-filter=../$(SHARED_DIR)/filters/mermaid.lua \
		--pdf-engine=xelatex \
		--toc \
		--toc-depth=3 \
		--number-sections \
		-o ../$(BUILD_DIR)/vol1/en/book.pdf \
		src/en/*.md
	@echo "Cleaning up temporary mermaid files..."
	cd vol1 && rm -f mermaid-*.png

pdf-all: pdf-ja pdf-en

build-all: build-ja build-en pdf-ja pdf-en

# Clean target
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all help build-ja build-en build-all pdf-ja pdf-en pdf-all clean
