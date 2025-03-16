param (
    [switch]$n
)

$yamlFile = "ZTeraMax/config.yml"

if (-Not (Test-Path $yamlFile)) {
    Write-Host "$yamlFile doesn't exist!" -ForegroundColor Red
    exit 1
}

$content = Get-Content $yamlFile -Raw
$regex = 'version:\s*(\d+)\.(\d+)\.(\d+)'
$match = [regex]::Match($content, $regex)

if (-Not $match.Success) {
    Write-Host "Didn't find version!" -ForegroundColor Red
    exit 1
}

$major, $minor, $build = $match.Groups[1..3].Value

if ($n) {
    $minor = [int]$minor + 1
    $build = 0
} else {
    $build = [int]$build + 1
}
$newVersion = "version: $major.$minor.$build"
$newVersionContent = [regex]::Replace($content, $regex, $newVersion)

Set-Content -Path $yamlFile -Value $newVersionContent -NoNewLine
Write-Host "Version updated to $major.$minor.$build" -ForegroundColor Green

Set-Location ..
Write-Host "Building..."
cmd.exe /c "call ./psdk --util=plugin build ZTeraMax"
cmd.exe /c "call ./psdk --util=plugin load"
cmd.exe /c "call ./psdk debug skip_title"
Set-Location ./scripts
