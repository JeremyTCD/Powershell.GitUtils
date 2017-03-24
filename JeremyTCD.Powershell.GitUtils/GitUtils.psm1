function Read-GitTagMessage{
	param([string] $tag)

	$message = (git tag -l --format '%(contents)' $tag)[0]
	return $message
}

function Read-AllGitTagMessages{
	$messages = (git tag -l --format '%(contents)')[0]
	return $messages
}