function Read-GitTagMessage{
	[CmdletBinding()]
	[OutputType([String])]
	param([Parameter(Mandatory=$true)][string] $tag)

	$message = git tag -l --format '%(contents)' $tag

	return $message
}

function Read-AllGitTagMessages{
	[CmdletBinding()]
	[OutputType([String])]
	
	$messages = git tag -l --format '%(contents)'
	 
	return $messages
}

function Set-ChangelogFromTags{
	[CmdletBinding()]
	[OutputType([void])]
	param([string] $title = 'Changelog',
		[string] $fileName = 'Changelog')

	$fileName = "$fileName.md"
	"# $title"  | Out-File $fileName -Encoding utf8
	Read-AllGitTagMessages | Out-File $fileName -Append -Encoding utf8
}