# Define the network share path and the name of the update folder
$sharePath = '\\ms67895\netshare'
$updateFolder = 'updates'

# Get the list of updates in the update folder
$updateFiles = Get-ChildItem "$sharePath\$updateFolder"

# Define the target machine and the destination folder for the updates
$targetMachine = 'TARGET_MACHINE_NAME'
$destFolder = 'C:\temp\updates'

# Copy the updates to the target machine
New-Item -ItemType Directory -Path $destFolder -Force | Out-Null
Copy-Item $updateFiles.FullName -Destination "$targetMachine\$destFolder" -Recurse

# Install the updates on the target machine
$session = New-PSSession -ComputerName $targetMachine
Invoke-Command -Session $session -ScriptBlock {
    $updateSession = New-Object -ComObject Microsoft.Update.Session
    $updateSearcher = $updateSession.CreateUpdateSearcher()
    $criteria = "IsInstalled=0 and Type='Software'"
    $searchResult = $updateSearcher.Search($criteria)

    $updatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl
    foreach ($update in $searchResult.Updates) {
        if ($_.Title -like 'Windows Server*') {
            $updatesToInstall.Add($update) | Out-Null
        }
    }

    $downloader = $updateSession.CreateUpdateDownloader()
    $downloader.Updates = $updatesToInstall
    $downloader.Download()

    $installer = $updateSession.CreateUpdateInstaller()
    $installer.Updates = $updatesToInstall
    $installationResult = $installer.Install()

    if ($installationResult.rebootRequired) {
        Restart-Computer -Force
    }
}

# Clean up the updates on the target machine
Remove-Item -Path "$targetMachine\$destFolder" -Recurse -Force
This script first retrieves the list of updates in the "updates" folder on the network share, then copies them to the target machine and installs them using the Windows Update API. If a reboot is required after installation, the script restarts the machine. Finally, the script cleans up the updates on the target machine by deleting the destination folder.

Note that you will need to replace "TARGET_MACHINE_NAME" with the name of your target machine and update the network share path and update folder name as necessary. You may also need to run this script with administrative privileges on both the source and target machines.