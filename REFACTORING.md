# JhcAdoRest Refactoring Proposal

## Goals

Refactor the module without unnecessarily breaking its existing public cmdlets:

1. Make endpoint changes and bug fixes easier to maintain.
2. Make new Azure DevOps API wrappers easier to add.
3. Remove repeated validation, authentication, URI, and request code.
4. Prefer the newest stable API version supported by each endpoint.

## Current design constraints

`JhcAdoRest.psm1` currently contains all public commands and private helpers in one file. Most `Invoke-JhcAdoRest*` functions repeat the same sequence:

1. Declare organization, project, PAT, and API version parameters.
2. Validate the same global environment values.
3. Construct an endpoint-specific URI through string concatenation.
4. Convert the secure PAT into a Basic authorization header.
5. Set `application/json`.
6. Call `Invoke-RestMethod`.

The repetition makes small fixes expensive. For example, changing credential handling, escaping query parameters, adding common HTTP error behavior, or changing a default API version requires editing many functions independently.

The module also mixes several responsibilities:

- connection configuration and interactive prompting;
- authentication;
- endpoint discovery and URL construction;
- HTTP execution;
- public cmdlet parameter handling;
- transformation of raw API responses into report objects.

The `Select-JhcAdoRest*` functions provide a useful separation between retrieval and reporting, but they are stored alongside the transport code and do not yet have isolated tests.

## Recommended target structure

Keep `JhcAdoRest.psd1` as the public module manifest and turn `JhcAdoRest.psm1` into a small loader.

```text
JhcAdoRest.psd1
JhcAdoRest.psm1
Public/
  Get-JhcAdoRestEnvironment.ps1
  Set-JhcAdoRestEnvironment.ps1
  Invoke-JhcAdoRestBuild.ps1
  Invoke-JhcAdoRestBuildDefinition.ps1
  ...
  Select-JhcAdoRestBuild.ps1
  Select-JhcAdoRestRelease.ps1
  ...
Private/
  Get-JhcAdoRestConnection.ps1
  Get-JhcAdoRestApiVersion.ps1
  New-JhcAdoRestUri.ps1
  New-JhcAdoRestAuthHeader.ps1
  Invoke-JhcAdoRestRequest.ps1
  Get-JhcAdoRestUiUri.ps1
Tests/
  Public/
  Private/
```

The module loader should dot-source private functions first and public functions second. The manifest should continue to explicitly list public functions in `FunctionsToExport`; private helpers must not be exported.

This layout makes each command independently reviewable while retaining a single installable script module.

## Centralize connection state

Replace direct reads of three unrelated global variables throughout the module with one private connection helper.

```powershell
function Get-JhcAdoRestConnection {
    [CmdletBinding()]
    param (
        [string] $Organization = $Global:JhcAdoRestOrganization,
        [string] $Project = $Global:JhcAdoRestProject,
        [securestring] $Pat = $Global:JhcAdoRestPat,
        [switch] $ProjectOptional
    )

    if (-not $Organization) {
        throw 'Organization was not found. Run Set-JhcAdoRestEnvironment.'
    }

    if (-not $ProjectOptional -and -not $Project) {
        throw 'Project was not found. Run Set-JhcAdoRestEnvironment.'
    }

    if (-not $Pat) {
        throw 'PAT was not found. Run Set-JhcAdoRestEnvironment.'
    }

    [pscustomobject]@{
        Organization = $Organization
        Project      = $Project
        Pat          = $Pat
    }
}
```

Public cmdlets can retain their current parameters and defaults for compatibility, but validation should occur once through this helper. Organization-scoped APIs, such as agent pools and tasks, can explicitly mark the project as optional instead of validating a value they do not use.

As a later compatibility-controlled improvement, connection state could move from global variables to module scope. That would avoid polluting the caller's global session, but it should be treated as a separate behavior change because scripts may currently read those global variables.

## Centralize endpoint metadata and API versions

Do not introduce one universal API version. Azure DevOps resource areas do not necessarily publish stable versions at the same time, and some operations remain preview-only.

Instead, maintain one private endpoint catalog:

```powershell
$script:JhcAdoRestEndpoints = @{
    Build = @{
        Host       = 'dev'
        Scope      = 'Project'
        Path       = '_apis/build/builds/{BuildId}'
        ApiVersion = '7.1'
        Method     = 'GET'
    }
    BuildDefinition = @{
        Host       = 'dev'
        Scope      = 'Project'
        Path       = '_apis/build/definitions/{DefinitionId}'
        ApiVersion = '7.1'
        Method     = 'GET'
    }
    Release = @{
        Host       = 'vsrm'
        Scope      = 'Project'
        Path       = '_apis/release/releases/{ReleaseId}'
        ApiVersion = '7.1'
        Method     = 'GET'
    }
    PipelinePreviewRun = @{
        Host       = 'dev'
        Scope      = 'Project'
        Path       = '_apis/pipelines/{PipelineId}/preview'
        ApiVersion = '7.1-preview.1'
        Method     = 'POST'
    }
}
```

