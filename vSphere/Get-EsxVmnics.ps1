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
ForEach ($vmHost in $vmHostList){
    $esxcli = Get-EsxCli -VMHost $vmHost.Name -Server $vCenterServer -V2
    $vmnics = $esxcli.network.nic.list.Invoke()
    $HostCluster = $vmHost.Parent
    ForEach ($vmnic in $vmnics){
        $data = $esxcli.network.nic.get.Invoke(@{nicname=$vmnic.Name}).DriverInfo
        Try{
            $data2 = $esxcli.network.nic.ring.current.get.Invoke(@{nicname=$vmnic.Name})
        }
        Catch{
            $row.RX = 'Information is not available'
            $row.TX = 'Information is not available'
        }
        $data3 = $esxcli.network.nic.stats.get.Invoke(@{nicname=$vmnic.Name})
        $row = '' | Select-Object HostCluster, HostName, Nic, Adapter, Driver, DriverVersion, FirmwareVersion, MTU, Speed, RX, TX, Receivepacketsdropped, Transmitpacketsdropped, Totalreceiveerrors, Totaltransmiterrors
        $row.HostCluster = $HostCluster.Name
        $row.HostName = $vmHost.Name
        $row.Nic = $vmnic.Name
        $row.Adapter = $vmnic.Description
        $row.Driver = $data.Driver
        $row.DriverVersion = $data.Version
        $row.FirmwareVersion = $data.FirmwareVersion
        $row.MTU = $vmnic.MTU
        if ($vmnic.Speed -gt 0){
            $row.Speed = $vmnic.Speed / 1000
        }
        else{
            $row.Speed = 'Auto negotiate'
        }
        $row.RX = $data2.RX
        $row.TX = $data2.TX
        $row.Receivepacketsdropped = $data3.Receivepacketsdropped
        $row.Transmitpacketsdropped = $data3.Transmitpacketsdropped
        $row.Totalreceiveerrors = $data3.Totalreceiveerrors
        $row.Totaltransmiterrors = $data3.Totaltransmiterrors
        $vmnicInfo += $row
    }
}
$vmnicInfo | Sort-Object HostCluster, HostName, Nic | Export-Csv $FullPath -Delimiter ";" -NoTypeInformation
Disconnect-VIServer -Server $vCenterServer -Confirm:$False
