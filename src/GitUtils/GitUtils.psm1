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