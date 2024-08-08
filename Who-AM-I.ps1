# Get the primary network interface (associated with the default gateway)
$primaryInterface = Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null }

if ($primaryInterface) {
    # Get the primary IPv4 address
    $ipv4 = $primaryInterface.IPv4Address.IPAddress

    # Get the MAC address of the primary network interface
    $interfaceIndex = $primaryInterface.InterfaceIndex
    $mac = (Get-NetAdapter | Where-Object { $_.InterfaceIndex -eq $interfaceIndex }).MacAddress
    $computerName = $env:COMPUTERNAME
    $currentUser = $env:USERNAME


    # Display the results
    Write-Host "Computer Name: $computerName"
    Write-Host "Current User: $currentUser"
    Write-Host "IPv4 address: $ipv4"
    Write-Host "Physical address (MAC): $mac"
}
else {
    Write-Host "No primary network interface found."
}