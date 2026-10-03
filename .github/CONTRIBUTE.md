# Contributing to pdfmt

Thank you for your interest in contributing to **pdfmt**! We welcome bug reports, feature proposals, documentation improvements, and code contributions.

This document provides a brief guideline on how to set up your environment, follow project standards, and submit changes.

---

## How to Contribute

### Reporting Bugs & Requesting Features

* **Check existing issues:** Before opening a new issue, check if it has already been reported.
* **Bug reports:** Clearly state the expected behavior, actual behavior, your operating system, and steps to reproduce.
* **Feature requests:** Explain the problem you are trying to solve and why a new feature or command would benefit `pdfmt` users.

### Contributing Code

If you plan to implement a new feature or fix a bug:

1. Fork the repository and create a feature branch (`git checkout -b feature/my-feature`).
2. Implement your changes following our coding guidelines.
3. Ensure all tests pass and code is formatted.
4. Submit a Pull Request.

---

## Local Development & Setup

### Prerequisites
To build and test `pdfmt` locally, ensure you have the following installed:
* **Bash** (>= 4.3)
* **Make**
* **ShellCheck** (for static analysis)
* **bashunit** (for running test suites)

### Common Development Commands

* **Build the project:**
 
Generates the distribution executable at `dist/pdfmt`.

```bash
make
```

* **Run the test suite:**

Executes unit and integration tests via `bashunit`.

```bash
make test
```

* **Format code:**

Applies standard formatting to all shell scripts.

```bash
tools/format-code.sh
```

---

## Architecture & Code Guidelines
`pdfmt` prioritizes maintainability, simplicity, and robustness. Please follow these principles when writing Bash code:

* **Modular Routing:** Individual commands and subcommands reside in `sources/command/`. Keep logic isolated to their respective command modules.
* **Strict Mode:** All shell scripts must include `set -euo pipefail` at the top or inside the main() function.
* **Variable Scoping:** Avoid global variables if possible. Use `local -r` for immutable local variables inside functions.
* **Naming Conventions:** Use `snake_case` for local variables and functions.
* **Linting:** Ensure your code passes ShellCheck without warnings. Executes linting via `make lint`

---

## Submitting a Pull Request

When submitting a Pull Request, please ensure the following (as reflected in our PR checklist):

- [ ] Run `make` to verify that the build succeeds.
- [ ] Run `make test` to ensure all existing and new tests pass.
- [ ] Run `tools/format-code.sh` to maintain uniform formatting.
- [ ] Update relevant documentation (e.g., `README.md` or command help outputs).
