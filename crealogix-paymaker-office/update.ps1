import-module au

$url                 = 'https://shop.crealogix.com/software-updates/pm-office5.html'
$checksumTypePackage = "SHA512"

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1'   = @{
            "(^\s*[$]*urlZip\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(^\s*[$]*checksumZip\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(^\s*[$]*checksumTypeZip\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }; 
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $url -UseBasicParsing -DisableKeepAlive

    $reLatestbuild = '(.*Aktuelle Version.*)'
    $download_page.Content -imatch $reLatestbuild
    $latestbuild   = $Matches[0]

    $reVersion = "(\d+)(.)(\d+)(.)(\d+)(.)(\d+)"
    $latestbuild -imatch $reVersion
    $version     = $Matches[0]

    
    $urlPackage = "https://shop.crealogix.com/download/get/file/pm5.office"

    return  @{ 
        URL32          = $urlPackage;
        ChecksumType32 = $checksumTypePackage;
        Version        = $version
    }
}

function global:au_AfterUpdate ($Package) {
    Set-DescriptionFromReadme $Package -SkipFirst 3
}

update
