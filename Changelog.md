# Changelog
## 0.4.0

#### Changes
- [Set-ChangelogFromTags](https://github.com/JeremyTCD/Powershell.GitUtils#set-changelog-from-tags) no longer prefixes output text with
a byte order mark.

## 0.3.0

#### Changes
- Renamed Read-AllGitTagMessages to [Read-AllTagMessages](https://github.com/JeremyTCD/Powershell.GitUtils#read-all-tag-messages)
- Renamed Read-GitTagMessage to [Read-TagMessage](https://github.com/JeremyTCD/Powershell.GitUtils#read-tag-message)
- [Read-AllTagMessages](https://github.com/JeremyTCD/Powershell.GitUtils#read-all-tag-messages) now sorts messages by
[semver](http://semver.org/), latest first.
- [Set-ChangelogFromTags](https://github.com/JeremyTCD/Powershell.GitUtils#set-changelog-from-tags) now lists messages by
[semver](http://semver.org/), latest first.

## 0.2.0

#### Additions
- Added function [Move-TagToHead](https://github.com/JeremyTCD/Powershell.GitUtils#move-tag-to-head)

#### Fixes
- Fixed [Read-GitTagMessage](https://github.com/JeremyTCD/Powershell.GitUtils#read-git-tag-message) not handling multiline messages properly

∩╗┐## 0.1.0

Initial release

