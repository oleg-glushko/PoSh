<#
For the unknown reason, Skype for Bussiness is unable to fetch updated CRLs from
CA websites & don't check the validity of a certificate online through OCSP. As a
result your front-ends will generate the next warning for every 5 minutes:
Source: Windows Fabric
Event ID: 4097
Description: 1f235120: ignore error 0x80092013:certificate revocation list offline

As a workaround you can import CRLs manually into a local store, that's what this
script is intended for. Also, it's possible to disable checks at all but this leads
to the "LS:WEB – Auth Provider related calls\WEB – Failed validate cert calls to
the cert auth provider" counter to exceed the limit.
#>

Clear-Host
$servers = @("frontend1.your.domain", "frontend2.your.domain", "frontend3.your.domain")

$script = 
{
    # define your company's marker
    $MyCompanyIssuer = '*Megapolis*'
    # define your paths to recent CRLs
    $CRLURL = 'http://ca.your.domain/Path/To%20Company%20Issuing%20CA.crl'
    $DeltaCRLURL = 'http://ca.your.domain/Path/To%20Company%20Issuing%20CA1+.crl'
    $workdir = "c:\temp\"
    $certlist = &certutil -store -enterprise CA
    $now = Get-Date
    $marker = "================"
    $pattern = (Get-culture).DateTimeFormat.ShortDatePattern + " " +
        (Get-culture).DateTimeFormat.ShortTimePattern
    $CRLList = @()
    $CRL = @{}
    $is_CRL = $false


    # Parse for CRL entries from a certutil output
    for ($i=0; $i -lt $certlist.Count; $i++)
    {
        switch -Regex ($certlist[$i])
        {
            "$marker CRL (\d{1,}) $marker"
            {
                if ($is_CRL) {$CRLList += , $CRL; $CRL=@{}; }
                $is_CRL = $true
            }
            "$marker Certificate (\d{1,}) $marker"
            {
                if ($is_CRL) {$CRLList += , $CRL; $CRL=@{}; }
                $is_CRL = $false
            }
            "CertUtil: -store command completed successfully."
            {
                if ($is_CRL) {$CRLList += , $CRL; $CRL=@{}; }
                Write-Host "eof"
            }
            default {
                if ($is_CRL)
                {
                    $string = $certlist[$i] -split ': '
                    switch ($string[0])
                    {
                        "Issuer"
                        {
                            $CRL.add("Issuer", $string[1])
                        }
                        " ThisUpdate"
                        {
                            $CRL.add("ThisUpdate", [datetime]::ParseExact($string[1], $pattern, $null))
                        }
                        " NextUpdate"
                        {
                            $CRL.add("NextUpdate", [datetime]::ParseExact($string[1], $pattern, $null))
                        }
                        "CRL Entries"
                        {
                            $CRL.add("CRLEntries", $string[1])
                        }
                        "CA Version"
                        {
                            $CRL.add("CAVersion", $string[1])
                        }
                        "CRL Number"
                        {
                            $CRL.add("CRLNumber", ($string[1] -split "=")[1] -replace " ")
                        }
                        "Delta CRL Indicator"
                        {
                            $CRL.add("DeltaCRLNumber", ($string[1] -split "=")[1] -replace " ")
                        }
                        "CRL Hash(sha1)"
                        {
                            $CRL.add("CRLHash", $string[1]  -replace " ")
                        }
                    }
                }
            }
        }

    }

    # Remove expired CRLs
    $CRLList | ForEach-Object
    {
        if (($_.'NextUpdate' -lt $now) -and ($_.'Issuer' -like $MyCompanyIssuer))
        {
            &certutil -delstore -enterprise CA $_.'CRLHash'
        }
    }

    # Install fresh CRLs
    Invoke-WebRequest -Uri $CRLURL -OutFile ($workdir + "ca1.crl")
    Invoke-WebRequest -Uri $DeltaCRLURL -OutFile ($workdir + "ca1p.crl")
    &certutil -addstore -enterprise -f CA ($workdir + “ca1.crl”)
    &certutil -addstore -enterprise -f CA ($workdir + “ca1p.crl”)
    Remove-Item ($workdir + “ca1.crl”) -Force
    Remove-Item ($workdir + “ca1p.crl”) -Force
}

# Process the script on all Front-Ends
$servers | ForEach-Object
{
    Write-Host -ForegroundColor Yellow ("Processing: " + $_)
    Invoke-Command -ComputerName $_ -ScriptBlock $script
} 