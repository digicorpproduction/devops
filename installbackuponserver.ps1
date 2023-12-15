# Define variables
$serverName = "ms67099.mycompany.com"
$backupLocation = "\\mycompany\hgt\rare\rare\backup\" + $serverName + "_BackupFolder"

# Install all configurations using Import-Clixml cmdlet
Import-Clixml -Path "$backupLocation\AllConfigurations.xml" | Set-Item WSMan:\localhost\*

# Install all Event Logs using Import-Csv cmdlet
Import-Csv "$backupLocation\EventLogs.csv" | ForEach-Object { Write-EventLog -LogName $_.Log -Source $_.Source -EntryType $_.EntryType -EventId $_.EventID -Message $_.Message }

# Install all IIS website configurations using Import-IISConfiguration cmdlet
Import-IISConfiguration -PhysicalPath "IIS:\Sites" -SourcePath "$backupLocation\IISConfig.zip"

# Display message when installation is complete
Write-Host "Installation complete."
