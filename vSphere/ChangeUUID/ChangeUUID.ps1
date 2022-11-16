[CmdletBinding()]
Param(
[Parameter(Mandatory=$True)]
[string]$vCenterServer,
[string]$Path = $MyInvocation.MyCommand.Path.Replace($MyInvocation.MyCommand.Name, 'vm_list.txt') # При запуске из консоли указать полный путь до файла vm_list.txt
)

Connect-VIServer -Server $vCenterServer

$content = Get-Content Path

foreach ($vmName in $content) {
    $vm = Get-VM -Name $vmName
    $PowerState = $vm.PowerState
    $VMToolsState = $vm.Guest.State

    if ($PowerState -eq 'PoweredOn'){
        if ($VMToolsState -eq 'Running'){
        Shutdown-VMGuest -VM $vm -Confirm:$false | Out-Null
        }
        else {
            Stop-VM -VM $vm -Confirm:$false | Out-Null
        }
    }
    Write-Host 'Исходный UUID -' $vm.ExtensionData.Config.uuid '- ВМ' $vmName -ForegroundColor Gray

    $a = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()
    $b = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()
    $c = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()
    $d = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()
    $e = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()
    $f = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()
    $g = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()
    $h = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()

    $i = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()
    $j = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()
    $k = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()
    $l = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()
    $m = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()
    $n = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()
    $o = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()
    $p = ("{0:X}" -f (Get-Random -Minimum 16 -Max 255)).ToLower()
    $newUuid = "$a $b $c $d $e $f $g $h-$i $j $k $l $m $n $o $p"

    while ($PowerState -eq 'PoweredOn'){
        Start-Sleep -Seconds 2
        $PowerState = (Get-VM -Name $vmName).PowerState
    }

    $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
    $spec.uuid = $newUuid
    $vm.Extensiondata.ReconfigVM_Task($spec) | Out-Null

    $vm = Get-VM -Name $vmName
    Start-VM -VM $vm | Out-Null
    Write-Host 'Новый UUID -' $vm.ExtensionData.Config.uuid '- ВМ' $vmName -ForegroundColor Green
}

Disconnect-VIServer -Server $vCenterServer -Confirm:$False 