$DownloadUrl = "https://kaiseritgroup.com/downloads/unifi-blockpage.cer"
$CertPath = Join-Path $env:TEMP "unifi-blockpage-test.cer"

Invoke-WebRequest -Uri $DownloadUrl -OutFile $CertPath -UseBasicParsing

$Certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($CertPath)
$Thumbprint = $Certificate.Thumbprint.Replace(" ", "").ToUpper()

$Existing = Get-ChildItem Cert:\LocalMachine\Root | Where-Object {
    $_.Thumbprint.Replace(" ", "").ToUpper() -eq $Thumbprint
}

Remove-Item $CertPath -Force -ErrorAction SilentlyContinue

if ($Existing) {
    Write-Output "PASS: Certificate is installed."
    Write-Output "Subject: $($Existing.Subject)"
    Write-Output "Thumbprint: $($Existing.Thumbprint)"
    exit 0
}
else {
    Write-Output "FAIL: Certificate is not installed."
    exit 1
}
