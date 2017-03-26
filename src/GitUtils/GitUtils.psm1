function Read-GitTagMessage{
	[CmdletBinding()]
	[OutputType([String])]
	param([Parameter(Mandatory=$true)][string] $tag)

	$message = git tag -l --format '%(contents)' $tag
	# git tag -l returns multiline contents as an array
	# with an empty string item between each tag
	$message = $message[0..($message.Length - 2)]
	$message = $message -join "`n"

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