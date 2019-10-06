param(
    # Path to Sims.exe
    # Ex. "C:\Program Files (x86)\Maxis\The Sims\Sims.exe"
    [Parameter(Mandatory = $true)]
    [string]$path,
    # Resolution
    [Parameter(Mandatory = $true)]
    [ValidateSet("3840x2160", "3440x1440", "2560x1440", "2560x1080", "1920x1080", "1366x768", "1280x720")]
    [string]$resolution,
    # Skip md5 hash check
    [Parameter(Mandatory = $false)]
    [switch]$force,
    # Install dgVoodoo2 to sims directory even if resolution doesn't exceed 1920x1080
    [Parameter(Mandatory = $false)]
    [switch]$forceVoodoo
)

$md5Hash = "42F9A3E11BD1A03515C77777CB97B5BC"

function Main {
    $folder = $path.Substring(0, $path.LastIndexOf('\'))
    FindFile $path
    BackupFile $path
    $width = GetHexWidth
    $height = GetHexHeight
    EditFile $path $width $height
    if ($resolution -eq "3840x2160" -or $resolution -eq "3440x1440" -or $resolution -eq "2560x1440" -or $resolution -eq "2560x1080" -or $forceVoodoo) {
        InstallDgVoodoo2 $folder
    }
    CopyGraphics $folder
}

function BackupFile([string]$path) {
    $backup = $path.Substring(0, $path.LastIndexOf('.')) + " Backup.exe"
    Copy-Item $path $backup
    if (!(Test-Path $backup)) {
        Write-Error 'Couldn''t backup Sims.exe'
        Exit 1
    }
}

function CopyGraphics([string]$folder) {
    Copy-Item -Path "Resolutions\$resolution\UIGraphics\" -Destination $folder -Container -Force -Recurse
}

function GetHexWidth {
    $width = $resolution.Split('x')[0]
    switch ($width) {
        "3840" { return 0x00, 0x0F }
        "3440" { return 0x70, 0x0D }
        "2560" { return 0x00, 0x0A }
        "1920" { return 0x80, 0x07 }
        "1366" { return 0x56, 0x05 }
        "1280" { return 0x00, 0x05 }
        Default {}
    }
}

function GetHexHeight {
    $height = $resolution.Split('x')[1]
    switch ($height) {
        "2160" { 0x70, 0x08 }
        "1440" { 0xA0, 0x05 }
        "1080" { 0x38, 0x04 }
        "768" { 0x00, 0x03 }
        "720" { 0xD0, 0x02 }
        Default {}
    }
}

function InstallDgVoodoo2([string]$folder) {
    $urls = "http://dege.freeweb.hu/dgVoodoo2/D3DCompiler_43.zip", "http://dege.freeweb.hu/dgVoodoo2/D3DCompiler_47.zip", "http://dege.freeweb.hu/dgVoodoo2/dgVoodoo2_62_1.zip"
    foreach ($url in $urls) {
        $downloaded = $url.Substring($url.LastIndexOf('/'))
        Invoke-WebRequest -Uri $url -OutFile $downloaded
        Expand-Archive -Path $downloaded -DestinationPath $folder -Force
        Remove-Item $downloaded
    }
    Copy-Item -Path "$folder\MS\x86\*" -Destination $folder -Force
    (Get-Content -Path "$folder\dgVoodoo.conf") -replace "dgVoodooWatermark                   = true", "dgVoodooWatermark                   = false" | Set-Content -Path "$folder\dgVoodoo.conf"
    Remove-Item "$folder\3Dfx" -Force -Recurse
    Remove-Item "$folder\Doc" -Force -Recurse
    Remove-Item "$folder\MS" -Force -Recurse
    # Remove-Item "$folder\x64" -Force -Recurse
    # Remove-Item "$folder\x86" -Force -Recurse
}

function EditFile(
    [string]$path,
    [array]$width,
    [array]$height
) {
    $widthOffset = 1001563
    $heightOffset = 1001570

    $bytes = [System.IO.File]::ReadAllBytes($path)

    $bytes[$widthOffset] = $width[0]
    $bytes[$widthOffset + 1] = $width[1]

    $bytes[$heightOffset] = $height[0]
    $bytes[$heightOffset + 1] = $height[1]

    [System.IO.File]::WriteAllBytes($path, $bytes)
}

function FindFile([string]$path) {
    if (!(Test-Path $path)) {
        Write-Error "$path not found."
        Exit 1
    }
    $hash = (Get-FileHash $path -Algorithm MD5).Hash
    if ($force -eq $false) {
        if ($hash -ne $md5Hash) {
            Write-Error "Incorrect MD5 sum. $path has $hash. It needs to be $md5hash"
            Exit 1
        }
    }
}

Main
