# Release Process

Step-by-step guide for creating and publishing a new release.

1. **Prepare and build locally**
    1. Update the version number in the [`VERSION`](../VERSION) file on the `main` branch (e.g., `1.0.1`).
    2. Run tests to ensure everything works (e.g., `make test`).
    3. Build the project using `make` (this generates `dist/pdfmt`).
    4. Commit and push the version bump to GitHub.

2. **Create the GitHub Release**
    1. Go to [Draft a new release](https://github.com/eifelcode/pdfmt/releases/new).
    2. Create a new tag matching the version number **with** prefix `v` (e.g., `v1.0.1`).
    3. Set the release title to the version number **without** prefix `v` (e.g., `1.0.1`).
    4. Click on **Generate release notes**.
    5. Attach the generated distribution file (`dist/pdfmt`) to the release.
    6. Click on **Publish release**.
