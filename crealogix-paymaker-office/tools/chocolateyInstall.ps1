# crealogix-paymaker-office install

$ErrorActionPreference = 'Stop';

$toolsDir            = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageParameters   = Get-PackageParameters
$urlZip              = 'https://shop.crealogix.com/download/get/file/pm5.office'
$checksumZip         = '3d0785bcd73905a6cd98b4620e0784a653b8212fbb85c34486fc50a5e67e4c5e235c8f611f0b99b9eba35498d45d0c6f1b3a48559a7e7065c348ebf4b64a555f'
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
