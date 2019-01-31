# 1.2. PowerShell example code
Get-Help Get-ChildItem > C:\example.txt
Get-ChildItem -Path C:\example.txt
Get-ChildItem -Path C:\example.txt > c:\foobar.txt
Get-Content -Path C:\foobar.txt

Remove-Item C:\example.txt
Remove-Item C:\foobar.txt