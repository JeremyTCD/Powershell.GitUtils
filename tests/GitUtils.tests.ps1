Split-Path $PSCommandPath | Set-Location
Remove-Module GitUtils
Import-Module ("..\src\GitUtils\" + (Split-Path -Leaf $PSCommandPath).Replace(".tests.ps1", ".psd1"))

Invoke-Expression -Command "..\src\GitUtils\GitUtils.pre.ps1"

Describe "Read-TagMessage" {
	BeforeAll{
		cd $TestDrive
	}

	It "Reads tag message" {
		# Arrange
		$tag = '0.1.0'
		$message = "## Title`nBody"

		git init 
		'dummy' | Out-File 'dummy.txt'
		git add .
		git commit -m 'initial commit'
		git tag -a $tag -m $message --cleanup=whitespace

		# Act
		$result = Read-TagMessage $tag

		# Assert
		$result | Should Be $message

		cd '/'
	}
} 

Describe "Read-AllTagMessages" {
	BeforeAll{
		cd $TestDrive
	}

	It "Reads all tag messages in semver order" {
		# Arrange
		# Create tags in random order
		$tag1 = '0.1.0'
		$tag2 = '0.2.1'
		$tag3 = '0.1.1'
		$tag4 = '1.2.1'
		$expectedResult = ""

		git init 
		for($i=1; $i -le 4; $i++)
		{
			$tag = Get-Variable -Name "tag$i" -ValueOnly
			$message = "## {0}`nBody" -f $tag
			$expectedResult += $message

			'dummy' | Out-File 'dummy.txt' -Append
			git add .
			git commit -m 'dummy'
			git tag -a $tag -m $message --cleanup=whitespace
		}

		# Act
		$result = Read-AllTagMessages

		# Assert
		# Tags should be ordered according to semver, latest first
		$result | Should Be "## 1.2.1`nBody`n`n## 0.2.1`nBody`n`n## 0.1.1`nBody`n`n## 0.1.0`nBody`n"
	}
} 

Describe "Move-TagToHead" {
	BeforeAll{
		cd $TestDrive
	}

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
		Read-TagMessage $tag | Should Be $message
	}
} 