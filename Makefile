# Pandoc Book Starter Makefile

PATH := $(HOME)/.asdf/installs/nodejs/22.14.0/bin:$(PATH)

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
	@echo "  html-ja      - Build Japanese HTML version"
	@echo "  html-en      - Build English HTML version"
	@echo "  html-all     - Build all HTML versions"
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
	cd vol1 && rm -f mermaid-*.svg

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
	cd vol1 && rm -f mermaid-*.svg

build-all: build-ja build-en

# HTML build targets
html-ja:
	@echo "Building Japanese HTML version..."
	mkdir -p $(BUILD_DIR)/vol1/ja
	cd vol1 && $(PANDOC) --metadata-file=meta/ja.yaml \
		--css=../$(SHARED_DIR)/assets/web.css \
		--lua-filter=../$(SHARED_DIR)/filters/autoid.lua \
		--lua-filter=../$(SHARED_DIR)/filters/mermaid.lua \
		--standalone \
		--toc \
		--toc-depth=3 \
		--number-sections \
		-o ../$(BUILD_DIR)/vol1/ja/book.html \
		src/ja/*.md

html-en:
	@echo "Building English HTML version..."
	mkdir -p $(BUILD_DIR)/vol1/en
	cd vol1 && $(PANDOC) --metadata-file=meta/en.yaml \
		--css=../$(SHARED_DIR)/assets/web.css \
		--lua-filter=../$(SHARED_DIR)/filters/autoid.lua \
		--lua-filter=../$(SHARED_DIR)/filters/mermaid.lua \
		--standalone \
		--toc \
		--toc-depth=3 \
		--number-sections \
		-o ../$(BUILD_DIR)/vol1/en/book.html \
		src/en/*.md

html-all: html-ja html-en

# Clean target
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all help build-ja build-en build-all html-ja html-en html-all clean
