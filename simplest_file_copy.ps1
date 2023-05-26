# Define required parameters for script
param (
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateScript({Test-Path $_ -PathType Container})]
    [string]$sourceDirectory,

    [Parameter(Mandatory = $true, Position = 1)]
    [ValidateScript({Test-Path $_ -PathType Container})]
    [string]$destinationDirectory,

    [Parameter(Mandatory = $true, Position = 2)]
    [string]$filePattern
)
# Add asterisk and dot to the file pattern
$filePattern = "*.$filePattern"
$sourcePath = (Join-Path -Path $sourceDirectory -ChildPath $filePattern)

# The "action" itself
Copy-Item -Path $sourcePath -Destination $destinationDirectory
