<#
A Skype for Business' built-in logging service is able to save a history
of logs on a network destination (SMB folder). But it doesn't offer any
kind of control of a usage capacity for this mechanism, so data will be
written until all free space is filled. It just assumes that a sysadmin
should decide which data should be stored and/or deleted. This script is
intended to automate a retention of old logs if the threshold of a free
space in % is reached. The script parses all files in targeted directories
by iterations, cleaning oldest ones from one or more folders, trying to
equalize their content by available dates. This process is repeated by
iterations until total files size is lower or equal the threshold.
#>

# Init variables
$UsedSize = 0
$BaseDate = [datetime]0
$CleanedSize = 0
$Files = @()
$CurrSet = @()
 
# Constants
$Threshold = 80 # in percents of a used disk space
$Precision = @("Year", "Month", "Day", "Hour", "Minute")
$DrvLetter = "D" # disk drive's letter where all logs are stored
$LogRegExp = "CLS_WPP_(\d{2}\-\d{2}\-\d{4}\-\d{2}\-\d{2}\-\d{2})"
$LogFilter = "CLS_WPP*"
# Logs folders to be 'equally' cleaned, define your paths
$Dirs2Clean = @()
$Dirs2Clean += , "${DrvLetter}:\AlwaysOn\pool.name\node1.name"
$Dirs2Clean += , "${DrvLetter}:\AlwaysOn\pool.name\node2.name"
$Dirs2Clean += , "${DrvLetter}:\AlwaysOn\pool.name\node3.name"
 
# Precalculated values
$DrvSize = (Get-Partition -DriveLetter $DrvLetter).size
$DrvLimit = [math]::round($DrvSize / 100 * $Threshold, 0)

 
# Function for comparing two variables of a datetime type with the $Precision
function Compare-TrimmedDates {
param (
    [datetime]$FirstDate,
    [datetime]$LastDate
)
$equals = $false
Foreach ($measure in $precision)
{
    $equals = $FirstDate.($measure) -eq $LastDate.($measure)
    if (!$equals) {Break}
}
    return $equals
}
 
# Collect lists of files to the array, also count their total size
for ($j = 0; $j -lt $Dirs2Clean.Count; $j++)
{
    $Files += , (Get-ChildItem -Path $Dirs2Clean[$j] -Filter $LogFilter | `
        Sort-Object Name)
    $Files[$j] | % {$UsedSize += $_.length}
    # For every processes folder make a hashtable, store them all in the
    # $CurrSet hashtable
    $Set = @{"Increment" = 0; "DateTime" = [datetime]0; "CacheHdr" = $false;
        "Consider" = $false}
    $CurrSet += , $Set
}
 
# If the quota is exceeded then run the cleanup process
if ($UsedSize -ge $DrvLimit) {
 
    $Size2Clean = $UsedSize - $DrvLimit
 
    # Repeat iteration until collected files' size is greater or equal the
    # cleanup threshold
    while ($CleanedSize -lt $Size2Clean) {
       # From every processed folder collect a metadata of files up to the
       # increment index
       for ($j = 0; $j -lt $Files.count; $j++)
       {
           $Files[$j][$CurrSet[$j].Increment].BaseName -match $LogRegExp | Out-Null
           
           if (($CurrSet[$j].Increment+1) -lt ($Files[$j].count - 1))
           {
              if (($Files[$j][$CurrSet[$j].Increment].BaseName) -eq `
                ($Files[$j][$CurrSet[$j].Increment+1].BaseName))
              {
                $CurrSet[$j].Set_Item("CacheHdr", $true)
              }
              ($Files[$j][$CurrSet[$j].Increment].BaseName) -eq
                ($Files[$j][$CurrSet[$j].Increment+1].BaseName)
           }

           $ThisDate = [datetime]::ParseExact($Matches[1],'MM-dd-yyyy-HH-mm-ss', `
            [Globalization.CultureInfo]::InvariantCulture)
          
            # Define the baseline (minimal) date, which will be compared in this
           # iteration with every single file
           if ($BaseDate -ne [datetime]0)
           {
                if (!(Compare-TrimmedDates -FirstDate $ThisDate -LastDate $BaseDate) `
                 -and ($ThisDate -lt $BaseDate)) {$BaseDate = $ThisDate}
           }
           else 
           {
               $BaseDate = $ThisDate
           }

           $CurrSet[$j].Set_Item("DateTime", $ThisDate)
        }
 
        # Compare files' dates with the baseline, defining a deletion flag for
        # this iteration
        for ($j = 0; $j -lt $CurrSet.count; $j++)
        {
            if ($(Compare-TrimmedDates -FirstDate $($CurrSet[$j].DateTime) `
            -LastDate $BaseDate))
            {
                $CleanedSize += $Files[$j][$CurrSet[$j].Increment].Length

                if ($($CurrSet[$j].CacheHdr))
                {
                    $CleanedSize += $Files[$j][$CurrSet[$j].Increment + 1].Length
                }

                $increment = 0
                $increment = $CurrSet[$j].Increment + 1 + [int]$CurrSet[$j].CacheHdr
                $CurrSet[$j].Set_Item("Increment", $increment)
            }

            $CurrSet[$j].Set_Item("CacheHdr", $false)
        }
 
        $BaseDate = [datetime]0
    }
    # Remove files according to the list gathered by the script
    for ($i = 0; $i -lt $CurrSet.count; $i++)
    {
        for ($j = 0; $j -lt $CurrSet[$i].Increment; $j++)
        {
            Remove-Item "$($files[$i][$j].fullname)" -Force
        }
    }
    
}