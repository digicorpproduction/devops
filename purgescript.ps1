$LogPath = "C:/users/cedney/desktop"
$maxDaystoKeep = -30

$itemsToDelete = Get-ChildItem $LogPath -Recurse -File *.png | Where-Object LastWriteTime -lt ((get-date).AddDays($maxDaystoKeep))

if ($itemsToDelete.Count -gt 0){
    ForEach ($item in $itemsToDelete){
       Get-item $item.FullName | Remove-Item
    }

}