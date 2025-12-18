---
name: whois
description: This skill should be used when performing WHOIS domain lookups to retrieve domain registration data, nameservers, expiration dates, registrar information, and contact details. Use for domain availability checks, ownership verification, and DNS investigation.
---

# WHOIS Domain Lookup

## Core Commands

### Basic Domain Lookup

```bash
# Standard domain lookup
whois example.com

# Lookup with specific WHOIS server
whois -h whois.verisign-grs.com example.com

# Follow referrals to authoritative server
whois -r example.com
```

### Common TLD Servers

```bash
# .com/.net domains (Verisign)
whois -h whois.verisign-grs.com example.com

# .org domains (PIR)
whois -h whois.pir.org example.org

# .io domains
whois -h whois.nic.io example.io

# .dev domains (Google)
whois -h whois.nic.google example.dev

# Country-code TLDs
whois -h whois.nic.uk example.co.uk
whois -h whois.denic.de example.de
whois -h whois.nic.fr example.fr
```

### IP Address Lookups

```bash
# IP address WHOIS (finds owning organization)
whois 8.8.8.8

# Use specific RIR (Regional Internet Registry)
whois -h whois.arin.net 8.8.8.8      # North America
whois -h whois.ripe.net 1.2.3.4      # Europe
whois -h whois.apnic.net 1.2.3.4     # Asia-Pacific
whois -h whois.lacnic.net 1.2.3.4    # Latin America
whois -h whois.afrinic.net 1.2.3.4   # Africa
```

### ASN Lookups

```bash
# Autonomous System Number lookup
whois AS15169

# Via specific registry
whois -h whois.arin.net AS15169
```

## Output Parsing

### Extract Specific Fields

```bash
# Get nameservers only
whois example.com | grep -i "name server"

# Get expiration date
whois example.com | grep -iE "(expir|expiry|renewal)"

# Get registrar info
whois example.com | grep -i "registrar"

# Get creation date
whois example.com | grep -iE "(creation|created|registered)"

# Get status codes
whois example.com | grep -i "status"
```

### JSON-like Extraction (using grep/awk)

```bash
# Extract key fields into structured format
whois example.com | grep -iE "^(domain|registrar|creation|expir|name server|status):" | \
  awk -F: '{gsub(/^[ \t]+/, "", $2); print $1 ": " $2}'
```

## Common Use Cases

### Check Domain Availability

```bash
# If output contains "No match" or similar, domain may be available
whois newdomain.com | grep -iE "(no match|not found|no data|available)"
```

### Verify Domain Ownership

```bash
# Check registrant organization
whois example.com | grep -iE "(registrant|owner|org)"
```

### Check Domain Expiration

```bash
# Find expiration date for renewal planning
whois example.com | grep -iE "expir"
```

### Investigate Suspicious Domains

```bash
# Get full registration details
whois suspicious-domain.com

# Check creation date (recently created domains may be suspicious)
whois suspicious-domain.com | grep -iE "creat"

# Check registrar (some registrars are associated with abuse)
whois suspicious-domain.com | grep -i "registrar"
```

### Bulk Domain Checks

```bash
# Check multiple domains
for domain in example.com example.org example.net; do
  echo "=== $domain ==="
  whois "$domain" | grep -iE "(registrar|expir|name server)"
  echo
done
```

## Domain Status Codes

Common EPP status codes you'll see:

| Status | Meaning |
|--------|---------|
| `clientTransferProhibited` | Transfer locked by registrar |
| `clientDeleteProhibited` | Delete locked by registrar |
| `clientUpdateProhibited` | Update locked by registrar |
| `serverTransferProhibited` | Transfer locked by registry |
| `redemptionPeriod` | Domain expired, in grace period |
| `pendingDelete` | Domain scheduled for deletion |
| `ok` | No restrictions, normal status |

## Rate Limiting and Best Practices

1. **Respect rate limits** - WHOIS servers may block excessive queries
2. **Cache results** - Don't repeatedly query the same domain
3. **Use appropriate servers** - Query authoritative servers for accurate data
4. **Handle privacy protection** - Many domains use WHOIS privacy services

```bash
# Add delay between bulk queries to avoid rate limiting
for domain in $(cat domains.txt); do
  whois "$domain" >> results.txt
  sleep 2
done
```

## Troubleshooting

**Connection refused:**
```bash
# Try alternate WHOIS server
whois -h whois.internic.net example.com
```

**Empty or minimal results:**
```bash
# Domain may have WHOIS privacy enabled
# Try the registrar's WHOIS directly
whois -h whois.godaddy.com example.com
```

**Timeout issues:**
```bash
# Increase timeout (if supported)
timeout 30 whois example.com
```

## Installation

### macOS
```bash
# Usually pre-installed, or:
brew install whois
```

### Ubuntu/Debian
```bash
sudo apt-get install whois
```

### RHEL/CentOS/Fedora
```bash
sudo dnf install whois
# or
sudo yum install whois
```

## References

- [ICANN WHOIS](https://lookup.icann.org/) - Web-based WHOIS lookup
- [IANA WHOIS Service](https://www.iana.org/whois) - Root zone WHOIS
- [EPP Status Codes](https://www.icann.org/resources/pages/epp-status-codes-2014-06-16-en) - Official status code reference
