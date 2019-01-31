# 2.1.4Available Types
[System.AppDomain]::CurrentDomain.GetAssemblies() # returns all the assemblies
$numOfTypes = [System.AppDomain]::CurrentDomain.GetAssemblies().GetTypes().Count
echo "`nNumber of Types: $numOfTypes"