#!/usr/bin/env pwsh
param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] 
    [string]$name,

    [Parameter(Mandatory = $false)] 
    [string]$port = "80"
)

Push-Location
Set-Location $name

try
{
    & docker build -t dpbevin/staticfiles-$name .
    $size = (& docker images --format "{{upper .Size}}" dpbevin/staticfiles-$name)
    $dockerId = (& docker run --rm -d -p 8088:$port dpbevin/staticfiles-$name)
    Start-Sleep -Seconds 5
    $iwrResult = Invoke-WebRequest http://localhost:8088
    & docker stop $dockerId

    Write-Host
    if ($iwrResult.StatusCode -eq 200) {
        Write-Host `Image dpbevin/staticfiles-$name is $size`
    } else {
        Write-Host "Failed to respond"
    }
}
finally
{
    Pop-Location
}
