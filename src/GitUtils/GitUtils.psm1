<# Abstraction layer for mocking #>
function Invoke-Git{
	git $args
}

function Read-TagMessage{
	[CmdletBinding()]
	[OutputType([String])]
	param([Parameter(Mandatory=$true)][string] $tag)

	$message = Invoke-Git tag -l --format '%(contents)' $tag
	# Invoke-Git tag -l returns multiline contents as an array
	# with an empty string item between each tag
	$message = $message[0..($message.Length - 2)]
	$message = $message -join "`n"

	return $message
}

function Read-AllTagMessages{
	[CmdletBinding()]
	[OutputType([String])]
	
	$messages = Invoke-Git tag --sort=-v:refname --format '%(contents)'
	$messages = $messages -join "`n"

	return $messages
}

function Set-ChangelogFromTags{
	[CmdletBinding()]
	[OutputType([void])]
	param([string] $title = 'Changelog',
		[string] $fileName = 'Changelog')

	$fileName = "$fileName.md"
	$content = "# $title`n$(Read-AllTagMessages)"
	[System.IO.File]::WriteAllLines("$(Get-Location)\$fileName", $content)
}

function Push-ChangelogFromTags{
	[CmdletBinding()]
	[OutputType([void])]
	param([string] $remote = 'origin',
		[string] $branch = 'master',
		[string] $fileName = 'Changelog',
		[string] $commitMessage = 'Updated changelog')

	Invoke-Git add --intent-to-add .
	Invoke-Git diff --quiet
	if($lastexitcode -eq 1){
		throw 'Stash or commit working directory changes'
	}

	Invoke-Git checkout $branch -q
	Set-ChangelogFromTags
	Invoke-Git add --intent-to-add .
	Invoke-Git diff --quiet

	if($lastexitcode -eq 1){
		Invoke-Git add .
		Invoke-Git commit -m $commitMessage -q
		Invoke-Git push $remote $branch -q
		if($lastexitcode -ne 0){
			Write-Error 'Unable to push new changelog to remote'
		}else{
			Write-Verbose 'New changelog pushed to remote'
		}
	}else{
		Write-Verbose 'Changelog unchanged'
	}
}