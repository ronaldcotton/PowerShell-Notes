# 1.6.1. Formatting cmdlets
Get-Item C:\Windows | Format-Table
Get-Item C:\Windows | Format-Table -Autosize # fits nicely on console
Get-Item C:\Windows | Format-Wide
Get-Item C:\Windows | Format-Custom -Depth 1 # returns PS1XML file - params can make output diff
Get-Item C:\Windows | Format-List