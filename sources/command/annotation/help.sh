function command_annotation_help()
{
    cat <<TEXT
Perform simple annotation operations on a document

Usage:
  pdfmt annotation <command> [arguments]

Commands:
  list          List all annotation types present in a PDF document
  remove        Remove annotations from a PDF document
  show          Show annotation details into plain text format

General Commands:
  help          Display this help message

TEXT
}
