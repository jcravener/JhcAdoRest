
if((-not $Global:JhcAdoRestOrganization) -or (-not $Global:JhcAdoRestProject) -or (-not $Global:JhcAdoRestPat)) {
    Write-Host -ForegroundColor Yellow -Object "Setting up environment for JhcAdoRest module."
}

while(-not $Global:JhcAdoRestOrganization) {
    $Global:JhcAdoRestOrganization = Read-Host -Prompt "Input your Azure DevOps Organization name"
}

while(-not $Global:JhcAdoRestProject) {
    $Global:JhcAdoRestProject = Read-Host -Prompt "Input your Azure DevOps Project name"
}

while(-not $Global:JhcAdoRestPat) {
    $Global:JhcAdoRestPat = Read-Host -Prompt "Input your Azure DevOps personal access token" -AsSecureString
}

Write-Host -ForegroundColor Green -Object "Environment is ready JhcAdoRest module."
Write-Host -ForegroundColor Green -Object "Organization: $($Global:JhcAdoRestOrganization), Project: $($Global:JhcAdoRestProject), PAT: $($Global:JhcAdoRestPat)"