Split-Path $PSCommandPath | Set-Location
Import-Module ("..\src\GitUtils\" + (Split-Path -Leaf $PSCommandPath).Replace(".tests.ps1", ".psd1"))
