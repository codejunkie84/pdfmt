function command_workflow_help()
{
    cat <<TEXT
Workflow scripts make your daily PDF workflows easier

Usage:
  pdfmt workflow <command> [arguments]

Workflows:
  info          Shows information about a workflow
  list          List all available workflows
  run           Runs a workflow script

General Commands:
  help          Display this help message

TEXT
}
