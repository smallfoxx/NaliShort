using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $Redir)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

$DefaultURL = "https://www.etsy.com/shop/NalinuPink"
If ($Redir) {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext] @{
        StatusCode = [HttpStatusCode]::Redirect
        Headers = @{
            Location = $Redir.url
        }
    })
} else {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext] @{
        StatusCode = [HttpStatusCode]::Redirect
        Headers = @{
            Location = $DefaultURL
        }
    })
}

