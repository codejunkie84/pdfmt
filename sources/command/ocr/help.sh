function command_ocr_help()
{
    cat <<TEXT
OCR operations for PDF files

Usage:
  pdfmt ocr <command> [arguments]

Commands:
  add           Add an OCR text layer to a PDF document
  exists        Check if a PDF document contains an OCR text layer
  show          Print the OCR text layer to stdout

General Commands:
  help          Display this help message

TEXT
}
