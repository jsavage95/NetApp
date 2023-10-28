##Requires -Modules NetApp.ONTAP
#Retrieves volume iNode storage available from the Netapp Storage Controllers

Function Get-NetAppiNodes {
    
    [CmdletBinding()]
    param(
        [parameter()]
        [system.string[]]
        $NetAppController = @("ADD CONTROLLERS HERE"),

        [parameter(Mandatory = $True)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    $Counter = 0

    Foreach ($controller in $NetAppController){
        Try{
            Connect-NCController -name $controller -Credential $credential -ErrorAction Stop | out-null

        }
        Catch{
            $error[0]
            $counter++
        }
    }
    
    if ($counter -gt 1){
        Write-Error "Could not connect to any NetApp Controllers"
        break
    }
   
    Get-NcVol |
        Select-Object Name,@{Name="InodesUsed"; Expression={[math]::Round(((100*$_.FilesUsed) / $_.FilesTotal),2)}} |
            sort-object -descending InodesUsed

}




