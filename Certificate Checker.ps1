$CertThumbprint = "PASTE_CERT_THUMBPRINT_HERE"

$CertThumbprint = $CertThumbprint.Replace(" ", "").ToUpper()

$cert = Get-ChildItem "Cert:\LocalMachine\Root" | Where-Object {
    $_.Thumbprint -eq $CertThumbprint
}

if ($cert) {
    Write-Output "Certificate Is Installed."
    Write-Output "Subject: $($cert.Subject)"
    Write-Output "Thumbprint: $($cert.Thumbprint)"
    exit 0
}
else {
    Write-Output "Certificate NOT Installed."
    exit 1
}
