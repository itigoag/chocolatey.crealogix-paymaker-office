# Chocolatey: Crealogix PayMaker Office

[![Build Status](https://img.shields.io/travis/itigoag/chocolatey.crealogix-paymaker-office?style=flat-square)](https://travis-ci.org/itigoag/chocolatey.crealogix-paymaker-office) [![license](https://img.shields.io/github/license/mashape/apistatus.svg?style=popout-square)](licence) [![Chocolatey](https://img.shields.io/chocolatey/v/crealogix-paymaker-office?label=package%20version)](https://chocolatey.org/packages/crealogix-paymaker-office) [![Chocolatey](https://img.shields.io/chocolatey/dt/crealogix-paymaker-office?label=package%20downloads&style=flat-square)](https://chocolatey.org/packages/crealogix-paymaker-office)

## Description

The multi-banking software PayMaker Office offers you comprehensive features for your payment transactions, with an overview and transparency at all times and across different banks. You can make payments of all types and in a wide variety of formats quickly and reliably.

## Package Parameters

- `/CleanStartmenu` Removes frequently used Crealogix PayMaker Office shortcuts from the Startmenu.
- `/RemoveDesktopIcons` Removes the desktop icon from Crealogix PayMaker Office.

## Installation

### choco

installation without parameters.

```ps1
choco install crealogix-paymaker-office
```

installation with parameters.

```powershell
 choco install crealogix-paymaker-office --params="'/RemoveDesktopIcons /CleanStartmenu'"
```

### [ITIGO Packages](https://github.com/itigoag/ansible.packages)

installation without parameters.

```yml
packages:
  crealogix-paymaker-office:
    version: latest
```

installation with parameters.

```yml
packages:
  crealogix-paymaker-office:
    version: latest
    params: "'/Autostart:false /RemoveDesktopIcons /CleanStartmenu'"
```

## Disclaimer

These Chocolatey Packages only contain installation routines. The software itself is downloaded from the official sources of the software developer. ITIGO AG has no affilation with the software developer.

## Author

- [Simon Bärlocher](https://sbaerlocher.ch)
- [ITIGO AG](https://www.itigo.ch)

## License

This project is under the MIT License. See the [LICENSE](LICENSE) file for the full license text.

## Copyright

(c) 2019, ITIGO AG
