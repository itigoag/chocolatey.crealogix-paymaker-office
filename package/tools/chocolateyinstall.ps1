# crealogix-paymaker-office install

$ErrorActionPreference = 'Stop';

$toolsDir            = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageParameters   = Get-PackageParameters
$urlZip              = 'https://shop.crealogix.com/download/get/file/pm5.office'
$checksumZip = "d408f407361fc649d0f6b9994f3c20c3f97c5199a2aadb3e10b2d0153051fe7b759e043c6ec45f58a08d6c641fd2ba6dff3b66872673ba84e4ad696b30455703"
$checksumTypeZip     = 'SHA512'
$unzipLocation       = "$($env:TMP)\$($env:ChocolateyPackageName)\$($env:ChocolateyPackageVersion)"
$version             = "$($env:ChocolateyPackageVersion.split(".")[0, 1, 2] -join '.')"

Import-Module -Name "$($toolsDir)\helpers.ps1"

$zipArgs = @{
    packageName    = $env:ChocolateyPackageName
    url            = $urlZip
    unzipLocation  = $unzipLocation
    checksum       = $checksumZip
    checksumType   = $checksumTypeZip
}

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'MSI'
    file           = "$($unzipLocation)\PayMaker$($version).msi"
    silentArgs     = '/q'
    ValidExitCodes = @(0, 1000, 1101)
}

Install-ChocolateyZipPackage @zipArgs

Install-ChocolateyInstallPackage @packageArgs

if ($PackageParameters.RemoveDesktopIcons) {
    Remove-DesktopIcons -Name "PayMaker" -Desktop "Public"
}

if ($PackageParameters.CleanStartmenu) {
    Remove-FileItem `
        -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PayMaker"
    Install-ChocolateyShortcut `
        -ShortcutFilePath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PayMaker.lnk" `
        -TargetPath "C:\Program Files (x86)\CLX.PayMaker\PaymentStudio.exe" `
        -WorkDirectory "C:\Program Files (x86)\CLX.PayMaker\"
}
