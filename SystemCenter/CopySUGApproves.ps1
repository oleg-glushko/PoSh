# This script is a showcase of SCCM software update groups (SUGs) management in
# a multi-wave manner, where updates approvements are copied from one wave to the
# next instead of manually reapproving them.

# Define what target devices are (workstations or servers).
[bool]$isServer = $false

# Target wave, for workstations its value should be in the range 2-4, for
# servers only 2 (productive). Also, there's '0' for technical groups, servers -
# critical updates out of # maintenance window, workstations - reporting.
[int]$WaveNumber = 4
 
Clear-Host
$CurrentTimeStamp = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
$Divider = "<" + "-" * ($Host.ui.rawui.BufferSize.Width - 3) + ">"
 
$ToProcess = @()
 
# Workstations - 2nd wave
if (($WaveNumber -eq 2) -and ($isServer -eq $false))
{
    $ToProcess += ,@{"UpdateGroupSource"="SUP New Update - Adobe Products";
                    "UpdateGroupDestination"="SUP Test2 New Update - Adobe Products";
                    "UpdatePackageTarget"="SUP Packages - Test2 New Updates Adobe Products"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP New Update - Office 2010-2016";
                    "UpdateGroupDestination"="SUP Test2 New Update - Office 2010-2016";
                    "UpdatePackageTarget"="SUP Packages - Test2 New Updates Office 2010-2016"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP New Update - Report Viewer 2005-2010";
                    "UpdateGroupDestination"="SUP Test2 New Update - Report Viewer 2005-2010";
                    "UpdatePackageTarget"="SUP Packages - Test2 New Updates Report Viewer 2005-2010"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP New Update - Silverlight";
                    "UpdateGroupDestination"="SUP Test2 New Update - Silverlight";
                    "UpdatePackageTarget"="SUP Packages - Test2 New Updates Silverlight"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP New Update - Visual Studio 2005-2013";
                    "UpdateGroupDestination"="SUP Test2 New Update - Visual Studio 2005-2013";
                    "UpdatePackageTarget"="SUP Packages - Test2 New Updates Visual Studio 2005-2013"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP New Update - Windows 10";
                    "UpdateGroupDestination"="SUP Test2 New Update - Windows 10";
                    "UpdatePackageTarget"="SUP Packages - Test2 New Updates Windows 10"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP New Update - Windows 7";
                    "UpdateGroupDestination"="SUP Test2 New Update - Windows 7";
                    "UpdatePackageTarget"="SUP Packages - Test2 New Updates Windows 7"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP New Update - Windows 8";
                    "UpdateGroupDestination"="SUP Test2 New Update - Windows 8";
                    "UpdatePackageTarget"="SUP Packages - Test2 New Updates Windows 8"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP New Update - Windows 81";
                    "UpdateGroupDestination"="SUP Test2 New Update - Windows 81";
                    "UpdatePackageTarget"="SUP Packages - Test2 New Updates Windows 81"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP New Update - Windows 2008";
                    "UpdateGroupDestination"="SUP Intermediate Update - Windows 2008";
                    "UpdatePackageTarget"=""}
    $ToProcess += ,@{"UpdateGroupSource"="SUP New Update - Windows 2008R2-2016";
                    "UpdateGroupDestination"="SUP Intermediate Update - Windows 2008R2-2016";
                    "UpdatePackageTarget"=""}
}
 
