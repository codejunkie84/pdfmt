# pdfmt - The PDF Multi-Tool

<p align="center">
    <a href="https://github.com/eifelcode/pdfmt/actions/workflows/snapshot.yaml"><img src="https://github.com/eifelcode/pdfmt/actions/workflows/snapshot.yaml/badge.svg" alt="Tests"></a>
    <a href="https://github.com/eifelcode/pdfmt/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="MIT Software License"></a>
</p>

**pdfmt** is a command-line toolkit for the PDF tasks you keep doing again and again.

Merge PDFs. Split them. Extract pages. Reorder documents. Scan from your scanner. Add stamps. And when a task becomes repetitive, turn it into a reusable workflow.

No GUI required. No cloud upload required. Just your PDFs, your terminal, and the tools you already use.

> **MT stands for Multi-Tool.**
> pdfmt brings many small PDF operations together behind one consistent command-line interface.

A project from [eifelcode.com](https://www.eifelcode.com).

---

## Why pdfmt?

Working with PDFs often means reaching for a different tool for every little task:

* "I only need pages 2, 4 and 6."
* "I need to split this 100-page PDF."
* "I scanned the front and back separately. Now I need to put them back together."
* "I need to merge these five documents."
* "I need to add a processed stamp."
* "I have to do this every week."

`pdfmt` is designed for exactly these situations.

Instead of remembering a collection of different commands and tools, you can use one interface:

```bash
pdfmt <command> <subcommand> [arguments]
```

And because `pdfmt` is a command-line tool, it works just as well interactively as it does in scripts and automated workflows.

---

## Get started

Once `pdfmt` is installed, you can immediately start working with your PDFs.

### Merge documents

```bash
pdfmt merge all cover.pdf report.pdf appendix.pdf complete.pdf
```

### Split a PDF into individual pages

```bash
pdfmt split all document.pdf page_
```

This creates:

```text
page_1.pdf
page_2.pdf
page_3.pdf
...
```

### Extract pages

```bash
pdfmt extract range document.pdf 1-3,7,10-12 extracted.pdf
```

### Remove pages

```bash
pdfmt remove range document.pdf 5,8-10 cleaned.pdf
```

### Reorder pages

```bash
pdfmt sort reverse document.pdf reversed.pdf
```

### Add a stamp

```bash
pdfmt stamp text invoice.pdf "Paid on 2026-08-28" invoice-paid.pdf
```

And when you need something more complex, combine these commands into a workflow.

---

## Real-world examples

`pdfmt` is particularly useful when several simple PDF operations need to be combined.

### Scan a stack of single-page documents

You have a stack of invoices or delivery notes. Your scanner can scan the entire stack, but each document should become its own PDF.

```bash
pdfmt scan adf invoices.pdf
pdfmt split all invoices.pdf invoice_
```

You now have:

```text
invoice_1.pdf
invoice_2.pdf
invoice_3.pdf
...
```

No need to scan every document individually.

---

### Scan double-sided documents without a duplex scanner

Your scanner has an ADF, but it cannot scan both sides automatically.

Scan the front sides:

```bash
pdfmt scan adf front.pdf
```

Turn the stack over and scan the back sides:

```bash
pdfmt scan adf back.pdf
```

Then reconstruct the correct page order:

```bash
pdfmt merge duplex front.pdf back.pdf documents.pdf
```

If every physical document consists of two pages, split the result into individual documents:

```bash
pdfmt split length documents.pdf 2 document_
```

You end up with:

```text
document_1.pdf
document_2.pdf
document_3.pdf
...
```

---

### Split documents with different page counts

Sometimes a scanned PDF contains several documents with different lengths.

For example, if the first document consists of pages 1–4 and 6, the second of pages 7–10, and the third of pages 11–12:

```bash
pdfmt split range documents.pdf 1-4,6 7-10 11-12 document_
```

The result is:

```text
document_1.pdf
document_2.pdf
document_3.pdf
```

Each output can contain a completely different page range.

---

### Reuse a cover page

You can also include the same page in several output documents:

```bash
pdfmt split range document.pdf 1-7 1,8-10 1,11-14 split_doc_
```

Here, page 1 becomes part of every resulting PDF.

---

### Mark an invoice as processed

You received an invoice as a PDF and want to mark it as processed:

```bash
pdfmt stamp text invoice.pdf "Paid on 2026-08-28" invoice-paid.pdf
```

The result is a new PDF with the stamp applied.

---

## Workflows

Sometimes one command isn't enough.

A **workflow** lets you turn several `pdfmt` commands into one reusable command.

For example, scanning both sides of a document with a scanner that does not support hardware duplex scanning normally requires several steps:

1. Scan the front.
2. Turn the paper stack around.
3. Scan the back.
4. Put the pages back into the correct order.
5. Clean up temporary files.

With a workflow, all of that can become:

```bash
pdfmt workflow run scan-duplex adf output.pdf
```

A workflow is simply an executable shell script:

```bash
#!/usr/bin/env bash
# Scan both sides of a document and merge them into a single PDF.

pdfmt scan "$1" front.pdf
read -r -p "Turn the paper stack and press ENTER to continue..."
pdfmt scan "$1" back.pdf
pdfmt merge duplex front.pdf back.pdf "$2"
rm front.pdf back.pdf
```

This is intentionally simple. Workflows are just shell scripts, so you can combine `pdfmt` with other command-line tools as well.

### List available workflows

```bash
pdfmt workflow list
```

### Inspect a workflow

```bash
pdfmt workflow info scan-duplex
```

### Create your own workflow

Place an executable script in one of your configured workflow directories:

```text
~/.local/share/pdfmt/workflows/
└── my-workflow
```

The third line is used as the workflow description:

```bash
#!/usr/bin/env bash
# =============================...
# My custom PDF workflow.
#
# ...
```

Then run it like any other `pdfmt` command:

```bash
pdfmt workflow run my-workflow ...
```

This makes workflows useful for anything you find yourself doing repeatedly.

---

### Pre-defined workflows

If you don't want to write workflows from scratch, check out the official [pdfmt-workflows](https://github.com/eifelcode/pdfmt-workflows) repository for ready-to-use community scripts.

To install a pre-defined workflow, download the script into your local workflows directory and make it executable:

```bash
WORKFLOW_NAME=scan-duplex  #< Name of the workflow to install

# Download and install workflow
curl -sSL https://raw.githubusercontent.com/eifelcode/pdfmt-workflows/main/workflows/$WORKFLOW_NAME -o ~/.local/share/pdfmt/workflows/$WORKFLOW_NAME
chmod +x ~/.local/share/pdfmt/workflows/$WORKFLOW_NAME
```

---

## What can pdfmt do?

`pdfmt` currently provides commands for:

| Task               | Examples                                                         |
|--------------------|------------------------------------------------------------------|
| **Extract pages**  | Extract even pages, odd pages, or arbitrary ranges               |
| **Merge PDFs**     | Merge documents, interleave duplex scans, insert documents       |
| **OCR PDFs**       | Execute OCR operations on PDF files                              |
| **Remove pages**   | Remove even pages, odd pages, or arbitrary ranges                |
| **Scan documents** | Scan using an ADF or flatbed scanner                             |
| **Sort pages**     | Reverse, shuffle, swap, move and handle duplex page orders       |
| **Split PDFs**     | Split into individual pages, fixed-size chunks, or custom ranges |
| **Stamp PDFs**     | Add custom text stamps                                           |
| **Automate tasks** | Create reusable shell-based workflows                            |

For detailed command usage, run:

```bash
pdfmt <command> help
```

For example:

```bash
pdfmt split help
pdfmt merge help
pdfmt scan help
pdfmt workflow help
```

---

### Command Overview

Below is a quick overview of all available commands. To get detailed usage instructions for a specific command, simply run `pdfmt <command> help`.

| Category     | Command         | Description                                                        |
|:-------------|:----------------|:-------------------------------------------------------------------|
| **Extract**  | `extract even`  | Extract all even-numbered pages                                    |
|              | `extract help`  | Help of category *Extract*                                         |
|              | `extract odd`   | Extract all odd-numbered pages                                     |
|              | `extract range` | Extract a specific range of pages (e.g., 1-5) into a new PDF       |
| **Merge**    | `merge all`     | Combine PDFs into a single document                                |
|              | `merge duplex`  | Interleave two PDFs (front/back scans) into one duplex document    |
|              | `merge help`    | Help of category *Merge*                                           |
|              | `merge insert`  | Insert a PDF into another document at a specific page              |
| **OCR**      | `ocr add`       | Add an OCR text layer to a PDF document                            |
|              | `ocr exists`    | Check if a PDF document contains an OCR/text layer                 |
|              | `ocr help`      | Help of category *Ocr*                                             |
|              | `ocr show`      | Display the extracted OCR text layer of a PDF document             |
| **Remove**   | `remove even`   | Remove all even-numbered pages                                     |
|              | `remove help`   | Help of category *Remove*                                          |
|              | `remove odd`    | Remove all odd-numbered pages                                      |
|              | `remove range`  | Remove a specific range of pages (e.g., 1-5)                       |
| **Scan**     | `scan adf`      | Scan documents from ADF (automatic document feeder) into a new PDF |
|              | `scan flatbed`  | Scan documents from flatbed scanner into a new PDF                 |
|              | `scan help`     | Help of category *Scan*                                            |
| **Sort**     | `sort duplex`   | Reorder a single PDF containing consecutive front and back scans   |
|              | `sort help`     | Help of category *Sort*                                            |
|              | `sort move`     | Move specific pages to a new position within the PDF               |
|              | `sort random`   | Shuffle the pages of a PDF into a random order                     |
|              | `sort reverse`  | Reverse the page order of a PDF                                    |
|              | `sort swap`     | Swap two specific pages within a PDF                               |
| **Split**    | `split all`     | Split a PDF into separate files, one for each page                 |
|              | `split help`    | Help of category *Split*                                           |
|              | `split length`  | Split a PDF into chunks of a fixed number of pages                 |
|              | `split range`   | Split a PDF into multiple files based on page ranges               |
| **Stamp**    | `stamp help`    | Help of category *Stamp*                                           |
|              | `stamp text`    | Add a custom text stamp to a PDF                                   |
| **Workflow** | `workflow help` | Help of category *Workflow*                                        |
|              | `workflow info` | Shows information about a workflow                                 |
|              | `workflow list` | Lists all available workflow scripts                               |
|              | `workflow run`  | Runs a workflow script                                             |
| **Misc**     | `help`          | Help of `pdfmt`                                                    |
|              | `version`       | Displays the version of `pdfmt`                                    |

---

## Installation

### Requirements

`pdfmt` requires **Bash 4.3 or newer**.

The required runtime tools are:

| Program                                                       | Linux         | macOS           | Used for             |
|---------------------------------------------------------------|---------------|-----------------|----------------------|
| [Bash](https://www.gnu.org/software/bash/) >= 4.3             | `bash`        | `bash`          | Running `pdfmt`      |
| [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) | `pdftk`       | `pdftk-java`    | PDF manipulation     |
| [ImageMagick](https://imagemagick.org/)                       | `imagemagick` | `imagemagick`   | Image/PDF operations |
| [SANE](https://sane-project.org/)                             | `sane-utils`  | `sane-backends` | Scanning             |
| [OCRmyPDF](https://github.com/ocrmypdf/OCRmyPDF)              | `ocrmypdf`    | `ocrmypdf`      | OCR operations       |

Not every command requires every dependency. For example, SANE is only needed for the `scan` command and OCRmyPDF is only needed for `ocr add`.

#### Linux

On Debian/Ubuntu:

```bash
sudo apt install bash pdftk imagemagick sane-utils
```

Other Linux distributions may use different package names.

#### macOS

Using Homebrew:

```bash
brew install bash pdftk-java imagemagick sane-backends
```

macOS ships with Bash 3.2, which is too old for `pdfmt`. Make sure a newer Bash version is available.

---

### Install pre-built binary from GitHub

Download the latest release binary directly via terminal:

```bash
# Download the latest binary
curl -sSL https://github.com/eifelcode/pdfmt/releases/latest/download/pdfmt -o pdfmt

# Make it executable
chmod +x pdfmt

# Move it to your PATH (e.g., /usr/local/bin or ~/.local/bin)
sudo mv pdfmt /usr/local/bin/
```
Alternatively, visit the [Releases Page](https://github.com/eifelcode/pdfmt/releases) to manually download the `pdfmt` file for a specific version.

### Install from source

Clone the repository and use the included Makefile to build and install `pdfmt` into `/usr/local/bin`:

```bash
make
make install
```

---

## Configuration

`pdfmt` creates configuration files when they are needed. This means you can start using commands without having to configure everything beforehand.

Configuration files are stored below:

```text
~/.config/pdfmt/
```

### Scanner configuration

The `scan` command uses:

```text
~/.config/pdfmt/scan.conf
```

The configuration includes:

| Setting               | Default   | Description       |
| --------------------- | --------- | ----------------- |
| `scan.device`         | -         | Scanner device    |
| `scan.source.adf`     | `ADF`     | ADF source        |
| `scan.source.flatbed` | `Flatbed` | Flatbed source    |
| `scan.resolution`     | `300`     | Resolution in DPI |
| `scan.mode`           | `Color`   | Scan mode         |
| `scan.paper.format`   | `A4`      | Paper format      |

The scanner device can be identified with:

```bash
scanimage -f "%d" | head -n 1
```

### Stamp configuration

The `stamp text` command uses:

```text
~/.config/pdfmt/stamp_text.conf
```

Available settings include:

| Setting                 | Default   | Description |
| ----------------------- | --------- | ----------- |
| `stamp.text.font.file`  | -         | Font file   |
| `stamp.text.font.size`  | `22`      | Font size   |
| `stamp.text.font.color` | `#DC143C` | Stamp color |

### Workflow configuration

The `workflow` command uses:

```text
~/.config/pdfmt/workflow.conf
```

Available settings include:

| Setting          | Default                          | Description                                                                 |
|------------------|----------------------------------|-----------------------------------------------------------------------------|
| `workflow.paths` | `~/.local/share/pdfmt/workflows` | List of directories separated by : where your workflow scripts are located  |

### OCR configuration

The `ocr` command uses:

```text
~/.config/pdfmt/ocr.conf
```

Available settings include:

| Setting        | Default | Description                                                             |
|----------------|---------|-------------------------------------------------------------------------|
| `ocr.language` | `eng`   | Language codes used for OCR text recognition.                           |
| `ocr.plugin`   | ` `     | The OCRmyPDF engine plugin to be used. If empty Tesseract will be used. |

**Note:** If a configured plugin like `ocrmypdf_rapidocr` is not installed on the system, `pdfmt ocr add` will exit with a clear error message rather than creating faulty PDFs.

#### Recommendation for OCR: RapidOCR or EasyOCR

`pdfmt` uses OCRmyPDF for text recognition, which also supports plugins. For optimal performance and accuracy (especially on CPUs and Intel Macs), the RapidOCR plugin is recommended. If you need maximum recognition quality on complex layouts and have a powerful GPU and RAM available, take a look at EasyOCR.

After installing your preferred plugin, you can enable it by updating the configuration file:

```bash
# Enable RapidOCR:
ocr.plugin=ocrmypdf_rapidocr
```

**Note:** If you get errors like `ValueError: Unsupported rec.lang_type='latin' for PP-OCRv6 small model.` ensure the correct model for RapidOCR is installed.

---

## A command-line tool that stays out of your way

`pdfmt` is designed around a simple idea:

> **Small PDF operations should be easy to combine.**

Use one command when one command is enough.

Use several commands when you need to process a document.

And when you find yourself typing the same sequence again and again, turn it into a workflow.

Because `pdfmt` is a command-line tool, it can also be used from shell scripts, cron jobs, automation and other command-line workflows.

---

## Development

`pdfmt` is an open-source project built with Bash.

The project is organized into small, isolated commands under `sources/command/`.

Tests use **bashunit** and shell scripts are checked with **ShellCheck**.

The required runtime tools for development are:

| Program                                     | Linux           | macOS        | Used for                   |
|---------------------------------------------|-----------------|--------------|----------------------------|
| [make](https://www.gnu.org/software/make/)  | `make`          | `make`       | Build and test automation  |
| [shellcheck](https://www.shellcheck.net/)   | `shellcheck`    | `shellcheck` | Shell script linting       |
| [bashunit](https://bashunit.com/)           | `bashunit`      | `bashunit`   | Unit and integration tests |
| [Poppler](https://poppler.freedesktop.org/) | `poppler-utils` | `poppler`    | Verifying PDF test results |


Run the complete test suite with:

```bash
make test
```

To contribute to `pdfmt`, see:

* [`CONTRIBUTE.md`](.github/CONTRIBUTE.md)
* [`PULL_REQUEST_TEMPLATE.md`](.github/PULL_REQUEST_TEMPLATE.md)
* [`RELEASE.md`](.github/RELEASE.md)

Bug reports, feature requests and contributions are welcome.

---

## License

`pdfmt` is licensed under the **MIT License**. See `LICENSE` for details.
