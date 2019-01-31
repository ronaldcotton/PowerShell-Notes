# Chapter 1. Welcome to PowerShell
([xml] [System.Net.WebClient]::new().
    DownloadString('http://blogs.msdn.com/powershell/rss.aspx')).
        RSS.Channel.Item | Format-Table title,link