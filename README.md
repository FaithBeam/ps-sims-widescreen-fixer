ps-sims-widescreen-fixer
=======================

This script hex edits *The Sims: Complete Collection* Sims.exe to a custom resolution. You need the No-CD patch with MD5 hash 42F9A3E11BD1A03515C77777CB97B5BC for this script to work. Running this will:

1. Create a backup of Sims.exe named Sims Backup.exe
2. Hex edit Sims.exe with an accepted resolution
3. Install [DGVoodoo2](http://dege.freeweb.hu/dgVoodoo2/dgVoodoo2.html) if necessary (Resolutions greater than 1920x1080 or if forced with -forceVoodoo)
4. Copy the proper graphics files to The Sims UIGraph directory

Requirements
============

* PowerShell 5.0 or greater

Resolutions Supported
=====================

The highest resolution I recommend is 1920x1080, any resolution larger than that makes everything too small to see clearly. If you check out the screenshots, you'll notice that the larger the resolution, the further the camera is pulled out.

* 3840x2160
* 2560x1440
* 1920x1080
* 1366x768
* 1280x720

Usage
=====

```
Get-Help ps-sims-widescreen-fixer.ps1
```

**Open PowerShell as administrator**

```
.\ps-sims-widescreen-fixer.ps1 -path "C:\Program Files (x86)\Maxis\The Sims\Sims.exe" -resolution "1920x1080"
```

Screenshots
===========

[Wiki](https://github.com/FaithBeam/ps-sims-widescreen-fixer/wiki)
