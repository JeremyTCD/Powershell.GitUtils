if ((Get-Command "git" -ErrorAction SilentlyContinue) -eq $null) 
{ 
   Write-Host "Error: please install git and add it to your path"
}