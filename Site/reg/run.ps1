using namespace System.Net

# This is based on JavaScript / Node.js from https://stiller.blog/2020/07/build-a-custom-url-shortener-using-azure-functions-and-cosmos-db/
# Eran Stiller of Stiller on Software, "Build a Custom URL Shortener Using Azure Functions and Cosmos DB"

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$OptionalProps = @("Title","Description")
If ($Request.Body -and $Request.Body.URL -and $Request.Body.Vanity) {
    # Output data to database
    $DataOut = @{
        "id" = $Request.Body.Vanity
        "url" = $Request.Body.URL
        "lastUpdate" = Get-Date
    }
    $OptionalProps | ForEach-Object { If ($Request.Body.$_) { $DataOut.$_ = $Request.Body.$_ } }

    Push-OutputBinding -Name redir -Value $DataOut

    $Response = [HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::NoContent
    }

} Else {
    $Response = [HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::BadRequest
        Body = "You must include Vanity and URL in Body of request."
    }
}

Push-OutputBinding -Name Response -Value $Response
