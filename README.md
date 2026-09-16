<p align="center">
    <a href="https://github.com/eifelcode/pdfmt/actions/workflows/snapshot.yaml"><img src="https://github.com/eifelcode/pdfmt/actions/workflows/snapshot.yaml/badge.svg" alt="Tests"></a>
    <a href="https://github.com/eifelcode/pdfmt/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="MIT Software License"></a>
</p>
<br>

# pdfmt - PDF Multi-Tool for PDF manipulation

A project from [eifelcode.com](https://www.eifelcode.com)

`pdfmt` is a modular, Bash-based command-line utility designed for efficient PDF manipulation. It acts as a wrapper
around powerful tools like `pdftk` and `ImageMagick`, providing a consistent and easy-to-use interface for common
document tasks like splitting, merging, reordering, and scanning.

## Features

- **Split**: Break PDFs by page ranges, fixed lengths, or into individual files.
- **Merge**: Combine multiple documents, interleave front/back scans, or insert documents at specific positions.
- **Sort**: Reverse, swap, shuffle, or move pages; includes special handling for duplex scans.
- **Extract**: Easily pull specific pages or patterns (even/odd) into a new document.
- **Scan**: Direct integration with `scanimage` to digitize documents into PDFs via flatbed or ADF.
- **Stamp**: Add custom overlays (like dates, status marks) to your PDFs.

## Installation

### Requirements

`pdfmt` requires Bash 4.3 or newer.

#### Runtime dependencies

The following programs are required at runtime:

| Program                                                       | Linux         | macOS           | Used for             |
|---------------------------------------------------------------|---------------|-----------------|----------------------|
| [Bash](https://www.gnu.org/software/bash/) >= 4.3             | `bash`        | `bash`          | Running `pdfmt`      |
| [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) | `pdftk`       | `pdftk-java`    | PDF manipulation     |
| [ImageMagick](https://imagemagick.org/)                       | `imagemagick` | `imagemagick`   | Image/PDF operations |
| [SANE](https://sane-project.org/)                             | `sane-utils`  | `sane-backends` | Scanning             |

Not every command requires every dependency. For example, SANE is only required for the `scan` command.

##### Linux
```bash
# On Debian/Ubuntu:
sudo apt install bash pdftk imagemagick sane-utils
```

**Note:** Other Linux distributions may use different package names.

##### macOS
```bash
# Using Homebrew:
brew install bash pdftk-java imagemagick sane-backends
```
**Note:** macOS ships with Bash 3.2, which is too old for `pdfmt`. A newer Bash version is required.

#### Development and test dependencies

The following additional programs are required to build, lint and test `pdfmt`:

| Program                                     | Linux           | macOS        | Used for                   |
|---------------------------------------------|-----------------|--------------|----------------------------|
| [make](https://www.gnu.org/software/make/)  | `make`          | `make`       | Build and test automation  |
| [shellcheck](https://www.shellcheck.net/)   | `shellcheck`    | `shellcheck` | Shell script linting       |
| [bashunit](https://bashunit.com/)           | `bashunit`      | `bashunit`   | Unit and integration tests |
| [Poppler](https://poppler.freedesktop.org/) | `poppler-utils` | `poppler`    | Verifying PDF test results |

##### Linux
```bash
# On Debian/Ubuntu:
sudo apt install make shellcheck poppler-utils

# bashunit can be installed in project directory using:
curl -s https://bashunit.com/install.sh | bash
```

**Note:** Other Linux distributions may use different package names.

##### macOS
```bash
# Using Homebrew:
brew install make shellcheck poppler

# bashunit can be installed in project directory using:
curl -s https://bashunit.com/install.sh | bash
```


### Build and Install from source

Clone the repository and use the included Makefile:

```bash
# Build the application
make build

# Install to /usr/local/bin (sudo called within make install)
make install
```

### Install from GitHub
Download the latest release and place it into `/usr/local/bin`.


## Usage

`pdfmt` follows a simple `<command> <subcommand>` structure. To display all available commands just enter:

```bash
pdfmt
```

### Real-World Workflows / Cookbook

The following examples provide practical, everyday workflows where `pdfmt` shines. Many of these examples are designed
to save time during batch scanning, especially if your scanner's ADF (Automatic Document Feeder) does not support
hardware duplex scanning.

#### 1. Batch Scanning Single-Page Documents

**The Scenario:** You have a stack of 1-page documents (invoices, delivery notes, etc.). Scanning them one by one is
tedious. You want to scan them all at once and split them into individual files.

```bash
# 1. Scan the whole stack into a single PDF
pdfmt scan adf invoices.pdf

# 2. Split the PDF into individual pages
pdfmt split all invoices.pdf invoice_
```

**Result:** You get `invoice_1.pdf`, `invoice_2.pdf`, etc., which you can now easily rename and move to their final
directories.

#### 2. Batch Scanning 2-Sided Documents (Without a Duplex Scanner)

**The Scenario:** You have a stack of 2-sided documents (1 physical sheet, printed on both sides), but your scanner does
not have a duplex ADF.

```bash
# 1. Put the stack in the ADF and scan all front sides
pdfmt scan adf front.pdf

# 2. Flip the stack over, put it back in the ADF, and scan the back sides
pdfmt scan adf back.pdf

# 3. Interleave both files to reconstruct the correct page order
pdfmt merge duplex front.pdf back.pdf documents.pdf

# 4. Split the result into chunks of 2 pages
pdfmt split length 2 documents.pdf document_
```

**Result:** You get `document_1.pdf` (containing front and back of sheet 1), `document_2.pdf`, etc.

#### 3. Splitting Complex Duplex Scans & Dropping Blank Pages

**The Scenario:** Just like Example 2, you scan the front and back of a stack separately. However, this time the
documents have varying lengths, and one back page was completely blank and should be dropped (e.g., page 5).

```bash
# 1. Scan and interleave front and back sides
pdfmt scan adf front.pdf
pdfmt scan adf back.pdf
pdfmt merge duplex front.pdf back.pdf documents.pdf

# 2. Extract specific documents and ignore the blank page 5
pdfmt split range documents.pdf 1-4,6 7-10 11-12 document_
```

**Result:** Creates three files.

- `document_1.pdf` contains pages 1, 2, 3, 4, and 6 (skipping 5).
- `document_2.pdf` contains pages 7, 8, 9 and 10.
- `document_3.pdf` contains pages 11 and 12.

#### 4. Marking Digital Invoices as "Paid"

**The Scenario:** You receive an invoice via email as a PDF. Since you don't print it, you can't write on it. You want
to add a digital timestamp for your archive.

```bash
pdfmt stamp text invoice.pdf "Paid on 2026-08-28" invoice-paid.pdf
```

**Result:** A new PDF with a red stamp applied across the document, indicating when it was processed.

#### 5. Reusing a Cover Letter Across Multiple Documents

**The Scenario:** You receive a large PDF containing a general cover letter (page 1) followed by three different
documents. You want to split the documents apart, but the cover letter needs to be included at the beginning of *each*
new file.

```bash
pdfmt split range document.pdf 1-7 1,8-10 1,11-14 split_doc_
```

**Result:** Three files (`split_doc_1.pdf`, `split_doc_2.pdf`, `split_doc_3.pdf`). Page 1 of the original document is
injected as the first page in all of them.

#### 6. Merging a Multi-Part Report

**The Scenario:** You have separate PDF files for your report's cover, table of contents, and individual chapters, and
you need to combine them into one final deliverable.

```bash
pdfmt merge all cover.pdf toc.pdf chapter1.pdf chapter2.pdf final_report.pdf
```

### Command Overview

Below is a quick overview of all available commands. To get detailed usage instructions for a specific command, simply
run `pdfmt <command> help`.

| Category    | Command         | Description                                                        |
|:------------|:----------------|:-------------------------------------------------------------------|
| **Extract** | `extract even`  | Extract all even-numbered pages                                    |
|             | `extract help`  | Help of category *Extract*                                         |
|             | `extract odd`   | Extract all odd-numbered pages                                     |
|             | `extract range` | Extract a specific range of pages (e.g., 1-5) into a new PDF       |
| **Merge**   | `merge all`     | Combine PDFs into a single document                                |
|             | `merge duplex`  | Interleave two PDFs (front/back scans) into one duplex document    |
|             | `merge help`    | Help of category *Merge*                                           |
|             | `merge insert`  | Insert a PDF into another document at a specific page              |
| **Remove**  | `remove even`   | Remove all even-numbered pages                                     |
|             | `remove help`   | Help of category *Remove*                                          |
|             | `remove odd`    | Remove all odd-numbered pages                                      |
|             | `remove range`  | Remove a specific range of pages (e.g., 1-5)                       |
| **Scan**    | `scan adf`      | Scan documents from ADF (automatic document feeder) into a new PDF |
|             | `scan flatbed`  | Scan documents from flatbed scanner into a new PDF                 |
|             | `scan help`     | Help of category *Scan*                                            |
| **Sort**    | `sort duplex`   | Reorder a single PDF containing consecutive front and back scans   |
|             | `sort help`     | Help of category *Sort*                                            |
|             | `sort move`     | Move specific pages to a new position within the PDF               |
|             | `sort random`   | Shuffle the pages of a PDF into a random order                     |
|             | `sort reverse`  | Reverse the page order of a PDF                                    |
|             | `sort swap`     | Swap two specific pages within a PDF                               |
| **Split**   | `split all`     | Split a PDF into separate files, one for each page                 |
|             | `split help`    | Help of category *Split*                                           |
|             | `split length`  | Split a PDF into chunks of a fixed number of pages                 |
|             | `split range`   | Split a PDF into multiple files based on page ranges               |
| **Stamp**   | `stamp help`    | Help of category *Stamp*                                           |
|             | `stamp text`    | Add a custom text stamp to a PDF                                   |
| **Misc**    | `help`          | Help of `pdfmt`                                                    |
|             | `version`       | Displays the version of `pdfmt`                                    |

## Configuration

### Category: Scan

For the `scan` command, `pdfmt` looks for a configuration file at `~/.config/pdfmt/scan.conf`. This file is
automatically generated upon the first use of the scan command if it does not exist.

You can customize:

| Variable              | Possible Values                   | Default Value | Description                                                                                 |
|-----------------------|-----------------------------------|---------------|---------------------------------------------------------------------------------------------|
| `scan.device`         | ---                               | ---           | The name/path to your default scanner device. This can be determined by: `scanimage -f "%d" | head -n 1` |
| `scan.source.adf`     | Device specific, mostly `ADF`     | `ADF`         | Name of the Automated Document Feeder of your scanner device.                               |
| `scan.source.flatbed` | Device specific, mostly `Flatbed` | `Flatbed`     | Name of the Flatbed of your scanner device.                                                 |
| `scan.resolution`     | `100`, `200`, `300`, `600`        | `600`         | Resolution in DPI.                                                                          |
| `scan.mode`           | `Color`, `Lineart`, `Gray`        | `Color`       | Scan mode.                                                                                  |
| `scan.paper.format`   | `A4`, `A5`, ...                   | `A4`          | Default paper format.                                                                       |

### Category: Stamp

For the `stamp text` command, `pdfmt` looks for a configuration file at `~/.config/pdfmt/stamp_text.conf`. This file is
automatically generated upon the first use of the stamp command if it does not exist.

You can customize:

| Variable                | Possible Values      | Default Value | Description                                              |
|-------------------------|----------------------|---------------|----------------------------------------------------------|
| `stamp.text.font.file`  | ---                  | ---           | Absolute path to font file.                              |
| `stamp.text.font.size`  | Integer value        | `22`          | Font size for stamp.                                     |
| `stamp.text.font.color` | RGB Color Hash value | `#DC143C`     | Used font color for stamp (ImageMagic compatible value). |

## Development & Testing

This project is built with modularity in mind. Each command is isolated in the `sources/` directory.

### Running Tests

`pdfmt` uses [bashunit](https://bashunit.com/) for unit testing and [shellcheck](https://www.shellcheck.net/) for
linting.

To run the full test suite:

```bash
make test
```

### Adding New Commands

Create a new directory under `sources/command/`.

- Implement your logic in a new `.sh` file.
- Update the `_index.sh` file in that directory to route your new subcommand.
- Write your command description into the `help.sh` in that directory.
- Update `README.md` and *Command Overview* by using `tools/generate-command-overview.sh` script.
- The build system will automatically pick up your changes upon the next make build.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contribution

Pull requests and issues are very welcome! Feel free to open an issue if you find a bug or have a feature request.
