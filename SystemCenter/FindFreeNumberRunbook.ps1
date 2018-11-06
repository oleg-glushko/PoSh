# This SCO runbook script is based on the next article with some changes described below, prerequisites
# are installed S4B Management Tools on SCO runbook server(s) & predefined unsued numbers ranges. Also,
# you have to search for "PasteHereDistinguishedNameVariablexFromUserSearch" & replace it to the
# appropriate value from your runbook.
# https://msunified.net/2013/04/23/lync-20102013-script-to-find-available-numbers-in-a-lync-deployment/
# * I've excluded all text output as Orchestrator don't support it in PoSh scripts
# * Search range is defined by a user's OU
# * This range is customized through start, end & also excluded numbers
# * Every execution returns a random unused number
# * It's easy to issue a number & set PIN for an end-user but in my case, it wasn't required

# Phone ranges by containers 
$containers = @()
$containers +=  @{"OU"="*OU=Saints-Petersburg,OU=Company,OU=Branches,DC=your,DC=domain"; `
    "Start" = 380100; "End" = 380299; "Ex" = "380111, 380222,380290-380299"}
$containers += @{"OU"="*OU=Shushary,OU=Company,OU=Branches,DC=your,DC=domain"; `
    "Start" = 380100; "End" = 380299; "Ex" = "380111, 380222,380290-380299"}
$containers += @{"OU"="*OU=Pushkino,OU=Company,OU=Branches,DC=your,DC=domain"; `
    "Start" = 380300; "End" = 380399; "Ex" = ""}
$containers += @{"OU"="*"; "Start" = 3100; "End" = 3999; "Ex" = "3111,3222,3333,`
    3444,3555,3645,3649,3663,3666,3674,3681,3682,3689,3693,3695,3777,3800-3899,3999"}
 
Function Get-Unused {
    Param([ValidateNotNullOrEmpty()]$Unassigned)
 
    $UnassingedRun = (Get-CsUnassignedNumber $Unassigned)
 
    # The CountryCodeLength is the length of you countrycode. I recommend to leave it at zero and list the numbers as fully E.164 format.
    #If you want to remove more than 2 digits, change the $CountryCodeLength
    $CountryCodeLength = 0
    #The "tel:+" string is the +5 lenght that is added in the next line
    $CountryCodeLength = $CountryCodeLength + 5
 
    # Now we get the replace string so that all numbers can be converted to an int
    # In the norwegian case this value becomes tel:+47
    $ReplaceValue = ($UnassingedRun.NumberRangeStart).Substring(0, $CountryCodeLength)
 
    # Check to see if Unassigned Numbers are in E.164 format, if its not, continue to the next number serie
    if (($ReplaceValue.Substring(0,5)) -ne "tel:+") { Continue }
    $NumberStart = $UnassingedRun.NumberRangeStart | ForEach-Object {$_.Replace($ReplaceValue, "")}
    $NumberEnd = $UnassingedRun.NumberRangeEnd | ForEach-Object {$_.Replace($ReplaceValue, "")}
 
    # Convert the range to a Int64 to be able to manager numbers with more than 10 digits
    $NumberStartInt64 = [System.Convert]::ToInt64($NumberStart)
    $NumberEndInt64 = [System.Convert]::ToInt64($NumberEnd)
 
    # Generate the full range of a possible numbers serie
    $Ser = $Null
    $Ser = New-Object System.Collections.Arraylist
    [Void]$Ser.Add($NumberStartInt64)
    $Value=$NumberStartInt64+1
    while ($value -lt $NumberEndInt64)
    {
        [Void]$Ser.Add($value)
        $value++
    }
    [Void]$Ser.Add($value)
 
    # Get all numbers used in the solution regardless of a number range
    $ErrorActionPreference = 'SilentlyContinue'
    $Used = Get-CsUser -Filter {LineURI -ne $Null} | Select-Object LineURI | out-string -stream
    $Used += Get-CsUser -Filter {PrivateLine -ne $Null} | Select-Object PrivateLine | out-string -stream
    $Used += Get-CsAnalogDevice -Filter {LineURI -ne $Null} | Select-Object LineURI | out-string -stream
    $Used += Get-CsCommonAreaPhone -Filter {LineURI -ne $Null} | Select-Object LineURI | out-string -stream
    $Used += Get-CsExUmContact -Filter {LineURI -ne $Null} | Select-Object LineURI | out-string -stream
    $Used += Get-CsDialInConferencingAccessNumber -Filter {LineURI -ne $Null} | Select-Object LineURI | out-string -stream
    $Used += Get-CsTrustedApplicationEndpoint -Filter {LineURI -ne $Null} | Select-Object LineURI | out-string -stream
    $Used += Get-CsRgsWorkflow | Select-Object LineURI | out-string -stream
    $Used = $Used | ForEach-Object {$_.ToLower()}
    $Used = $Used | ForEach-Object {$_.Replace($ReplaceValue, "")}
    $Used = $Used | ForEach-Object {$_.split(';')[0]}
    $ErrorActionPreference = 'Continue'
 
    # Find all the numbers that are in use and part of the unassigned number serie
    $AllUsed = @()
    foreach ($Series in $Ser)
    {
        foreach($UsedNumber in $Used)
        {
            if ($Series -eq $UsedNumber) {$AllUsed+=$UsedNumber}
        }
    }
 
    #Find all the numbers that are not in use
    $ListUnUsed = @()
    $ComparisonResult=compare-object $Ser $AllUsed
    foreach ($UnUsed in $ComparisonResult)
    {
        if ($UnUsed.SideIndicator -eq '<=')
        {
            $ListUnUsed += $UnUsed.InputObject;
            $FreeSize++
        }
    }
 
    # Find how many free numbers there are in the range
    # $RangeSize = ($NumberEndInt64 - $NumberStartInt64) + 1
    # $TotalUsed = $RangeSize - $FreeSize
    # $TotalFree = $RangeSize - $TotalUsed
    $FreeSize = $NULL
 
    # Lists all the unused numbers
    Return $ListUnUsed
}
 
# Parse range & excluded numbers
foreach ($container in $containers) {
    ###### ATTENTION! You should put the user's DN variable in runbook:
    if ("PasteHereDistinguishedNameVariablexFromUserSearch" -like $container.OU) {
        $StNum = $container.Start
        $EnNum = $container.End
        $Excluded = $container.Ex -replace " ", "" -split "," | ForEach-Object {
            try
            {
                [int]$_
            }
            catch
            {
                if ($_ -match "(\d+)\-(\d+)") {$matches[1]..$matches[2]}
            }
        }
        break
    }
}

if ($StNum -gt 38000) {$UnRange = "6 Digits Numbers"} else {$UnRange = "4 Digits Numbers"}

# Try to load S4B module
Import-Module SkypeForBusiness
try {
    Get-CsWindowsService -ErrorAction stop >$null
}
catch {
    throw  ($_ | format-list * -force | out-string)
}

$AllNumbers = Get-Unused $UnRange
# Remove excluded numbers from the final list
$range = foreach ($number in $AllNumbers) {
    $flag = $false
    if ($number -lt $StNum) {continue}
    if ($number -gt $EnNum) {break}
    if ($Excluded.count -gt 0){
        foreach ($Exclude in $Excluded) {
            if ($Exclude -eq $Number) {$flag = $true;break}
        }
    }
    if (!$flag) {$number}
}

# Use this variable as a return value
$FreeNumber = if ($range.count -gt 0) {$range | get-random} else {0}