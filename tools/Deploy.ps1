cd C:\projects\powershell-gitutils
git config --global credential.helper store
Add-Content "$($env:USERPROFILE)\.git-credentials" "https://$($env:git_key):x-oauth-basic@github.com`n"
git config --global user.email $env:build_user_email
git config --global user.name $env:build_user
git checkout master -q
Set-ChangelogFromTags
git add --intent-to-add .
git diff --quiet

if($lastexitcode -eq 1){
    git add .
    git commit -m 'Updated changelog' -q
    git push origin master -q
    if($lastexitcode -ne 0){
        Write-Error 'Changelog update failed'
    }
}
   
$latestVersion = git describe --abbrev=0
$moduleExists = Find-Module -Name GitUtils -RequiredVersion $latestVersion
if(!$moduleExists){
    Update-ModuleManifest -Path './src/GitUtils/GitUtils.psd1' -ModuleVersion $latestVersion
    Publish-Module -Path './src/GitUtils' -NuGetApiKey ${env:nuget_key}
}
