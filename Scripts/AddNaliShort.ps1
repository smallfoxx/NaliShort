[cmdletbinding()]
param(
    [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
    [string]$Vanity,
    [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
    [string]$URL,
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]$Title,
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]$Description,
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]$Notes,
    [hashtable]$Properties
)

Begin {
    $AcKey = ""
    $SiteURL = ""
}

Process {
    $EntryProps=[ordered]@{
        vanity  = $Vanity
        url = $URL
    }
    If ($TItle) { $EntryProps.Title = $Title }
    If ($Description) { $EntryProps.Description = $Description }
    If ($Notes) { $EntryProps.Notes = $Notes }

    ForEach ($PropName in $Properties.Keys) {
        $EntryProps.$PropName = $Properties.$PropName
    }

    Write-Debug "Adding $Vanity to $SiteURL to $URL"

    Invoke-RestMethod -Method POST -Uri ("{0}?code={1}" -f $SiteURL,$AcKey) -ContentType "application/json" -Body ($EntryProps | ConvertTo-Json)
}
