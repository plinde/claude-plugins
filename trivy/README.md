# Trivy Plugin

Scan container images, filesystems, and repositories for vulnerabilities using Trivy.

## Features

- **Image Scanning** - Scan container images for CVEs
- **Filesystem Scanning** - Scan Node.js, Python, Go projects for vulnerabilities
- **Repository Scanning** - Scan Git repositories directly
- **Severity Filtering** - Focus on HIGH/CRITICAL vulnerabilities
- **Multiple Output Formats** - Table, JSON, SARIF for CI/CD integration
- **Batch Scanning** - Scan multiple images with helper scripts

## Installation

```bash
claude plugin install trivy@plinde-plugins
```

## Usage

The skill activates automatically when:
- Scanning container images for vulnerabilities
- Analyzing package dependencies for CVEs
- Comparing vulnerability status across image versions
- Setting up CI/CD security scanning

## Quick Reference

### Image Scanning

```bash
# Scan with severity filter (recommended)
trivy image --severity HIGH,CRITICAL <image:tag>

# JSON output for automation
trivy image --format json --output results.json <image:tag>
```

### Filesystem Scanning

```bash
# Scan current directory
trivy fs --scanners vuln .

# Scan with severity filter
trivy fs --scanners vuln --severity HIGH,CRITICAL .
```

### Compare Versions

```bash
trivy image --severity HIGH,CRITICAL image:v1 > v1.txt
trivy image --severity HIGH,CRITICAL image:v2 > v2.txt
diff v1.txt v2.txt
```

## Requirements

- [Trivy](https://aquasecurity.github.io/trivy/) installed (`brew install trivy` on macOS)

## License

MIT License

## Author

Peter Linde
