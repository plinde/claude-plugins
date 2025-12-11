# Kyverno Version Lookup Plugin

Query Kyverno Helm chart versions, release dates, and app version mappings from Artifact Hub.

## Installation

```bash
/plugin install kyverno-version-lookup@plinde
```

## Features

- Query Kyverno Helm chart releases from Artifact Hub API
- Filter to stable releases only (excludes rc/beta/alpha)
- Display chart version ↔ app version mapping
- Show release dates for upgrade planning
- JSON output for programmatic use

## Usage

After installation, the `kyverno-version-lookup` skill will be available.

### Quick Lookup

```bash
# Show latest 15 stable releases
~/.claude/plugins/kyverno-version-lookup/skills/kyverno-version-lookup/scripts/kyverno-versions.sh --limit 15

# JSON output
~/.claude/plugins/kyverno-version-lookup/skills/kyverno-version-lookup/scripts/kyverno-versions.sh --json

# All stable releases
~/.claude/plugins/kyverno-version-lookup/skills/kyverno-version-lookup/scripts/kyverno-versions.sh
```

### Sample Output

```
CHART_VERSION  APP_VERSION  RELEASE_DATE
-------------  -----------  ------------
3.6.1          v1.16.1      2025-12-03
3.6.0          v1.16.0      2025-11-10
3.5.2          v1.15.2      2025-09-18
3.5.1          v1.15.1      2025-08-15
3.5.0          v1.15.0      2025-07-31
```

## Version Mapping

The Helm chart version and Kyverno app version follow different schemes:

| Chart Version | App Version | Notes |
|---------------|-------------|-------|
| 3.6.x | v1.16.x | Latest |
| 3.5.x | v1.15.x | |
| 3.4.x | v1.14.x | |
| 3.3.x | v1.13.x | |
| 3.2.x | v1.12.x | |
| 3.1.x | v1.11.x | |

## API Reference

This plugin queries the Artifact Hub API:

```
https://artifacthub.io/api/v1/packages/helm/kyverno/kyverno
```

## Use Cases

1. **Upgrade planning** - Check what versions are available and when they were released
2. **CVE remediation** - Find which chart version contains a specific app version fix
3. **Compatibility checks** - Understand the version mapping between chart and app
4. **Release timeline analysis** - See the cadence of Kyverno releases

## License

MIT
