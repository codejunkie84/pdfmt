function command_help()
{
    cat <<TEXT
pdfmt - PDF Multi-Tool for PDF manipulation (v${VERSION})

Usage:
  pdfmt <command> <subcommand> [arguments]

Core Commands:
  extract       Save specific pages into a new PDF
  merge         Combine PDFs into a single document
  ocr           OCR operations for PDF files
  remove        Delete specific pages from a PDF
  scan          Create PDFs directly from a scanner
  split         Split a PDF into multiple files
  sort          Reorder pages within a PDF
  stamp         Add custom overlays (like dates, status marks) to your PDFs
  workflow      Workflow scripts make your daily PDF workflows easier

General Commands:
  help          Display this help message
  version       Show the current version of pdfmt

Examples:
  pdfmt split all input.pdf
  pdfmt merge duplex front.pdf back.pdf output.pdf
  pdfmt sort reverse input.pdf output.pdf
  pdfmt scan adf output.pdf

Use "pdfmt <command> help" for more information on a specific command.

For more info, visit https://www.eifelcode.com
TEXT
}
