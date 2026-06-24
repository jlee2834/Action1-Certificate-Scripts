# Action1 Certificate Scripts

PowerShell scripts for deploying, validating, and removing trusted root certificates on Windows endpoints. Designed for use with Action1, ScreenConnect, Intune, PDQ Deploy, RMM platforms, or manual administration.

## Overview

When implementing UniFi DNS filtering and HTTPS block pages, endpoints must trust the certificate authority used by the UniFi gateway. Without the certificate installed, users may receive browser certificate warnings instead of a clean and professional block page.

This repository provides three scripts to manage the certificate lifecycle:

- Add-Certificate.ps1
- Check-Certificate.ps1
- Remove-Certificate.ps1

---

## Features

- Install certificates into the Trusted Root store
- Verify certificate presence using thumbprints
- Remove certificates cleanly
- Action1 compatible
- Uses standard Windows certificate stores
- Simple deployment and rollback process

---

## Files

### Add-Certificate.ps1

Installs a certificate into:

```
Cert:\LocalMachine\Root
```

#### Requirements

- Administrative privileges
- Certificate (.cer) file available locally

#### Example

```powershell
$CertPath = "C:\Temp\unifi-blockpage.cer"
```

#### Usage

```powershell
.\Add-Certificate.ps1
```

---

### Check-Certificate.ps1

Verifies whether a certificate exists in the Trusted Root Certification Authorities store.

#### Requirements

- Certificate thumbprint

#### Example

```powershell
$CertThumbprint = "PASTE_CERT_THUMBPRINT_HERE"
```

#### Usage

```powershell
.\Check-Certificate.ps1
```

#### Exit Codes

| Code | Meaning |
|--------|---------|
| 0 | Certificate found |
| 1 | Certificate not found |

---

### Remove-Certificate.ps1

Removes a certificate from the Trusted Root store using its thumbprint.

#### Requirements

- Administrative privileges
- Certificate thumbprint

#### Example

```powershell
$CertThumbprint = "PASTE_CERT_THUMBPRINT_HERE"
```

#### Usage

```powershell
.\Remove-Certificate.ps1
```

#### Exit Codes

| Code | Meaning |
|--------|---------|
| 0 | Successfully removed or already absent |
| 1 | Removal failed |

---

## Finding a Certificate Thumbprint

### Search by Subject

```powershell
Get-ChildItem Cert:\LocalMachine\Root |
Where-Object {
    $_.Subject -like "*UniFi*"
} |
Select-Object Subject, Thumbprint
```

### List All Trusted Root Certificates

```powershell
Get-ChildItem Cert:\LocalMachine\Root |
Select-Object Subject, Thumbprint
```

---

## Action1 Deployment Example

### Install Certificate

1. Upload the certificate file (.cer).
2. Upload Add-Certificate.ps1.
3. Run as SYSTEM or Administrator.
4. Verify installation using Check-Certificate.ps1.

### Validate Deployment

Use Check-Certificate.ps1 as:

- Compliance check
- Detection script
- Post-deployment verification

### Remove Certificate

Deploy Remove-Certificate.ps1 when:

- Rotating certificates
- Replacing a CA
- Retiring UniFi block pages
- Troubleshooting certificate issues

---

## Requirements

- Windows 10/11
- Windows Server 2016+
- PowerShell 5.1 or newer
- Administrative privileges

---

## License

MIT License
