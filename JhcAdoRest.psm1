function Invoke-JhcAdoRestPipelinePreviewRun {
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [System.Security.SecureString]
        $Pat = $JhcAdoRestPat,
        [Parameter(Position = 1, Mandatory)]
        [System.String]
        $PipelineId,
        [Parameter(Position = 2, Mandatory = $false)]
        [System.String]
        $Organization = $JhcAdoRestOrganization,
        [Parameter(Position = 3, Mandatory = $false)]
        [System.String]
        $Project = $JhcAdoRestProject,
        [Parameter(Position = 4, Mandatory = $false)]
        [System.String]
        $ApiVersion = '6.1-preview.1'
    )

    begin {
        
        if (-not $Pat) {
            throw "PAT was not found. Run Set-JhcAdoRestEnvironment."
        }
        if (-not $JhcAdoRestOrganization) {
            throw "JhcAdoRestOrganization was not found. Run Set-JhcAdoRestEnvironment."
        }
        if (-not $JhcAdoRestProject) {
            throw "JhcAdoRestProject was not found. Run Set-JhcAdoRestEnvironment."
        }
        
        $uri = 'https://dev.azure.com/' + $Organization + '/' + $Project + '/_apis/pipelines/' + $PipelineId + '/preview?&api-version=' + $ApiVersion
        
        $header = PrepAdoRestApiAuthHeader -SecurePat $pat

        $body = "{
        `n  `"PreviewRun`": true
        `n}"

        $ct = 'application/json'
    }
    process {
        Invoke-RestMethod -Uri $uri -Headers $header -Method POST -Body $body -ContentType $ct
    }
    end {}

}

function Invoke-JhcAdoRestBuildDefinition {
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [System.Security.SecureString]
        $Pat = $JhcAdoRestPat,
        [Parameter(Position = 1, Mandatory = $false)]
        [System.String]
        $PipelineId,
        [Parameter(Position = 2, Mandatory = $false)]
        [System.String]
        $Organization = $JhcAdoRestOrganization,
        [Parameter(Position = 3, Mandatory = $false)]
        [System.String]
        $Project = $JhcAdoRestProject,
        [Parameter(Position = 4, Mandatory = $false)]
        [System.String]
        $ApiVersion = '6.1-preview.7'
    )

    begin {
        
        if (-not $Pat) {
            throw "PAT was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestOrganization) {
            throw "JhcAdoRestOrganization was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestProject) {
            throw "JhcAdoRestProject was not found. Run Set-JhcAdoRestEnvironment"
        }

        $uri = 'https://dev.azure.com/' + $Organization + '/' + $Project + '/_apis/build/definitions/' + $PipelineId + '?api-version=' + $ApiVersion
                
        $header = PrepAdoRestApiAuthHeader -SecurePat $pat

        $ct = 'application/json'
    }
    process {
        Invoke-RestMethod -Uri $uri -Headers $header -Method Get -ContentType $ct
    }
    end {}

}

function Invoke-JhcAdoRestBuildList {
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [System.Security.SecureString]
        $Pat = $JhcAdoRestPat,
        [Parameter(Position = 1, Mandatory = $false)]
        [System.String]
        $PipelineId,
        [Parameter(Position = 2, Mandatory = $false)]
        [System.String]
        $Top = 1,
        [Parameter(Position = 3, Mandatory = $false)]
        [System.String]
        $Organization = $JhcAdoRestOrganization,
        [Parameter(Position = 4, Mandatory = $false)]
        [System.String]
        $Project = $JhcAdoRestProject,
        [Parameter(Position = 5, Mandatory = $false)]
        [System.String]
        $ApiVersion = '6.1-preview.7'
    )

    begin {
        
        if (-not $Pat) {
            throw "PAT was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestOrganization) {
            throw "JhcAdoRestOrganization was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestProject) {
            throw "JhcAdoRestProject was not found. Run Set-JhcAdoRestEnvironment"
        }
        
        $uri = 'https://dev.azure.com/' + $Organization + '/' + $Project + '/_apis/build/builds?definitions=' + $PipelineId +  '&$top=' + $Top +  '&api-version=' + $ApiVersion
        
        $header = PrepAdoRestApiAuthHeader -SecurePat $pat

        $ct = 'application/json'
    }
    process {
        Invoke-RestMethod -Uri $uri -Headers $header -Method Get -ContentType $ct
    }
    end {}

}
function Invoke-JhcAdoRestPipeline {
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [System.Security.SecureString]
        $Pat = $JhcAdoRestPat,
        [Parameter(Position = 1, Mandatory = $false)]
        [System.String]
        $PipelineId,
        [Parameter(Position = 2, Mandatory = $false)]
        [System.String]
        $Organization = $JhcAdoRestOrganization,
        [Parameter(Position = 3, Mandatory = $false)]
        [System.String]
        $Project = $JhcAdoRestProject,
        [Parameter(Position = 4, Mandatory = $false)]
        [System.String]
        $ApiVersion = '6.0-preview.1'
    )

    begin {
        
        if (-not $Pat) {
            throw "PAT was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestOrganization) {
            throw "JhcAdoRestOrganization was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestProject) {
            throw "JhcAdoRestProject was not found. Run Set-JhcAdoRestEnvironment"
        }
        
        $uri = 'https://dev.azure.com/' + $Organization + '/' + $Project + '/_apis/pipelines/' + $PipelineId + '?api-version=' + $ApiVersion
        
        $header = PrepAdoRestApiAuthHeader -SecurePat $pat

        $ct = 'application/json'
    }
    process {
        Invoke-RestMethod -Uri $uri -Headers $header -Method Get -ContentType $ct
    }
    end {}

}

function Invoke-JhcAdoRestPipelineRuns {
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [System.Security.SecureString]
        $Pat = $JhcAdoRestPat,
        [Parameter(Position = 1, Mandatory = $true)]
        [System.String]
        $PipelineId,
        [Parameter(Position = 1, Mandatory = $false)]
        [System.String]
        $RunId,
        [Parameter(Position = 2, Mandatory = $false)]
        [System.String]
        $Organization = $JhcAdoRestOrganization,
        [Parameter(Position = 3, Mandatory = $false)]
        [System.String]
        $Project = $JhcAdoRestProject,
        [Parameter(Position = 4, Mandatory = $false)]
        [System.String]
        $ApiVersion = '6.0-preview.1'
    )

    begin {
        
        if (-not $Pat) {
            throw "PAT was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestOrganization) {
            throw "JhcAdoRestOrganization was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestProject) {
            throw "JhcAdoRestProject was not found. Run Set-JhcAdoRestEnvironment"
        }
        
        $uri = 'https://dev.azure.com/' + $Organization + '/' + $Project + '/_apis/pipelines/' + $PipelineId
        
        if ($RunId) {
            $uri += '/runs/' + $RunId + '?api-version='
        }
        else {
            $uri += '/runs?api-version='
        }

        $uri += $ApiVersion
        
        $header = PrepAdoRestApiAuthHeader -SecurePat $pat

        $ct = 'application/json'
    }
    process {
        Invoke-RestMethod -Uri $uri -Headers $header -Method Get -ContentType $ct
    }
    end {}

}


function Invoke-JhcAdoRestBuild {
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [System.Security.SecureString]
        $Pat = $JhcAdoRestPat,
        [Parameter(Position = 1, Mandatory = $false)]
        [System.String]
        $BuildId,
        [Parameter(Position = 2, Mandatory = $false)]
        [System.String]
        $Organization = $JhcAdoRestOrganization,
        [Parameter(Position = 3, Mandatory = $false)]
        [System.String]
        $Project = $JhcAdoRestProject,
        [Parameter(Position = 4, Mandatory = $false)]
        [System.String]
        $ApiVersion = '6.1-preview.7'
    )

    begin {
        
        if (-not $Pat) {
            throw "PAT was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestOrganization) {
            throw "JhcAdoRestOrganization was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestProject) {
            throw "JhcAdoRestProject was not found. Run Set-JhcAdoRestEnvironment"
        }

        
        $uri = 'https://dev.azure.com/' + $Organization + '/' + $Project + '/_apis/build/builds/' + $BuildId + '?api-version=' + $ApiVersion
        
        $header = PrepAdoRestApiAuthHeader -SecurePat $pat

        $ct = 'application/json'
    }
    process {
        Invoke-RestMethod -Uri $uri -Headers $header -Method Get -ContentType $ct
    }
    end {}

}

function Invoke-JhcAdoRestBuildTimeline {

    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [System.Security.SecureString]
        $Pat = $JhcAdoRestPat,
        [Parameter(Position = 1, Mandatory = $false)]
        [System.String]
        $BuildId,
        [Parameter(Position = 2, Mandatory = $false)]
        [System.String]
        $Organization = $JhcAdoRestOrganization,
        [Parameter(Position = 3, Mandatory = $false)]
        [System.String]
        $Project = $JhcAdoRestProject,
        [Parameter(Position = 4, Mandatory = $false)]
        [System.String]
        $ApiVersion = '7.1-preview.2'
    )

    begin {
        
        if (-not $Pat) {
            throw "PAT was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestOrganization) {
            throw "JhcAdoRestOrganization was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestProject) {
            throw "JhcAdoRestProject was not found. Run Set-JhcAdoRestEnvironment"
        }

        
        $uri = 'https://dev.azure.com/' + $Organization + '/' + $Project + '/_apis/build/builds/' + $BuildId + '/timeline/?api-version=' + $ApiVersion
        
        $header = PrepAdoRestApiAuthHeader -SecurePat $pat

        $ct = 'application/json'
    }
    process {
        Invoke-RestMethod -Uri $uri -Headers $header -Method Get -ContentType $ct
    }
    end {}
}


function Invoke-JhcAdoRestGitPullRequest {
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [System.Security.SecureString]
        $Pat = $JhcAdoRestPat,
        [Parameter(Position = 1, Mandatory)]
        [System.String]
        $RepositoryId,
        [Parameter(Position = 2, Mandatory)]
        [System.String]
        $PullRequestId,
        [Parameter(Position = 3, Mandatory = $false)]
        [System.String]
        $Organization = $JhcAdoRestOrganization,
        [Parameter(Position = 4, Mandatory = $false)]
        [System.String]
        $Project = $JhcAdoRestProject,
        [Parameter(Position = 5, Mandatory = $false)]
        [System.String]
        $ApiVersion = '6.1-preview.1'
    )

    begin {
        
        if (-not $Pat) {
            throw "PAT was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestOrganization) {
            throw "JhcAdoRestOrganization was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestProject) {
            throw "JhcAdoRestProject was not found. Run Set-JhcAdoRestEnvironment"
        }
        
        $uri = 'https://dev.azure.com/' + $Organization + '/' + $Project + '/_apis/git//repositories/' + $RepositoryId + '/pullrequests/' + $PullRequestId + '?api-version=' + $ApiVersion
        
        $header = PrepAdoRestApiAuthHeader -SecurePat $pat

        $ct = 'application/json'
    }
    process {
        Invoke-RestMethod -Uri $uri -Headers $header -Method Get -ContentType $ct
    }
    end {}

}

function Invoke-JhcAdoRestReleaseDefinition {
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [System.Security.SecureString]
        $Pat = $JhcAdoRestPat,
        [Parameter(Position = 1, Mandatory = $false)]
        [System.String]
        $DefinitionId,
        [Parameter(Position = 2, Mandatory = $false)]
        [System.String]
        $Organization = $JhcAdoRestOrganization,
        [Parameter(Position = 3, Mandatory = $false)]
        [System.String]
        $Project = $JhcAdoRestProject,
        [Parameter(Position = 4, Mandatory = $false)]
        [System.String]
        $ApiVersion = '6.0'
    )

    begin {
        
        if (-not $Pat) {
            throw "PAT was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestOrganization) {
            throw "JhcAdoRestOrganization was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestProject) {
            throw "JhcAdoRestProject was not found. Run Set-JhcAdoRestEnvironment"
        }
                
        $uri = 'https://vsrm.dev.azure.com/' + $Organization + '/' + $Project + '/_apis/release/definitions/' + $DefinitionId + '?api-version=' + $ApiVersion
        
        $header = PrepAdoRestApiAuthHeader -SecurePat $pat

        $ct = 'application/json'
    }
    process {
        Invoke-RestMethod -Uri $uri -Headers $header -Method Get -ContentType $ct
    }
    end {}

}

function Invoke-JhcAdoRestRelease {
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [System.Security.SecureString]
        $Pat = $JhcAdoRestPat,
        [Parameter(Position = 1, Mandatory = $false)]
        [System.String]
        $ReleaseId,
        [Parameter(Position = 2, Mandatory = $false)]
        [System.String]
        $Organization = $JhcAdoRestOrganization,
        [Parameter(Position = 3, Mandatory = $false)]
        [System.String]
        $Project = $JhcAdoRestProject,
        [Parameter(Position = 4, Mandatory = $false)]
        [System.String]
        $ApiVersion = '6.1-preview.8'
    )

    begin {
        
        if (-not $Pat) {
            throw "PAT was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestOrganization) {
            throw "JhcAdoRestOrganization was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestProject) {
            throw "JhcAdoRestProject was not found. Run Set-JhcAdoRestEnvironment"
        }
                
        # GET https://vsrm.dev.azure.com/{organization}/{project}/_apis/release/releases/{releaseId}?api-version=6.1-preview.8

        $uri = 'https://vsrm.dev.azure.com/' + $Organization + '/' + $Project + '/_apis/release/releases/' + $ReleaseId + '?api-version=' + $ApiVersion
        
        $header = PrepAdoRestApiAuthHeader -SecurePat $pat

        $ct = 'application/json'
    }
    process {
        Invoke-RestMethod -Uri $uri -Headers $header -Method Get -ContentType $ct
    }
    end {}
}

function Invoke-JhcAdoRestAgentQueue {
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [System.Security.SecureString]
        $Pat = $JhcAdoRestPat,
        [Parameter(Position = 1, Mandatory = $false)]
        [System.String]
        $AgentQueueId,
        [Parameter(Position = 2, Mandatory = $false)]
        [System.String]
        $Organization = $JhcAdoRestOrganization,
        [Parameter(Position = 3, Mandatory = $false)]
        [System.String]
        $Project = $JhcAdoRestProject,
        [Parameter(Position = 4, Mandatory = $false)]
        [System.String]
        $ApiVersion = '6.0-preview.1'
    )

    begin {
        
        if (-not $Pat) {
            throw "PAT was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestOrganization) {
            throw "JhcAdoRestOrganization was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestProject) {
            throw "JhcAdoRestProject was not found. Run Set-JhcAdoRestEnvironment"
        }
                
        # GET https://dev.azure.com/{organization}/{project}/_apis/distributedtask/queues?queueIds={queueIds}&api-version=6.0-preview.1

        $uri = 'https://dev.azure.com/' + $Organization + '/' + $Project + '/_apis/distributedtask/queues?queueIds=' + $AgentQueueId + '&api-version=' + $ApiVersion
        
        $header = PrepAdoRestApiAuthHeader -SecurePat $pat

        $ct = 'application/json'
    }
    process {
        Invoke-RestMethod -Uri $uri -Headers $header -Method Get -ContentType $ct
    }
    end {}
}

function Invoke-JhcAdoRestAgentPool {
    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [System.Security.SecureString]
        $Pat = $JhcAdoRestPat,
        [Parameter(Position = 1, Mandatory = $false)]
        [System.String]
        $PoolName,
        [Parameter(Position = 2, Mandatory = $false)]
        [System.String]
        $PoolId,
        [Parameter(Position = 3, Mandatory = $false)]
        [System.String]
        $Organization = $JhcAdoRestOrganization,
        [Parameter(Position = 4, Mandatory = $false)]
        [System.String]
        $ApiVersion = '6.0'
    )

    begin {
        
        if (-not $Pat) {
            throw "PAT was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestOrganization) {
            throw "JhcAdoRestOrganization was not found. Run Set-JhcAdoRestEnvironment"
        }
        if (-not $JhcAdoRestProject) {
            throw "JhcAdoRestProject was not found. Run Set-JhcAdoRestEnvironment"
        }
        
        $uri = 'https://dev.azure.com/' + $Organization + '/_apis/distributedtask/pools?'
        
        if ($PoolId) {
            # https://dev.azure.com/{organization}/_apis/distributedtask/pools?poolIds=1234&api-version=6.0
            $uri += 'poolIds=' + $PoolId
        }
        else {
            # https://dev.azure.com/{organization}/_apis/distributedtask/pools?poolName=&api-version=6.0
            $uri += 'poolName=' + $PoolName
        }

        $uri += '&api-version=' + $ApiVersion
        
        
        $header = PrepAdoRestApiAuthHeader -SecurePat $pat

        $ct = 'application/json'
    }
    process {
        Invoke-RestMethod -Uri $uri -Headers $header -Method Get -ContentType $ct
    }
    end {}
}


function Select-JhcAdoRestAgentQueue {
    
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline = $true)]
        [System.Object[]]
        $Value
    )
  
    begin {
        $p = 'id', 'name', @{n = 'poolId'; e = { $_.pool.id } }, @{n = 'poolName'; e = { $_.pool.name } }, @{n = 'poolIsHosted'; e = { $_.pool.isHosted } }, @{n = 'poolType'; e = { $_.pool.poolType } }, @{n = 'poolSize'; e = { $_.pool.size } }
    }

    process {
        foreach ($obj in $Value) {
            $obj | Select-Object -Property $p
        }
    }

    end {}
}
function Select-JhcAdoRestAgentPool {
    
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline = $true)]
        [System.Object[]]
        $Value
    )
  
    begin {
        $p = 'createdOn', 'targetSize', 'size', 'id', 'name', 'isHosted'
    }

    process {
        foreach ($obj in $Value) {
            $obj | Select-Object -Property $p
        }
    }

    end {}
}

function Select-JhcAdoRestBuildDefinition {
    
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline = $true)]
        [System.Object[]]
        $Value
    )
  
    begin {
        $p = 'id', 'createdDate', 'revision', @{n = 'authoredByuniqueName'; e = { $_.authoredBy.uniqueName } }, 'path', 'name', @{n = 'processType'; e = { $_.process.type } }, @{n = 'yamlFilename'; e = { $_.process.yamlFilename } }, @{n = 'repoName'; e = { $_.repository.name } }, @{n = 'repoBranch'; e = { $_.repository.defaultBranch } }, @{n = 'pool'; e = { $_.queue.name } }, @{n = 'uiUrl'; e = { PrepAdoUiUrl -Id $_.id -Type 'BuildDefinition' } }
    }

    process {
        foreach ($obj in $Value) {
            $obj | Select-Object -Property $p
        }
    }

    end {}
}
function Select-JhcAdoRestBuild {
    
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline = $true)]
        [System.Object[]]
        $Value
    )
  
    begin {
        $p = 'id', @{n='definitionId'; e = {$_.definition.id}}, 'buildNumber', 'status', 'result', 'startTime', @{n='requestedForName'; e = { $_.requestedFor.uniqueName }}
    }

    process {
        foreach ($obj in $Value) {
            $obj | Select-Object -Property $p
        }
    }

    end {}
}
function Select-JhcAdoRestReleaseDefinition {
    
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline = $true)]
        [System.Object[]]
        $Value,
        [Parameter(Position = 1, Mandatory = $false)]
        [switch]
        $ExpandArtifacts = $false,
        [Parameter(Position = 2, Mandatory = $false)]
        [switch]
        $ExpandPhases = $false
    )
  
    begin {
        $p = 'id', 'createdOn', 'revision', @{n = 'createdByuniqueName'; e = { $_.createdBy.uniqueName } }, 'path', 'name', @{n = 'lastReleaseId'; e = { $_.lastRelease.id } }, @{n = 'lastReleaseName'; e = { $_.lastRelease.name } }, @{n = 'lastReleaseDate'; e = { $_.lastRelease.createdOn } }, @{n = 'uiUrl'; e = { PrepAdoUiUrl -Id $_.id -Type 'ReleaseDefinition' } }
        $pp = $p + @{n = 'artifactsType'; e = { $_.artifacts.type } }, @{n = 'artifactsAlias'; e = { $_.artifacts.alias } }
    }

    process {
        foreach ($obj in $Value) {
            
            if ($ExpandArtifacts) {
                foreach ($artifact in $obj.artifacts) {
                    $obj | Select-Object -Property ($p + @{n = 'artifactType'; e = { $artifact.type } }, @{n = 'artifactAlias'; e = { $artifact.alias } }, @{n = 'artifactDefinitionId'; e = { $artifact.definitionReference.definition.id } })
                }    
            }
            elseif ($ExpandPhases) {
                foreach ($env in $obj.environments) {
                                        
                    $line = $obj | Select-Object -Property ($p + @{n = 'envId'; e = { $env.id } }, @{n = 'envName'; e = { $env.name } })

                    foreach ($phase in $env.deployPhases ) {
                        Add-Member -InputObject $line -MemberType NoteProperty -Name 'phaseId' -Value $phase.id -Force
                        Add-Member -InputObject $line -MemberType NoteProperty -Name 'phaseName' -Value $phase.name -Force
                        Add-Member -InputObject $line -MemberType NoteProperty -Name 'phaseType' -Value $phase.phaseType -Force
                        Add-Member -InputObject $line -MemberType NoteProperty -Name 'agentQueueId' -Value $phase.deploymentInput.queueId -Force
                        Add-Member -InputObject $line -MemberType NoteProperty -Name 'agentSpec' -Value $phase.deploymentInput.agentSpecification.identifier -Force
                        $line
                    }            
                }
            }
            else {
                $obj | Select-Object -Property $pp
            }
        }
    }

    end {}
}

function Select-JhcAdoRestRelease {
    
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline = $true)]
        [System.Object[]]
        $Value,
        [Parameter(Position = 1, Mandatory = $false)]
        [switch]
        $ExpandSteps = $false
    )
  
    begin {
        $p = 'id', 'createdOn', 'name', 'status', 'description', 'reason', @{n = 'createdByuniqueName'; e = { $_.createdBy.uniqueName } }, @{n = 'definitionId'; e = { $_.releaseDefinition.id } }, @{n = 'definitionName'; e = { $_.releaseDefinition.name } }, @{n = 'definitionPath'; e = { $_.releaseDefinition.path } }, @{n = 'uiUrl'; e = { PrepAdoUiUrl -Id $_.id -Type 'Release' } }
    }

    process {
        foreach ($obj in $Value) {

            if ($ExpandSteps) {
                foreach ($env in $obj.environments) {
                                        
                    $line = $obj | Select-Object -Property ($p + @{n = 'envName'; e = { $env.name } }, @{n = 'envStatus'; e = { $env.status } })

                    foreach ($phase in $env.deploySteps.releaseDeployPhases) {
                        
                        Add-Member -InputObject $line -MemberType NoteProperty -Name 'phaseId' -Value $phase.phaseId -Force
                        Add-Member -InputObject $line -MemberType NoteProperty -Name 'phaseName' -Value $phase.name -Force
                        Add-Member -InputObject $line -MemberType NoteProperty -Name 'phaseType' -Value $phase.phaseType -Force
                        Add-Member -InputObject $line -MemberType NoteProperty -Name 'phaseStatus' -Value $phase.status -Force

                        foreach ($job in $phase.deploymentJobs.job) {
                            Add-Member -InputObject $line -MemberType NoteProperty -Name 'jobId' -Value $job.id -Force
                            Add-Member -InputObject $line -MemberType NoteProperty -Name 'jobName' -Value $job.name -Force
                            Add-Member -InputObject $line -MemberType NoteProperty -Name 'jobStatus' -Value $job.status -Force
                            Add-Member -InputObject $line -MemberType NoteProperty -Name 'jobAgentName' -Value $job.agentName -Force
                            
                            $line
                        }
                    }

                }
            }
            else {
            
                $obj | Select-Object -Property $p

            }
        }
    }

    end {}
}

function Get-JhcAdoRestEnvironment {
    'JhcAdoRestOrganization', 'JhcAdoRestProject', 'JhcAdoRestPat' | ForEach-Object { Get-Variable -Name $_ }
}

function Set-JhcAdoRestEnvironment {

    param (
        [Parameter(Position = 0, Mandatory = $false)]
        [switch]
        $Reset = $false,
        [Parameter(Position = 1, Mandatory = $false)]
        [System.String]
        $AdoOrganization,
        [Parameter(Position = 2, Mandatory = $false)]
        [System.String]
        $AdoProject,
        [Parameter(Position = 3, Mandatory = $false)]
        [System.Security.SecureString]
        $AdoPat
    )

    if ($Reset) {
        Remove-Variable -Name JhcAdoRestOrganization -Scope Global
        Remove-Variable -Name JhcAdoRestProject -Scope Global
        Remove-Variable -Name JhcAdoRestPat -Scope Global
    }

    if ($AdoOrganization) {
        $Global:JhcAdoRestOrganization = $AdoOrganization
    }

    if ($AdoProject) {
        $Global:JhcAdoRestProject = $AdoProject
    }
    
    if ($AdoPat) {
        $Global:JhcAdoRestPat = $AdoPat
    }

    PrepEnv
}

function PrepEnv {

    if ((-not $Global:JhcAdoRestOrganization) -or (-not $Global:JhcAdoRestProject) -or (-not $Global:JhcAdoRestPat)) {
        Write-Host -ForegroundColor Yellow -Object "Setting up environment for JhcAdoRest module."
    }
    
    while (-not $Global:JhcAdoRestOrganization) {
        $Global:JhcAdoRestOrganization = Read-Host -Prompt "Input your Azure DevOps Organization name"
    }
    
    while (-not $Global:JhcAdoRestProject) {
        $Global:JhcAdoRestProject = Read-Host -Prompt "Input your Azure DevOps Project name"
    }
    
    while (-not $Global:JhcAdoRestPat) {
        $Global:JhcAdoRestPat = Read-Host -Prompt "Input your Azure DevOps personal access token" -AsSecureString
    }
    
    Write-Host -ForegroundColor Green -Object "Environment is ready JhcAdoRest module."
    Write-Host -ForegroundColor Green -Object "Organization: $($Global:JhcAdoRestOrganization), Project: $($Global:JhcAdoRestProject), PAT: $($Global:JhcAdoRestPat)"    
}

function PrepAdoRestApiAuthHeader {

    param (
        [Parameter(Position = 0, Mandatory)]
        [System.Security.SecureString]
        $SecurePat
    )

    if ($null -eq $SecurePat) {
        throw "Passed-in SecurePat string was null."
    }

    $pat = ''

    try {
        $us = [runtime.interopservices.Marshal]::SecureStringToGlobalAllocUnicode($SecurePat)
        $pat = [runtime.interopservices.Marshal]::PtrToStringAuto($us)
    }
    finally {
        [runtime.interopservices.Marshal]::ZeroFreeGlobalAllocUnicode($us)
    }

    $credPair = ":$($pat)"
    $encodedCred = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($credPair))
    $header = @{'Authorization' = "Basic $encodedCred" }

    return $header
}

function PrepAdoUiUrl {
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateSet('BuildDefinition', 'Build', 'ReleaseDefinition', 'Release')]
        [System.String]
        $Type,
        [Parameter(Position = 1, Mandatory)]
        [System.String]
        $Id,
        [Parameter(Position = 2, Mandatory = $false)]
        [System.String]
        $Organization = $JhcAdoRestOrganization,
        [Parameter(Position = 3, Mandatory = $false)]
        [System.String]
        $Project = $JhcAdoRestProject
    )

    $typeMap = @{ 'BuildDefinition' = '_build?definitionId'; 
        'Build'                     = '_build/results?buildId';
        'ReleaseDefinition'         = '_release?_a=releases&view=all&definitionId';
        'Release'                   = '_releaseProgress?_a=release-pipeline-progress&releaseId'
    }
    $uri = 'https://' + $Organization + '.visualstudio.com/' + $Project + '/' + $typeMap[$Type] + '=' + $Id

    return $uri
}
