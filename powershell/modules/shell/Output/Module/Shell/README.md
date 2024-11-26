# The Shell PowerShell Module
A shell in PowerShell.
## Overview
This module implements a shell in PowerShell.
## Inspiration
100% inspired by Kamil Procyszyn.
- https://www.youtube.com/c/KamilPro
- https://github.com/kprocyszyn
## Folder Structure Conventions
- All building files must in Source folders:
  - In the root, place the module manifest.
    - In Public, place functions accessible by users.
    - In Private, place functions that inaccessible by users, e.g. helper functions.
    - Place one function per file, and file name must match the name of the function.
- In the root of the repository we have:
  - Debug-Module.ps1, provides the full development "inner loop".  Hit F5.
  - Install-Requirements.ps1, installs all required modules for this module to be built, packaged and invoked.
## About ModuleBuilder PowerShell Module
You can find source of ModuleBuilder [here](https://github.com/PoshCode/ModuleBuilder).
## About Pester PowerShell Module
You can find source of Pester [here](https://github.com/pester/Pester).
## About Shell PowerShell Module
You can find source of Shell [here](https://github.com/ronhowe/powershell/shell).
