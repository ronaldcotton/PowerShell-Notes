function Find-Type ([regex]$Pattern) {
    $TypesArr = [System.AppDomain]::CurrentDomain.GetAssemblies().GetTypes() | Select-String $Pattern
    foreach ($t in $TypesArr) {
        $t.toString().split(',')[0]
    }
}

Find-Type datetime