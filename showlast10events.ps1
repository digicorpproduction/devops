$User = $env:USERNAME
$LogName = "Security"
$LogSource = "Microsoft Windows security auditing"

$Events = Get-WinEvent -FilterHashtable @{
    LogName = $LogName
    ProviderName = $LogSource
    UserID = $User
} -MaxEvents 10 | Select-Object TimeCreated, Message

Write-Host "Last 10 events by $User"
$Events
