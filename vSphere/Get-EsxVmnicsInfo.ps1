[CmdletBinding()]
Param(
[Parameter(Mandatory=$True)]
[string]$vCenterServer,
[string]$Folder = [Environment]::GetFolderPath('Desktop')
)

Connect-VIServer -Server $vCenterServer
$vmnicInfo = @()
$vmHostList = Get-VMHost
$FullPath = $Folder + '\' + $vCenterServer + '.csv'
ForEach ($vmHost in $vmHostList)
    {
    $esxcli = Get-EsxCli -VMHost $vmHost.Name -Server $vCenterServer -V2
    $vmnics = $esxcli.network.nic.list.Invoke()
    $HostCluster = $vmHost.Parent
    ForEach ($vmnic in $vmnics)
        {
        $data = $esxcli.network.nic.get.Invoke(@{nicname=$vmnic.Name}).DriverInfo
        $row = '' | Select-Object HostCluster, HostName, Nic, Adapter, Driver, DriverVersion, FirmwareVersion, MTU, Speed 
        $row.HostCluster = $HostCluster.Name
        $row.HostName = $vmHost.Name
        $row.Nic = $vmnic.Name
        $row.Adapter = $vmnic.Description
        $row.Driver = $data.Driver
        $row.DriverVersion = $data.Version
        $row.FirmwareVersion = $data.FirmwareVersion
        $row.MTU = $vmnic.MTU
        if ($vmnic.Speed -gt 0)
            {
            $row.Speed = $vmnic.Speed / 1000
            }
        else
            {
            $row.Speed = 'Auto negotiate'
            }
        $vmnicInfo += $row
        }
    }
$vmnicInfo | Sort-Object HostCluster, HostName, Nic | Export-Csv $FullPath -NoTypeInformation
Disconnect-VIServer -Server $vCenterServer -Confirm:$False