# Workstations - 3rd wave
if (($WaveNumber -eq 3) -and ($isServer -eq $false))
{
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test2 New Update - Adobe Products";
                    "UpdateGroupDestination"="SUP Test3 New Update - Adobe Products";
                    "UpdatePackageTarget"="SUP Packages - Test3 New Updates Adobe Products"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test2 New Update - Office 2010-2016";
                    "UpdateGroupDestination"="SUP Test3 New Update - Office 2010-2016";
                    "UpdatePackageTarget"="SUP Packages - Test3 New Updates Office 2010-2016"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test2 New Update - Report Viewer 2005-2010";
                    "UpdateGroupDestination"="SUP Test3 New Update - Report Viewer 2005-2010";
                    "UpdatePackageTarget"="SUP Packages - Test3 New Updates Report Viewer 2005-2010"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test2 New Update - Silverlight";
                    "UpdateGroupDestination"="SUP Test3 New Update - Silverlight";
                    "UpdatePackageTarget"="SUP Packages - Test3 New Updates Silverlight"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test2 New Update - Visual Studio 2005-2013";
                    "UpdateGroupDestination"="SUP Test3 New Update - Visual Studio 2005-2013";
                    "UpdatePackageTarget"="SUP Packages - Test3 New Updates Visual Studio 2005-2013"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test2 New Update - Windows 10";
                    "UpdateGroupDestination"="SUP Test3 New Update - Windows 10";
                    "UpdatePackageTarget"="SUP Packages - Test3 New Updates Windows 10"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test2 New Update - Windows 7";
                    "UpdateGroupDestination"="SUP Test3 New Update - Windows 7";
                    "UpdatePackageTarget"="SUP Packages - Test3 New Updates Windows 7"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test2 New Update - Windows 8";
                    "UpdateGroupDestination"="SUP Test3 New Update - Windows 8";
                    "UpdatePackageTarget"="SUP Packages - Test3 New Updates Windows 8"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test2 New Update - Windows 81";
                    "UpdateGroupDestination"="SUP Test3 New Update - Windows 81";
                    "UpdatePackageTarget"="SUP Packages - Test3 New Updates Windows 81"}
}
 
