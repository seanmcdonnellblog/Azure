$vms = get-AzVM

$AllEncryption = @()
foreach($vm in $vms){
  $encryption = Get-AzVMDiskEncryptionStatus -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name
  $AllEncryption += $encryption |select @{Name="VM Name";expression={$vm.Name}},`
    @{Name="ResourceGroup Name";expression={$vm.ResourceGroupName}},`
    @{Name="OsVolume ";expression={$_.OsVolumeEncrypted }},`
    @{Name="DataVolumes";expression={$_.DataVolumesEncrypted}},`
    @{Name="Key URL";expression={$_.OsVolumeEncryptionSettings.KeyEncryptionKey.KeyUrl}},`
    @{Name="Key Vault";expression={$_.OsVolumeEncryptionSettings.KeyEncryptionKey.SourceVault.Id.split("/")[8]}},`
    @{Name="SecretURL";expression={$_.OsVolumeEncryptionSettings.DiskEncryptionKey.SecretUrl}},`
    @{Name="Secret Vault";expression={$_.OsVolumeEncryptionSettings.DiskEncryptionKey.SourceVault.id.split("/")[8]}}
    $encryption = ""
}


$AllEncryption
