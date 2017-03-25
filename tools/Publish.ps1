$directory = Split-Path $PSCommandPath 

Publish-Module `
-path $directory `
-NuGetApiKey '52ad4298-9b74-479c-ad84-1a345172c41b' 
