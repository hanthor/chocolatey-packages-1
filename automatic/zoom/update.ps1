﻿$ErrorActionPreference = 'Stop'
import-module au

$download_page_url = 'https://zoom.us/download#client_4meeting'
$url = 'https://zoom.us/client/latest/ZoomInstallerFull.msi'

function global:au_SearchReplace {
    @{
        'tools\ChocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^[$]url\s*=\s*)('.*')"   = "`$1'$($Latest.Url)'"
        }
     }
}

function global:au_GetLatest {
    $homepage_content = Invoke-WebRequest -UseBasicParsing -Uri $download_page_url

     # Get Version
    $homepage_content -match '(Version \d+.\d+.\d+.\d+)'| Out-Null
    $version = $matches[1] -replace "Version ", ""

    $Latest = @{ URL = $url; Version = $version }
    return $Latest
}

update -NoCheckUrl -ChecksumFor 32
