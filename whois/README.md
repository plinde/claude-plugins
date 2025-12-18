# WHOIS Domain Lookup Plugin

Perform WHOIS domain lookups to retrieve registration data, nameservers, expiration dates, and registrar information.

## Features

- Domain registration lookups
- IP address ownership queries
- ASN (Autonomous System Number) lookups
- Expiration date checking
- Nameserver discovery
- Domain availability investigation

## Installation

```bash
claude plugin install whois@plinde-plugins
```

## Prerequisites

The `whois` command must be installed on your system:

### macOS
```bash
brew install whois
```

### Ubuntu/Debian
```bash
sudo apt-get install whois
```

### RHEL/CentOS/Fedora
```bash
sudo dnf install whois
```

## Usage Examples

### Basic Domain Lookup
```bash
whois example.com
```

### Check Domain Expiration
```bash
whois example.com | grep -iE "expir"
```

### Get Nameservers
```bash
whois example.com | grep -i "name server"
```

### IP Address Lookup
```bash
whois 8.8.8.8
```

### ASN Lookup
```bash
whois AS15169
```

## Common Use Cases

| Task | Command |
|------|---------|
| Domain availability | `whois newdomain.com \| grep -i "no match"` |
| Find registrar | `whois example.com \| grep -i registrar` |
| Check expiration | `whois example.com \| grep -iE expir` |
| Get nameservers | `whois example.com \| grep -i "name server"` |
| IP ownership | `whois 1.2.3.4` |

## Skill Content

This plugin provides a skill that teaches Claude how to:

- Perform domain WHOIS lookups
- Query specific WHOIS servers for different TLDs
- Parse WHOIS output for specific fields
- Look up IP addresses and ASNs
- Interpret EPP status codes
- Handle rate limiting and privacy-protected domains

## License

MIT License

## Author

Peter Linde
