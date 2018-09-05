# crealogix-paymaker-office install

$ErrorActionPreference = 'Stop';

$toolsDir            = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageParameters   = Get-PackageParameters
$urlZip              = 'https://shop.crealogix.com/download/get/file/pm5.office'
$checksumZip         = '7da52b4a856fd1f23f50947480917d4c4e3a468f27034716b3b60572ba6d92b8d5ec4707def427855e9ecadf07d4e93d1edd432cba166f535a1dd69219e01c94'
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
