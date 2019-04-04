function Main {
    $file = ".\Sims.exe"
    $bytes  = [System.IO.File]::ReadAllBytes($file)
    $widthOffset = 1001563
    $heightOffset = 1001570
    
    if ('{0:X}' -f $bytes[1001563] -eq 20) {
        $bytes[$widthOffset] = 0x80
        $bytes[$widthOffset+1] = 0x07

        $bytes[$heightOffset] = 0x38
        $bytes[$heightOffset+1] = 0x04

        [System.IO.File]::WriteAllBytes($file, $bytes)
    } else {
        Write-Error 'Incorrect Sims.exe supplied.'
    }
}

Main