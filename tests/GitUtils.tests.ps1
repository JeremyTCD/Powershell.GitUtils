$location = Get-Location
Remove-Module GitUtils
Import-Module (".\src\GitUtils\" + (Split-Path -Leaf $PSCommandPath).Replace(".tests.ps1", ".psd1"))

Invoke-Expression -Command ".\src\GitUtils\GitUtils.pre.ps1"

Describe "Read-TagMessage" {
	BeforeAll{
		cd $TestDrive
	}
	AfterAll{
		cd $location
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
	}
} 

Describe "Read-AllTagMessages" {
	BeforeAll{
		cd $TestDrive
	}
	AfterAll{
		cd $location
	}

	It "Reads all tag messages in semver order" {
		# Arrange
		# Create tags in random order
		$tag1 = '0.1.0'
		$tag2 = '0.2.1'
		$tag3 = '0.1.1'
		$tag4 = '1.2.1'

		git init 
		for($i=1; $i -le 4; $i++)
		{
			$tag = Get-Variable -Name "tag$i" -ValueOnly
			$message = "## {0}`nBody" -f $tag

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

Describe "Set-ChangelogFromTags" {
	BeforeAll{
		cd $TestDrive
	}
	AfterAll{
		cd $location
	}

	It "Generates changelog" {
		# Arrange
		# Create tags in random order
		$tag1 = '0.1.0'
		$tag2 = '0.2.1'
		$tag3 = '0.1.1'
		$tag4 = '1.2.1'

		git init 
		for($i=1; $i -le 4; $i++)
		{
			$tag = Get-Variable -Name "tag$i" -ValueOnly
			$message = "## {0}`nBody" -f $tag

			'dummy' | Out-File 'dummy.txt' -Append
			git add .
			git commit -m 'dummy'
			git tag -a $tag -m $message --cleanup=whitespace
		}

		# Act
		Set-ChangelogFromTags

		# Assert
		# Tags should be ordered according to semver, latest first
		[IO.File]::ReadAllText("$(Get-Location)\Changelog.md") | Should Be "# Changelog`n## 1.2.1`nBody`n`n## 0.2.1`nBody`n`n## 0.1.1`nBody`n`n## 0.1.0`nBody`n`r`n"
	}
}

Describe "Push-ChangelogFromTags" {
	BeforeAll{
		cd $TestDrive
	}
	AfterAll{
		cd $location
	}

	It "Generates commit and pushes it to remote" {
		# Arrange
		Mock -ModuleName GitUtils Invoke-Git -Verifiable -ParameterFilter{
			$args[0] -eq 'push' -and `
		    $args[1] -eq 'origin' -and `
			$args[2] -eq 'master'
		} 
		git init 
		'dummy' | Out-File 'dummy.txt' -Append
		git add .
		git commit -m 'dummy'
		git tag -a '0.1.0' -m 'test message'

		# Act
		Push-ChangelogFromTags

		# Assert
		Assert-VerifiableMocks
	}
}