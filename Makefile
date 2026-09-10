
# CONFIGURATION
# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
VERSION_FILE = VERSION
VERSION ?= $(shell cat $(VERSION_FILE) 2>/dev/null || echo "0.0.0-unknown")

SOURCE_DIR = sources
TEST_DIR = tests
DIST_DIR = dist
APP_NAME = pdfmt
TARGET = $(DIST_DIR)/$(APP_NAME)
TARGET_TARGZ = $(DIST_DIR)/$(APP_NAME)-$(VERSION).tar.gz
PREFIX ?= /usr/local
BIN_DIR = $(PREFIX)/bin

# SPECIAL BUILT-IN TARGETS
# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
.PHONY: all help build lint test clean install uninstall
.SILENT: 	help build lint test clean install uninstall

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
all: build

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
help:
	echo "pdfmt - PDF Multi-Tool Build System"
	echo ""
	echo "Usage: make <target> [VARIABLE=value]"
	echo ""
	echo "Variables:"
	echo "  VERSION    Set the version string (default: 0.0.0)"
	echo "  PREFIX     Installation base directory (default: /usr/local)"
	echo ""
	echo "Targets:"
	echo "  help"
	echo "  build      Assemble the script into $(DIST_DIR)/"
	echo "  lint"
	echo "  clean"
	echo "  test"
	echo "  install    Install the script to $(PREFIX)/bin"
	echo "  uninstall  Remove the script from $(PREFIX)/bin"

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
build:
	echo "Building $(TARGET) version $(VERSION)..."

	mkdir -p "$(DIST_DIR)"
	echo "#!/usr/bin/env bash" > "$(TARGET)"
	echo "readonly VERSION=\"$(VERSION)\"" >> "$(TARGET)"
	# The files are sorted alphabetically; `main` is called last, so the order doesn't really matter.
	find "$(SOURCE_DIR)" -type f -name "*.sh" -print0 | sort -z | xargs -0 cat >> "$(TARGET)"
	# here comes the main call
	echo 'main "$$@"' >> "$(TARGET)"

	chmod +x "$(TARGET)"

	tar --owner=0 --group=0 -czf dist/pdfmt-$(VERSION).tar.gz -C dist pdfmt

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
lint:
	@if ! command -v shellcheck > /dev/null 2>&1; then \
		echo "ERROR: shellcheck is not installed."; \
		echo "To install shellcheck, run:"; \
		echo "  Debian/Ubuntu:  sudo apt install shellcheck"; \
		echo "  Fedora/RHEL:    sudo dnf install ShellCheck"; \
		echo "  macOS:          brew install shellcheck"; \
		exit 1; \
	fi
	find "$(SOURCE_DIR)" -type f -name "*.sh" -exec shellcheck -s bash {} \;
	find "$(TEST_DIR)"   -type f -name "*.sh" -exec shellcheck -s bash {} \;

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
test: lint build
	if [ ! -f lib/bashunit ]; then \
		echo "ERROR: bashunit not installed in lib/bashunit"; \
		echo "To install bashunit, run:"; \
		echo "  curl -s https://bashunit.com/install.sh | bash"; \
		exit 1; \
	fi
	lib/bashunit "$(TEST_DIR)"

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
clean:
	rm -rf "$(DIST_DIR)"

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
install: build
	sudo cp "$(TARGET)" "/usr/local/bin/$(APP_NAME)"

# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
uninstall:
	sudo rm -f "$(BIN_DIR)/$(APP_NAME)"
