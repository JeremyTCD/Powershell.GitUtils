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

function Move-TagToHead{
	[CmdletBinding()]
	[OutputType([void])]
	param([Parameter(Mandatory=$true)][string] $tag,
		[bool] $updateRemote = $true,
		[string] $remote = 'origin')

	$message = Read-GitTagMessage $tag
	git tag -d $tag
	if($updateRemote){
		git push $remote ":refs/tags/$tag"
	}

	git tag -a $tag -m $message --cleanup=whitespace
	if($updateRemote){
		git push -f $remote $tag
	}
}