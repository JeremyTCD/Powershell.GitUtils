git config --global credential.helper store
Add-Content "$($env:USERPROFILE)\.git-credentials" "https://$($env:git_key):x-oauth-basic@github.com`n"

git config --global user.email $env:build_user_email
git config --global user.name $env:build_user

Push-ChangelogFromTags -Verbose
   
$latestVersion = git describe --abbrev=0
# The following should be moved into a Publish-Powershell function
$moduleExists = Find-Module -Name GitUtils -RequiredVersion $latestVersion
if(!$moduleExists){
    Update-ModuleManifest -Path './src/GitUtils/GitUtils.psd1' -ModuleVersion $latestVersion
    Publish-Module -Path './src/GitUtils' -NuGetApiKey ${env:nuget_key}

	if($?){
		Write-Host "GitUtils version $latestVersion successfully published" 
	}
}