# crealogix-paymaker-office install

$ErrorActionPreference = 'Stop';

$toolsDir            = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageParameters   = Get-PackageParameters
$urlZip              = 'https://shop.crealogix.com/download/get/file/pm5.office'
$checksumZip         = '4c91e4ef7d74c504d0be07a2d0a0c661564af7803fcb35291d9a45043568eb9c59791afd99c9287e5d93e18654e90b82d84dc4d48debf3eed4413e21027eeb85'
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
