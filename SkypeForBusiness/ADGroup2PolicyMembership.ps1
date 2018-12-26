# This script shows how to synchronize external/mobile policies access rights
# synchronization to an AD groups membership, as described below:
# * S4B_External_External - allows to connect out of the company's network (e.g.
#    from a home or hotel), from PC & mobile devices;
# * S4B_External_Skype - allows to contact with a consumer Skype' agents, but
#    only if a latter have a Skype ID account linked to a Microsoft account.
# * S4B_External_Full — both previously mentioned permissions.

# Policy/Group order in the next array defines a priority, earlier is higher,
# i.e. if a user is in first & second groups, rights granted only by the first one.
$groups = @(("enable_full_access", "S4B_External_Full"), `
    ("enable_skype_access", "S4B_External_Skype"), `
    ("enable_external_access", "S4B_External_External"))
 
# Function to test if the record is in the 2D array.
function Test-InArray ($array, $value, $column = 0)
{
    for ($j=0; $j -lt $array.count; $j++) 
    {
        if ($array[$j][$column] -eq $value)
        {
            return $true
        }
    }
	return $false
}
 
# Function to find an entry in the 2D array & return its type.
function Find-InArray ($array, $value, $column = 0, $retcolumn = 0) {
    for ($j=0; $j -lt $array.count; $j++)
    {
        if ($array[$j][$column] -eq $value)
        {
            return $array[$j][$retcolumn]
        }
    }
	return $null
}
 
# List of users who don't have the 'Global' external access policy.
$polusers = @()
get-csuser | Where-Object {$_.externalaccesspolicy -ne $null} | ForEach-Object
{
    $polusers += , ($_.Identity.DistinguishedName, $_.externalaccesspolicy.friendlyname)
}
 
# List of users from specified AD groups, if a user is a member of more than one he'll be
# counted in a most prioritized.
$adusers = @()
for ($i=0; $i -lt $groups.count; $i++)
{
	$ADGroup = $groups[$i][1]
    Get-ADGroupMember -Identity $ADGroup | ForEach-Object
    {
        if (!$(Test-InArray -array $adusers -value $_.distinguishedname))
        {
			$adusers += , ($_.distinguishedname, $groups[$i][0])
		}
	}
}
 
# Get users to the change list.
$modusers = @()
 
$polusers | ForEach-Object
{
	# Those who aren't in AD groups (reset policy to Global)
    if (!$(Test-InArray -array $adusers -value $_[0]))
    {
		$modusers += , ($_[0], $null)
    }
    else
    {
        # Those who are in AD groups but with a policy other than a priority group.
		$adpolicy = Find-InArray -array $adusers -value $_[0] -retcolumn 1
        if ($adpolicy -ne $_[1])
        {
            $modusers += , ($_[0], $adpolicy)
        }
	}
}
 
$adusers | ForEach-Object
{
	# Those who are in AD groups but with the 'Global' policy.
    if (!$(Test-InArray -array $polusers -value $_[0]))
    {
		$modusers += , ($_[0], $_[1])
	}
}

# Change an external access policy.
$modusers | ForEach-Object
{
    Get-CSUser -identity $_[0] | Grant-CSExternalAccessPolicy -PolicyName $_[1]
} 
 
# The list of users with a mobile access policy other than 'Global'.
$polusersM = @()
get-csuser | Where-Object {$_.mobilitypolicy -ne $null} | ForEach-Object
{
    $polusersM += , ($_.Identity.DistinguishedName, $_.mobilitypolicy.friendlyname)
}
 
# Get users to the change list.
$modusersM = @()
 
$polusersM | ForEach-Object
{
	# Those who aren't in AD groups (reset policy to Global)
    if (!$(Test-InArray -array $adusers -value $_[0]))
    {
		$modusersM += , ($_[0], $null)
    }
    else
    {
        # Those who are in AD groups but with a policy without an externall access
		$adpolicy = Find-InArray -array $adusers -value $_[0] -retcolumn 1
        if ($adpolicy -eq "enable_skype_access")
        {
            $modusersM += , ($_[0], $null)
        }
    }
}
 
$adusers | ForEach-Object
{
	# Those who are in AD groups but with the 'Global' policy
    if (!$(Test-InArray -array $polusersM -value $_[0]))
    {
		$modusersM += , ($_[0], "enable_external_mobile_access")
	}
}
 
# Change an mobile access policy
$modusersM | ForEach-Object
{
    Get-CSUser -identity $_[0] | Grant-CSMobilityPolicy -PolicyName $_[1]
}

# Remove a users' duplicate membership from AD groups
$tempusers = @()
$groups | ForEach-Object
{
    $tempgroup = $_[1]
    get-adgroupmember -identity ($_[1]) | ForEach-Object
    {
        if ($_.distinguishedName -notin $tempusers)
        {
            $tempusers +=, $_.distinguishedName
        }
        else
        {
            Remove-AdGroupMember -Identity $tempgroup -Members $_.distinguishedName -confirm:$false
        }
    }
}