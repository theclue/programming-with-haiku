.PHONY: all book clean markdown mobi epub html pdf png

BUILD = build
MAKEFILE = Makefile
OUTPUT_FILENAME = Jon_Yoder_-_Programming_with_Haiku_Volume_2

INCLUDE_DIR = ../include
IMAGES_DIR = images
IMAGES = $(IMAGES_DIR)/*
COVER_IMAGE = $(IMAGES_DIR)/cover.png

METADATA = metadata.yml
TOC = --toc --toc-depth=2 -V toc-title='Table of contents' -V toc-own-page:true
CSS_FILE = $(INCLUDE_DIR)/css/style.css
CSS_ARG = --css=$(CSS_FILE)
METADATA_ARG = --metadata-file=$(METADATA)
MATH_FORMULAS = --webtex

PDF_ENGINE=xelatex
ARGS = $(MATH_FORMULAS) $(CSS_ARG) $(METADATA_ARG)

MARKDOWN_FORMAT = markdown-pipe_tables+backtick_code_blocks+fancy_lists+table_captions+smart+fenced_divs

CHAPTERS_DIR = ./chapters
CHAPTERS := disclaimer.Md lesson01.Md

CHAPTERS_TARGETS = $(addprefix $(CHAPTERS_DIR)/,$(CHAPTERS))

all: book

book: epub html pdf mobi

clean:
	rm -rf $(BUILD)

markdown: $(BUILD)/markdown/$(OUTPUT_FILENAME).Md

mobi: $(BUILD)/mobi/$(OUTPUT_FILENAME).mobi

epub: $(BUILD)/epub/$(OUTPUT_FILENAME).epub

html: $(BUILD)/html/$(OUTPUT_FILENAME).html.tar.gz

pdf: $(BUILD)/pdf/$(OUTPUT_FILENAME).pdf

png: pdf
	mkdir -p $(BUILD)/png
	pdftoppm -png -r 42 -aa yes $(BUILD)/pdf/$(OUTPUT_FILENAME).pdf $(BUILD)/png/$(OUTPUT_FILENAME)

$(BUILD)/markdown/$(OUTPUT_FILENAME).Md: $(CHAPTERS_TARGETS)
	mkdir -p $(BUILD)/markdown
	mdmerge $(CHAPTERS_TARGETS) -o $(BUILD)/markdown/$(OUTPUT_FILENAME).Md

$(BUILD)/mobi/$(OUTPUT_FILENAME).mobi: epub
	mkdir -p $(BUILD)/mobi
	ebook-convert $(BUILD)/epub/$(OUTPUT_FILENAME).epub $(BUILD)/mobi/$(OUTPUT_FILENAME).mobi

$(BUILD)/epub/$(OUTPUT_FILENAME).epub: $(MAKEFILE) $(METADATA) $(CHAPTERS_TARGETS) $(CSS_FILE) $(IMAGES) \
																			 $(COVER_IMAGE)
	mkdir -p $(BUILD)/epub
	pandoc $(ARGS) --epub-cover-image=$(COVER_IMAGE) -f $(MARKDOWN_FORMAT) -t epub -o $@ -s $(CHAPTERS_TARGETS)

$(BUILD)/html/$(OUTPUT_FILENAME).html.tar.gz : $(MAKEFILE) $(METADATA) $(CHAPTERS_TARGETS) $(CSS_FILE) $(IMAGES)
	mkdir -p $(BUILD)/html_tmp
	mkdir -p $(BUILD)/html
	pandoc $(ARGS) --standalone --to=html5 -o $(BUILD)/html_tmp/$(OUTPUT_FILENAME).html $(CHAPTERS_TARGETS)
	cp -R $(IMAGES_DIR)/ $(BUILD)/html_tmp/$(IMAGES_DIR)/
	tar -zcvf $(BUILD)/html/$(OUTPUT_FILENAME).html.tar.gz -C $(BUILD)/html_tmp .
	rm -r $(BUILD)/html_tmp

$(BUILD)/pdf/$(OUTPUT_FILENAME).pdf: $(MAKEFILE) $(METADATA) $(CHAPTERS_TARGETS) $(CSS_FILE) \
	$(INCLUDE_DIR)/pandoc/eisvogel.latex \
	$(INCLUDE_DIR)/latex/preamble.tex \
	$(INCLUDE_DIR)/latex/before_body.tex \
	$(INCLUDE_DIR)/latex/after_body.tex
	mkdir -p $(BUILD)/markdown
	mkdir -p $(BUILD)/pdf
	pandoc $(ARGS) \
			$(TOC) \
			--template=$(INCLUDE_DIR)/pandoc/eisvogel.latex \
			--metadata=abstract:" " \
			-V geometry:a4paper -V geometry:"left=2.54cm,right=2.54cm,top=1.91cm,bottom=1.91cm" \
			-V titlepage:true -V titlepage-color:"FFFFFF" -V titlepage-rule-height:0 -V titlepage-rule-color:"d8dbdc" \
			-V titlepage-background:$(COVER_IMAGE) \
			-V title:"" -V subtitle:"" -V author:"" \
			-V header-left:"Programming with Haiku" -V header-right:"Volume 2" \
			-V footer-left:"Jon Yoder" \
			-V links-as-notes:true \
			-V lot:true \
			-V footnotes-pretty:true \
			--listing -V listings-disable-line-numbers:true \
			-V book:true --top-level-division=chapter \
			--pdf-engine=$(PDF_ENGINE) \
			--include-in-header $(INCLUDE_DIR)/latex/preamble.tex \
			--include-before-body $(INCLUDE_DIR)/latex/before_body.tex \
			--include-after-body $(INCLUDE_DIR)/latex/after_body.tex \
			--filter pandoc-latex-environment \
			--number-offset=1 \
			-f $(MARKDOWN_FORMAT) \
			-s $(CHAPTERS_TARGETS) \
			-o $@

%.xml : %.adoc
	asciidoctor -v -d book -b docbook -s $< -o $@

$(CHAPTERS_DIR)/%.Md : %.xml
	mkdir -p $(CHAPTERS_DIR)
	pandoc --highlight-style=pygments --wrap=none -f docbook -t $(MARKDOWN_FORMAT) --shift-heading-level-by=1 $< -o $@