The catalog should distinguish:

- the host family: `dev`, `vsrm`, or `almsearch`;
- project-scoped versus organization-scoped APIs;
- the relative path template;
- HTTP method;
- the newest stable API version documented for that exact operation;
- preview versions only when no stable version exposes the required feature.

Public cmdlets should keep an optional `-ApiVersion` override. If the caller does not provide it, the request helper should use the endpoint catalog value.

### API version update policy

Microsoft currently documents Azure DevOps REST API `7.1` as the latest broadly available stable version. The refactor should:

1. Inventory every operation against its Microsoft Learn reference page.
2. Change old stable defaults such as `5.0`, `6.0`, and `6.1` to `7.1` where that operation documents stable `7.1` support.
3. Replace `7.1-preview.*` or older preview defaults with stable `7.1` when the required request and response fields are available there.
4. Keep a preview version only when the operation or required feature is still preview-only.
5. Add the documentation URL and verification date as comments beside exceptional preview entries in the endpoint catalog.
6. Review the catalog periodically instead of searching all public functions for version strings.

Do not default to `7.2-preview.*` merely because it is numerically newer. The stretch goal is to expose new stable features, not to move all callers onto preview contracts.

References:

- [Azure DevOps REST API versioning](https://learn.microsoft.com/azure/devops/integrate/concepts/rest-api-versioning)
- [Azure DevOps REST API 7.1 reference](https://learn.microsoft.com/rest/api/azure/devops/)

## Introduce one request executor

All REST traffic should pass through a private `Invoke-JhcAdoRestRequest` helper. It should:

- resolve and validate connection settings;
- resolve endpoint metadata and the API version;
- create the correct host and scope prefix;
- replace escaped path parameters;
- encode query parameter names and values;
- generate the authorization header;
- serialize object request bodies with `ConvertTo-Json`;
- call `Invoke-RestMethod`;
- preserve the original exception and include method/URI context without exposing the PAT.

Suggested interface:

```powershell
Invoke-JhcAdoRestRequest `
    -Endpoint Build `
    -PathParameters @{ BuildId = $BuildId } `
    -Query @{ minTime = $MinTime; maxTime = $MaxTime; '$top' = $Top } `
    -ApiVersion $ApiVersion `
    -Organization $Organization `
    -Project $Project `
    -Pat $Pat
```

Query entries with `$null` values should be omitted. Values should be encoded with `System.Uri.EscapeDataString` or a URI builder rather than appended directly. This is particularly important for branch names, item paths, search text, project names, and other values that may contain spaces, slashes, `&`, or `+`.

POST bodies should be native PowerShell hashtables or objects:

```powershell
$body = @{
    previewRun = $true
    resources  = @{
        repositories = @{
            self = @{
                refName = "refs/heads/$RefName"
            }
        }
    }
}
```

The request executor should serialize this object. Hand-built JSON strings should be removed so escaping and optional properties are handled consistently.

## Reduce each public wrapper to endpoint-specific behavior

After extracting common behavior, a public cmdlet should primarily define its user-facing parameters and map them to an endpoint request:

```powershell
function Invoke-JhcAdoRestBuild {
    [CmdletBinding()]
    param (
        [securestring] $Pat = $Global:JhcAdoRestPat,
        [string] $BuildId,
        [string] $Organization = $Global:JhcAdoRestOrganization,
        [string] $Project = $Global:JhcAdoRestProject,
        [string] $ApiVersion
    )

    Invoke-JhcAdoRestRequest `
        -Endpoint Build `
        -PathParameters @{ BuildId = $BuildId } `
        -ApiVersion $ApiVersion `
        -Organization $Organization `
        -Project $Project `
        -Pat $Pat
}
```

Adding a new API should then require:

1. one endpoint catalog entry;
2. one small public parameter-mapping function;
3. manifest export registration;
4. request-mapping tests.

## Preserve and clarify response shaping

Keep raw API retrieval separate from reporting:

- `Invoke-JhcAdoRest*` should return the Azure DevOps response without formatting it for display.
- `Select-JhcAdoRest*` should remain pipeline-friendly transforms.
- Do not make the request executor automatically unwrap `.value`; some callers and selectors currently expect the response envelope while others operate on individual objects.

Extract repeated selector mechanics only when they have identical semantics. Property lists can be defined close to their selector, while complex release expansion should be split into focused private enumerators, for example:

- `Expand-JhcAdoRestReleaseDefinitionArtifact`;
- `Expand-JhcAdoRestReleaseDefinitionPhase`;
- `Expand-JhcAdoRestReleaseDefinitionTask`;
- `Expand-JhcAdoRestReleaseJob`.

This avoids one large nested function while keeping the public `Select-JhcAdoRestRelease*` interface stable.

When expanding nested objects, create a new output object for each artifact, phase, task, or job. Avoid repeatedly mutating and emitting the same object with `Add-Member`, which can make earlier pipeline results appear to change as later nested entries are processed.

## Add automated tests around the refactor

Introduce Pester tests before moving all endpoints. The tests should mock `Invoke-RestMethod`; they must not require a PAT or live Azure DevOps organization.

Test the private infrastructure once:

- correct host for `dev`, `vsrm`, and `almsearch`;
- inclusion or omission of the project path by endpoint scope;
- path and query escaping;
- stable catalog version selection;
- caller `-ApiVersion` override;
- GET and POST request mapping;
- JSON body serialization;
- secure PAT header generation;
- missing connection value errors;
- error context that does not expose credentials.

For each public wrapper, use focused tests that assert the endpoint name and mapped path/query/body values. For example:

```powershell
Invoke-Pester .\Tests\Public\Invoke-JhcAdoRestBuild.Tests.ps1
```

Run the full suite with:

```powershell
Invoke-Pester .\Tests
```

Add PSScriptAnalyzer settings after establishing a clean baseline. Avoid combining large structural changes with unrelated style-only fixes; otherwise the behavioral refactor will be difficult to review.

## Migration plan

### Phase 1: Safety net

- Add Pester infrastructure and mock-based characterization tests for representative APIs from each host and scope family.
- Test selectors with saved, sanitized response fixtures.
- Record the currently exported command list and parameter contracts.

### Phase 2: Shared private infrastructure

- Add the endpoint catalog, connection resolver, URI builder, authentication helper, and request executor.
- Keep existing public functions in place.
- Validate shared helpers independently.

### Phase 3: Incremental endpoint migration

- Migrate one simple GET endpoint first, such as build retrieval.
- Migrate one list endpoint with optional query parameters.
- Migrate one organization-scoped endpoint.
- Migrate one `vsrm` release endpoint.
- Migrate one POST endpoint with an object body.
- Continue by resource family after the shared design has proven stable.

Each migration should preserve the public function name, parameter names, aliases, pipeline behavior, raw response shape, and `-ApiVersion` override.

### Phase 4: Selector decomposition

- Move selectors into individual files.
- Replace mutable nested release expansion with newly created output objects.
- Extract only genuinely shared expansion helpers.

### Phase 5: Stable API version refresh

- Verify each endpoint against Microsoft Learn.
- Update the catalog to stable `7.1` where supported.
- Run response-contract tests against sanitized fixtures.
- Optionally run a separate opt-in integration test suite against a non-production Azure DevOps project.

### Phase 6: Cleanup and release

- Remove superseded request construction and old private helpers.
- Confirm `FunctionsToExport` exactly matches the intended public commands.
- Update `README.md` with installation, environment setup, and examples.
- Increment `ModuleVersion` according to compatibility impact.

## Compatibility requirements

The first refactored release should avoid changing:

- exported cmdlet names;
- existing parameter names and aliases;
- default use of `Set-JhcAdoRestEnvironment`;
- acceptance of a caller-provided secure PAT;
- the ability to override `-Organization`, `-Project`, and `-ApiVersion`;
- raw response shapes from `Invoke-*` commands;
- report shapes from `Select-*` commands, except for separately documented bug fixes.

Any correction to currently inconsistent positional parameters, response expansion, or endpoint behavior should be isolated and called out as a compatibility change rather than hidden inside the structural refactor.

## Expected outcome

The refactored module will have one implementation of connection validation, authentication, URI encoding, API version selection, JSON serialization, and REST execution. Public wrappers will become small mappings from PowerShell parameters to endpoint definitions, and selectors will remain a distinct reporting layer.

This reduces the number of places that must change for cross-cutting fixes, provides a repeatable pattern for adding APIs, and makes stable Azure DevOps API upgrades an endpoint-catalog maintenance task instead of a module-wide search-and-edit operation.
