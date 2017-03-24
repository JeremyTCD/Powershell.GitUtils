function Read-GitTagMessage{
	param([string] $tag)

	$message = git tag -l --format '%(contents)' $tag

	return $message
}

function Read-AllGitTagMessages{
	$messages = git tag -l --format '%(contents)'

	return $messages
}

function Set-ChangelogFromTags{
    '# Changelog' | Out-File 'Changelog.md'
	Read-AllGitTagMessages | Out-File 'Changelog.md' -Append 
}