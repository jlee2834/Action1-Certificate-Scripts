$CertPath = "C:\Temp\unifi-blockpage.cer"

if (!(Test-Path $CertPath)) {
    Write-Error "Certificate file not found: $CertPath"
    exit 1
}

try {
    Import-Certificate `
        -FilePath $CertPath `
        -CertStoreLocation "Cert:\LocalMachine\Root" | Out-Null

    Write-Output "Certificate installed successfully."
    exit 0
}
catch {
    Write-Error "Failed to install certificate: $_"
    exit 1
}
