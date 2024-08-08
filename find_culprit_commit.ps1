$VerbosePreference = "SilentlyContinue"

# $branch = Read-Host "Enter the branch name"
# Hardcoding the branch name and location for now
$branch = 'master'
# Change to your repository directory
Set-Location -Path "D:\Code\jira-docker-7.x"

$commitAfter = Read-Host "Enter the after/top SHA-1 commit hash"
$commitBefore = Read-Host "Enter the before/bottom SHA-1 commit hash"

# Fetch the latest changes
# git fetch

$afterCommits = git log --pretty=format:"%H" master ^$commitAfter
$afterCommitArray = $afterCommits -split "`n"
$beforeCommits = git log --pretty=format:"%H" master ^$commitBefore
$beforeCommitArray = $beforeCommits -split "`n"

# remove afterCommits from beforeCommits
$CommitArray = $beforeCommitArray | Where-Object {$_ -notin $afterCommitArray}

$CommitArray = ,"New/Bad commit" + $CommitArray
# shoudl include the the first before commit
$CommitArray += $commitBefore
$CommitArray += 'Old/Good commit'

Write-Output '-------------------'
Write-Output $CommitArray
Write-Output '-------------------'