# Workstations - 4th wave (productive)
if (($WaveNumber -eq 4) -and ($isServer -eq $false))
{
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test3 New Update - Adobe Products";
                    "UpdateGroupDestination"="SUP Update (PC) - Adobe Products";
                    "UpdatePackageTarget"="SUP Packages (PC) - Adobe Products"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test3 New Update - Office 2010-2016";
                    "UpdateGroupDestination"="SUP Update (PC) - Office 2010-2016";
                    "UpdatePackageTarget"="SUP Packages (PC) - Office 2010-2016"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test3 New Update - Report Viewer 2005-2010";
                    "UpdateGroupDestination"="SUP Update (PC) - Report Viewer 2005-2010";
                    "UpdatePackageTarget"="SUP Packages (PC) - Report Viewer 2005-2010"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test3 New Update - Silverlight";
                    "UpdateGroupDestination"="SUP Update (PC) - Silverlight";
                    "UpdatePackageTarget"="SUP Packages (PC) - Silverlight"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test3 New Update - Visual Studio 2005-2013";
                    "UpdateGroupDestination"="SUP Update (PC) - Visual Studio 2005-2013";
                    "UpdatePackageTarget"="SUP Packages (PC) - Visual Studio 2005-2013"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test3 New Update - Windows 10";
                    "UpdateGroupDestination"="SUP Update (PC) - Windows 10";
                    "UpdatePackageTarget"="SUP Packages (PC) - Windows 10"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test3 New Update - Windows 7";
                    "UpdateGroupDestination"="SUP Update (PC) - Windows 7";
                    "UpdatePackageTarget"="SUP Packages (PC) - Windows 7"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test3 New Update - Windows 8";
                    "UpdateGroupDestination"="SUP Update (PC) - Windows 8";
                    "UpdatePackageTarget"="SUP Packages (PC) - Windows 8"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test3 New Update - Windows 81";
                    "UpdateGroupDestination"="SUP Update (PC) - Windows 81";
                    "UpdatePackageTarget"="SUP Packages (PC) - Windows 81"}
}
# Servers - 2nd wave (productive)
if (($WaveNumber -eq 2) -and ($isServer -eq $true))
{
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test2 New Update - Adobe Products";
                    "UpdateGroupDestination"="SUP Update (S) - Adobe Products";
                    "UpdatePackageTarget"="SUP Packages (S) - Adobe Products"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test2 New Update - Office 2010-2016";
                    "UpdateGroupDestination"="SUP Update (S) - Office 2010-2016";
                    "UpdatePackageTarget"="SUP Packages (S) - Office 2010-2016"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test2 New Update - Report Viewer 2005-2010";
                    "UpdateGroupDestination"="SUP Update (S) - Report Viewer 2005-2010";
                    "UpdatePackageTarget"="SUP Packages (S) - Report Viewer 2005-2010"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test2 New Update - Silverlight";
                    "UpdateGroupDestination"="SUP Update (S) - Silverlight";
                    "UpdatePackageTarget"="SUP Packages (S) - Silverlight"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Test2 New Update - Visual Studio 2005-2013";
                    "UpdateGroupDestination"="SUP Update (S) - Visual Studio 2005-2013";
                    "UpdatePackageTarget"="SUP Packages (S) - Visual Studio 2005-2013"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Intermediate Update - Windows 2008";
                    "UpdateGroupDestination"="SUP Update (S) - Windows 2008";
                    "UpdatePackageTarget"="SUP Packages (S) - Windows 2008"}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Intermediate Update - Windows 2008R2-2016";
                    "UpdateGroupDestination"="SUP Update (S) - Windows 2008R2-2016";
                    "UpdatePackageTarget"="SUP Packages (S) - Windows 2008R2-2016"}
}
# Servers - critical updates
if (($WaveNumber -eq 0) -and ($isServer -eq $true))
{
    $ToProcess += ,@{"UpdateGroupSource"="";
                    "UpdateGroupDestination"="SUP Critical Windows Servers";
                    "UpdatePackageTarget"="SUP Critical Windows Server Packages"}
}
# Workstations - reporting
if (($WaveNumber -eq 0) -and ($isServer -eq $false))
{
    $ToProcess += ,@{"UpdateGroupSource"="SUP Update (PC) - Adobe Products";
                    "UpdateGroupDestination"="All Updates (Need For Reports)";
                    "UpdatePackageTarget"=""}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Update (PC) - Office 2010-2016";
                    "UpdateGroupDestination"="All Updates (Need For Reports)";
                    "UpdatePackageTarget"=""}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Update (PC) - Report Viewer 2005-2010";
                    "UpdateGroupDestination"="All Updates (Need For Reports)";
                    "UpdatePackageTarget"=""}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Update (PC) - Silverlight";
                    "UpdateGroupDestination"="All Updates (Need For Reports)";
                    "UpdatePackageTarget"=""}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Update (PC) - Visual Studio 2005-2013";
                    "UpdateGroupDestination"="All Updates (Need For Reports)";
                    "UpdatePackageTarget"=""}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Update (PC) - Windows 10";
                    "UpdateGroupDestination"="All Updates (Need For Reports)";
                    "UpdatePackageTarget"=""}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Update (PC) - Windows 7";
                    "UpdateGroupDestination"="All Updates (Need For Reports)";
                    "UpdatePackageTarget"=""}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Update (PC) - Windows 8";
                    "UpdateGroupDestination"="All Updates (Need For Reports)";
                    "UpdatePackageTarget"=""}
    $ToProcess += ,@{"UpdateGroupSource"="SUP Update (PC) - Windows 81";
                    "UpdateGroupDestination"="All Updates (Need For Reports)";
                    "UpdatePackageTarget"=""}
}
 
