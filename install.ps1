param([Parameter(Mandatory=$true)][string]$BaseUrl, [string]$Prefix = "$env:LOCALAPPDATA\Vixel", [string]$DownloadBaseUrl = '', [switch]$Upgrade)
$ErrorActionPreference = 'Stop'
$Version = '0.5.7'
$Origin = [Uri]$BaseUrl
if (($Origin.Scheme -ne 'https' -and -not ($Origin.Scheme -eq 'http' -and $Origin.Host -in @('localhost','127.0.0.1'))) -or $Origin.UserInfo -or $Origin.Query -or $Origin.Fragment -or $Origin.AbsolutePath -ne '/') { throw 'Use HTTPS or a loopback platform origin.' }
if ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture -ne 'X64') { throw 'This release supports Windows x64 only.' }
$BaseUrl = $BaseUrl.TrimEnd('/')
if (-not $DownloadBaseUrl) { $DownloadBaseUrl = "$BaseUrl/downloads" }
$DownloadOrigin = [Uri]$DownloadBaseUrl
if (($DownloadOrigin.Scheme -ne 'https' -and -not ($DownloadOrigin.Scheme -eq 'http' -and $DownloadOrigin.Host -in @('localhost','127.0.0.1'))) -or $DownloadOrigin.UserInfo -or $DownloadOrigin.Query -or $DownloadOrigin.Fragment) { throw 'Downloads require HTTPS or a loopback URL without credentials.' }
$DownloadBaseUrl = $DownloadBaseUrl.TrimEnd('/')
$Name = "vixel-$Version-windows-x64.zip"
$Temp = Join-Path ([IO.Path]::GetTempPath()) ([Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $Temp | Out-Null
try {
  Invoke-WebRequest "$DownloadBaseUrl/$Name" -OutFile "$Temp\archive.zip" -MaximumRedirection 5
  $Checksums = (Invoke-WebRequest "$DownloadBaseUrl/vixel-$Version-checksums.txt" -MaximumRedirection 5).Content
  $Expected = (($Checksums -split "`n" | Where-Object { $_.Trim().EndsWith("  $Name") }) -split '\s+')[0]
  if (-not $Expected -or (Get-FileHash "$Temp\archive.zip" -Algorithm SHA256).Hash.ToLower() -ne $Expected) { throw 'Checksum mismatch; nothing installed.' }
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $Archive = [IO.Compression.ZipFile]::OpenRead("$Temp\archive.zip")
  try { if ($Archive.Entries.Count -ne 1 -or $Archive.Entries[0].FullName -ne 'vixel.exe') { throw 'Unexpected archive members.' } } finally { $Archive.Dispose() }
  Expand-Archive "$Temp\archive.zip" "$Temp\unpacked"
  New-Item -ItemType Directory -Force -Path "$Prefix\bin" | Out-Null
  $Dest = "$Prefix\bin\vixel.exe"
  if (Test-Path $Dest) {
    if ((Get-Item $Dest).Attributes -band [IO.FileAttributes]::ReparsePoint) { throw 'Existing symlink preserved.' }
    if ((Get-FileHash $Dest).Hash -ne (Get-FileHash "$Temp\unpacked\vixel.exe").Hash -and -not $Upgrade) { throw 'Different binary exists. Review and rerun with -Upgrade.' }
  }
  Copy-Item "$Temp\unpacked\vixel.exe" $Dest -Force
  & $Dest version
  Write-Output "Installed: $Dest. Run setup --directory YOUR_AGENT_FOLDER --base-url $BaseUrl"
} finally { Remove-Item -Recurse -Force $Temp }
