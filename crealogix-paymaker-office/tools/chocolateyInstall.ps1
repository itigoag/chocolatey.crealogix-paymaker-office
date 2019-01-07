# crealogix-paymaker-office install

$ErrorActionPreference = 'Stop';

$toolsDir            = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageParameters   = Get-PackageParameters
$urlZip              = 'https://shop.crealogix.com/download/get/file/pm5.office'
$checksumZip         = '0069051d5ece9d4b6f22a6673684a4a5d130741765842d6791080a748a392b9a2afb07cba371eb3f2ce3acb445d856a5fc102dd811a1382199a7ca8e58069a34'
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
