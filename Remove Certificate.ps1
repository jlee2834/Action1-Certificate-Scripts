$CertThumbprint = "PASTE_CERT_THUMBPRINT_HERE"

$CertThumbprint = $CertThumbprint.Replace(" ", "").ToUpper()

$cert = Get-ChildItem "Cert:\LocalMachine\Root" | Where-Object {
    $_.Thumbprint -eq $CertThumbprint
}

if ($cert) {
    try {
        Remove-Item -Path $cert.PSPath -Force
        Write-Output "Certificate Removed."
        exit 0
    }
    catch {
        Write-Error "Failed To Remove: $_"
        exit 1
    }
}
else {
    Write-Output "No Certificate Found"
    exit 0
}