if ($ToProcess.count -eq 0) {
    Write-Host "Incorrect parameters" -ForegroundColor Yellow
}
else
{
    foreach ($Entry in $ToProcess) 
    {
        if ($Entry.UpdateGroupSource -ne "")
        {
            Write-Host ("Processing destination `"{0}`"" -f $Entry.UpdateGroupDestination) `
                -ForegroundColor Green
            $SUGsSource = @(Get-CMSoftwareUpdateGroup -Name $Entry.UpdateGroupSource)
            $SUGsDestination = @(Get-CMSoftwareUpdateGroup -Name $Entry.UpdateGroupDestination)

            $UpdatesInSource = $SUGsSource.Updates
            $UpdatesInDestination = $SUGsDestination.Updates
            Write-Host ("Updates count in the source group `"{0}`": {1}." `
                -f $Entry.UpdateGroupSource, $UpdatesInSource.Count)
            Write-Host ("Updates count in the destination group `"{0}`": {1}." `
                -f $Entry.UpdateGroupDestination, $UpdatesInDestination.Count)
            Write-Host $Divider -ForegroundColor DarkGray
 
            $UpdatesToRemove = $UpdatesInDestination | Where-Object {$UpdatesInSource -notcontains $_}
            Write-Host ("Updates to exclude from the destination group `"{0}`": {1}." `
                -f $Entry.UpdateGroupDestination, $UpdatesToRemove.Count)
            $UpdatesToRemove | ForEach-Object
            {
                Remove-CMSoftwareUpdateFromGroup -SoftwareUpdateId $PSItem `
                    -SoftwareUpdateGroupName $Entry.UpdateGroupDestination -Confirm:$False -Force
            }
 
            $UpdatesToAdd = $UpdatesInSource | Where-Object {$UpdatesInDestination -notcontains $_}
            Write-Host ("Updates to include in the destination group `"{0}`": {1}." `
                -f $Entry.UpdateGroupDestination, $UpdatesToAdd.Count)
            $UpdatesToAdd | ForEach-Object
            {
                Add-CMSoftwareUpdateToGroup -SoftwareUpdateId $PSItem -SoftwareUpdateGroupName `
                    $Entry.UpdateGroupDestination -Confirm:$False
            }
            Write-Host $Divider -ForegroundColor DarkGray
 
            $SUGsSource = @(Get-CMSoftwareUpdateGroup -Name $Entry.UpdateGroupSource)
            $SUGsDestination = @(Get-CMSoftwareUpdateGroup -Name $Entry.UpdateGroupDestination)
            Write-Host ("Updates count in the source group after processing `"{0}`": {1}." `
                -f $Entry.UpdateGroupSource, $SUGsSource.Updates.Count)
            Write-Host ("Updates count in the destination group after processing `"{0}`": {1}." `
                -f $Entry.UpdateGroupDestination, $SUGsDestination.Updates.Count)
            Write-Host $Divider -ForegroundColor DarkGray
        }
        else
        {
            $SUGsDestination = @(Get-CMSoftwareUpdateGroup -Name $Entry.UpdateGroupDestination)
            Write-Host ("Updates count in the group `"{0}`": {1}." -f $Entry.UpdateGroupDestination, `
                $SUGsDestination.Updates.Count)
        }
 
        if ($Entry.UpdatePackageTarget -ne "")
        {
           # Clean expired & superseded updates from the target group.
           Set-CMSoftwareUpdateDeploymentPackage -Name $Entry.UpdatePackageTarget -RemoveExpired -RemoveSuperseded
           $WarningPreferenceBackup = $WarningPreference
           $WarningPreference = 'SilentlyContinue'
           # Initiate download of required updates.
           Invoke-CMSoftwareUpdateDownload -SoftwareUpdateGroupName $Entry.UpdateGroupDestination `
                -DeploymentPackageName $Entry.UpdatePackageTarget
           $WarningPreference = $WarningPreferenceBackup
           # Update deployment's settings, some are based on target type (workstation or server)
           Set-CMSoftwareUpdateDeployment -SoftwareUpdateGroupName $Entry.UpdateGroupDestination `
                -DeploymentName $Entry.UpdateGroupDestination -TimeBasedOn LocalTime -AvailableDateTime $CurrentTimeStamp `
                -DeploymentExpireDateTime $CurrentTimeStamp -RestartServer (!$isServer) -RestartWorkstation $true `
                -SoftwareInstallation $false -DisableOperationsManagerAlert $isServer -GenerateOperationsManagerAlert $isServer
        }
    }
}