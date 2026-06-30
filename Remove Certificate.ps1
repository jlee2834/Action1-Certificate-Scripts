$DownloadUrl = "https://kaiseritgroup.com/downloads/unifi-blockpage.cer"
$CertPath = Join-Path $env:TEMP "unifi-blockpage.cer"

Write-Output "Running as: $(whoami)"
Write-Output "Is Admin: $(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))"

try {
    Write-Output "Downloading certificate from: $DownloadUrl"
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $CertPath -UseBasicParsing

    if (!(Test-Path $CertPath)) {
        throw "Certificate download failed."
    }

    $Certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($CertPath)
    $Thumbprint = $Certificate.Thumbprint.Replace(" ", "").ToUpper()

    Write-Output "Looking for certificate:"
    Write-Output "Subject: $($Certificate.Subject)"
    Write-Output "Thumbprint: $Thumbprint"

    $Existing = Get-ChildItem Cert:\LocalMachine\Root | Where-Object {
        $_.Thumbprint.Replace(" ", "").ToUpper() -eq $Thumbprint
    }

    if (-not $Existing) {
        Write-Output "Certificate is already removed."
        Remove-Item $CertPath -Force -ErrorAction SilentlyContinue
        exit 0
    }

    Remove-Item -Path $Existing.PSPath -Force

    $Verify = Get-ChildItem Cert:\LocalMachine\Root | Where-Object {
        $_.Thumbprint.Replace(" ", "").ToUpper() -eq $Thumbprint
    }

    if ($Verify) {
        throw "Certificate still exists after removal."
    }

    Write-Output "Certificate removed successfully."

    Remove-Item $CertPath -Force -ErrorAction SilentlyContinue

    exit 0
}
catch {
    Write-Error "Certificate removal failed: $_"
    Remove-Item $CertPath -Force -ErrorAction SilentlyContinue
    exit 1
}
