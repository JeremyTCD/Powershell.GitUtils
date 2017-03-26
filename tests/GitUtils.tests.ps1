Split-Path $PSCommandPath | Set-Location
Import-Module ("..\src\GitUtils\" + (Split-Path -Leaf $PSCommandPath).Replace(".tests.ps1", ".psd1"))

Invoke-Expression -Command "..\src\GitUtils\GitUtils.pre.ps1"

Describe "Move-TagToHead" {
	cd "TestDrive:"

	It "Moves tag to head" {
		# Arrange
		$tag = '0.1.0'
		$message = "## Title`nBody"

		git init 
		'dummy' | Out-File 'dummy.txt'
		git add .
		git commit -m 'initial commit'
		git tag -a $tag -m $message --cleanup=whitespace
		'dummy' | Out-File 'dummy.txt' -Append
		git add .
		git commit --amend --no-edit

		# Act
		Move-TagToHead $tag $false 

		# Assert
		git describe --abbrev=0 | Should Be $tag
		Read-GitTagMessage $tag | Should Be $message
	}
} 