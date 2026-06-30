$DownloadUrl = "https://kaiseritgroup.com/downloads/unifi-blockpage.cer"
$CertPath = Join-Path $env:TEMP "unifi-blockpage.cer"

Write-Output "Running as: $(whoami)"
Write-Output "Is Admin: $(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))"

try {
    Write-Output "Downloading certificate from: $DownloadUrl"
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $CertPath -UseBasicParsing

    if (!(Test-Path $CertPath)) {
        throw "Certificate download failed. File not found at $CertPath"
    }

    $Certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($CertPath)
    $Thumbprint = $Certificate.Thumbprint.Replace(" ", "").ToUpper()

    Write-Output "Downloaded certificate subject: $($Certificate.Subject)"
    Write-Output "Downloaded certificate thumbprint: $Thumbprint"

    $Existing = Get-ChildItem Cert:\LocalMachine\Root | Where-Object {
        $_.Thumbprint.Replace(" ", "").ToUpper() -eq $Thumbprint
    }

    if ($Existing) {
        Write-Output "Certificate already installed in LocalMachine Root store."
        Remove-Item $CertPath -Force -ErrorAction SilentlyContinue
        exit 0
    }

    Write-Output "Installing certificate into LocalMachine Root store..."
    Import-Certificate -FilePath $CertPath -CertStoreLocation "Cert:\LocalMachine\Root" | Out-Null

    $Verify = Get-ChildItem Cert:\LocalMachine\Root | Where-Object {
        $_.Thumbprint.Replace(" ", "").ToUpper() -eq $Thumbprint
    }

    if ($Verify) {
        Write-Output "Certificate installed and verified successfully."
        Remove-Item $CertPath -Force -ErrorAction SilentlyContinue
        exit 0
    }
    else {
        throw "Certificate import completed, but verification failed."
    }
}
catch {
    Write-Error "Certificate installation failed: $_"
    Remove-Item $CertPath -Force -ErrorAction SilentlyContinue
    exit 1
}
