# makefile
.PHONY: help pretty
.DEFAULT_GOAL := help

pretty:
	find . \( -type f -or -type l \) -name '*.fish' -exec fish_indent -w {} \;

help:
	@echo "help"
	@echo "    shows this message"
	@echo ""
	@echo "pretty"
	@echo "    Run fish_indent against all fish files. "
