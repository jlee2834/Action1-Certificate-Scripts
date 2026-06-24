$CertPath = "C:\Temp\unifi-blockpage.cer"

if (!(Test-Path $CertPath)) {
    Write-Error "File Not Found: $CertPath"
    exit 1
}

try {
    Import-Certificate `
        -FilePath $CertPath `
        -CertStoreLocation "Cert:\LocalMachine\Root" | Out-Null

    Write-Output "Certificate Installed."
    exit 0
}
catch {
    Write-Error "Failed To Install: $_"
    exit 1
}
