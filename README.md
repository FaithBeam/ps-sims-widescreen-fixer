ps-sims-widescreen-fixer
=======================

This script hex edits *The Sims: Complete Collection* Sims.exe to use custom resolutions. You need the No-CD patch with MD5 hash 42F9A3E11BD1A03515C77777CB97B5BC for this script to work. Running this will:

1. Create a backup of Sims.exe named Sims Backup.exe
2. Hex edit Sims.exe with an accepted resolution
3. Install DGVoodoo2 if necessary (Resolutions greater than 1920x1080)
4. Copy the proper graphics files to The Sims UIGraph directory

Usage
=====

```
Get-Help ps-sims-widescreen-fixer.ps1
```

**Open PowerShell as administrator**

```
.\ps-sims-widescreen-fixer.ps1 -path "C:\Program Files (x86)\Maxis\The Sims\Sims.exe" -resolution "1920x1080"
```