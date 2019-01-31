## Section 1.1 What is Powershell?

command-line shell, scripting environment, automation engine - manages Microsoft-based machines and applications that programs consistency into your management process.  DevOps tool for the Microsoft Platform.

### Section 1.1.1. Shells, command lines, and scripting languages

Shells and command lines typically use a terminal like methods.  All shell scripting languages should provide Read-Eval-Print-Loop functionality.  Can shells be scripting languages? Yes (bash and Zsh are examples), allows you to utilize modules and debuggers on your scripts.

So, there's no distinction of which is a shell language and which is a scripting language.  Powershell makes tradeoffs between both paradigms to make a powerful user experience.

The Windows Management Surface simplifies the increased complexity of managing such a complex system of subsystems and features.  This led to Distributed Management Task Force (dmtf.org) to create standards like the Common Information Model (CIM) for which Microsoft's is known as Windows Management Instrumentation (WMI).

Unlike UNIX, Windows is an API-driven operating system - which means accessing properties and using methods on the appropriate object.  Because of the move from the desktop experience to the datacenter experience, GUI Administration is unable to scale and Microsoft needed Powershell to administer these large-sweeping tasks.

## 1.2 PowerShell example code

**Get-ChildItem -Path C:\example.txt** produces the same output as **dir C:\example.txt** and **ls C:\example.txt** because the alias name of the files are reserved for interactive use and the true name of the command is to be used for scripts.

Like other shell environments, you can redirect stdin and stdout into a file:

```
Get-ChildItem -Path C:\bdlog.txt > C:\foo.txt; Get-Content -Path C:\foo.txt
```



### 1.2.1. Navigation and Basic Operations

Moving around in the directory structure with with the **Set-Location** command (which **cd** is the alias of), Copying files is with the **Copy-Item** command (again with aliases called - **cp** or **copy** command), **Remove-Item** to remove files (aliases are **rm** or **del**).  As you can see, the aliases are named after the *Windows/Linux command*, and the powershell name of the command is *Verb-Noun*. (Powershell v6 Core on Linux/Mac removed the aliases so as to not interfere with the original commands, however Windows keeps those alias definitions.)

**Get-Help** will give you information about the command.  In the remarks section of the help, you will see alternate ways to get help.  Use the option to only look at certain sections of help, **-Online** for the most updated information which is previewed from the Browser.  To update **Get-Help**, use the command **Update-Help** *(perhaps case sensitive)*.

### 1.2.2. Basic Expressions and Variables

Powershell understands mathematical equations and can be saved into variables:

```
$pi = 355/113
$radius = 2
$circumference = 2 * $pi * $radius
```

Commands can also be stored into variables as collections

```
$gci = Get-ChildItem
$gci[0] # first item; $gci[1] # second item ...etc...
```



### 1.2.3. Processing Data

There is an alias for sorting called sort (by filename in reverse alphanumeric order):

```
Get-ChildItem | sort -Descending
```

The *cmdlet* of the **sort** command is **Sort-Object**, by using the Property attribute you can sort over a different field:

```
Get-ChildItem | Sort-Object -Property LastWriteTime
```

Pipelines allows:

- Accessing data elements by names versus indexes
- Operations understands the output elements.

**Selecting Properties from an Object (Select-Object)**

cmdlet allows a user to select a subrange of objects that are piped in and specify a subset.

```
$largestfile = Get-ChildItem | Sort-Object -Property length -Descending | Select-Object -First 1
```

**Select-Object** also has a **-Property** Parameter which allows you to focus on a single parameter.

**Processing with the ForEach-Object cmdlet**

```
$total = 0; Get-ChildItem | ForEach-Object {$total += $_.length}; $total
```

Counts the length of each filename returned by the Get-ChildItem command

**Processing other kinds of data**

```
Get-ChildItem | sort -Descending length | select -First 5
```

Five largest files in a directory.

```
Get-Process | sort -Descending ws | select -First 5
```

Display five of the processes with the largest working set size.  *Both of these show a command pattern that can be reused and adapted to solve similiar problems.*

### 1.2.4. Flow-Control Statements

```
$i=0; while ($i++ -lt 10) { if ($i % 2 - 1) {"$i is even"}}
foreach ($i in 1..10) { if ($i % 2 - 1) {"$i is even"}}
1..10 | foreach { if ($_ % 2 - 1) {"$_ is even"}}
```

Powershell flow-control statements printing even numbers from 1 to 10.  First is a while loop, the second is a foreach, but the first demonstrated flow control using pipelines.

*Note: **foreach** is an alias for **ForEach-Object***

### 1.2.5. Scripts and Functions

```
param($name = 'world')
"Hello $name."
```

Saving this script into a file (helloworld.ps1), and run the function, calling 

### 1.2.6 Remote Administration

ProwerShell allows remoting (remote execution capabilities).  PowerShell execution model ensures that local commands should also work remotely since v2.  The most common command being **Invoke-Command** or **icm** allows to invoke a block of PowerShell script locally, remotely, or simultaneously on multiple machines.

Installing hotfixes locally: 

```
Get-HotFix -Id KBXXXXXXX
```

When wrapped around Invoke-Command:

```
Invoke-Command -ScriptBlock {Get-HotFix -Id KBXXXXXXX} -ComputerName Win10Machine
```

To have an interactive session with a computer instead of running commands you would use Enter-PSSession:

```
Enter-PSSession -ComputerName Win10Machine
```

This will give you a PowerShell prompt on the remote machine until you run `Exit-PSSession`.

## 1.3. Core Concepts

Jim Truher and Bruce Payette deviated a mature standard known as POSIX 1003.2 which was the basis of bash and Zsh with C# syntax.  In fact, C# examples can be converted to PowerShell.

### 1.3.1. Command Concepts and Terminology

While there are some parallels with Linux shell terminology, Microsoft has many PowerShell-specific concepts.

### 1.3.2. Commands and CMDLETS

All commands are built with this format:

`verb-noun-cmdlet –switch-parameter -parameter withargument positional-argument`

A **parameter binder** matches the argument and parameter types *(and use a type converter when needed - See Chapter 2)*.

What if your string starts with a dash (-) which the **parameter binder** would mistaken as a *parameter*?  In those cases, you would put quotes around it or a double-dash:

```
Write-Output -InputObject "-InputObject"  # (as parameter withargument) or
Write-Output "-InputObject" # (as positional-argument) or
Write-Output -- -InputObject
```

A common *switch parameter* is **-Recurse** which looks at the current directory and all subdirectories under it.

```
Get-ChildItem -Recurse -Filter w*.dll C:\Windows\System32
```

**cmdlets** which use the verb-noun convention are typically known as *built-in commands* and more can be added at runtime.

**Functions**

PowerShell v2 has all the basic terminology that was mentioned above while PowerShell v3 has Workflows and PowerShell Drive (Chapter 12).

**Scripts**

**Script Command** (.ps1 extention text file) are effectively identical to running the commands interactively or running in a function.  However, it's recommended to avoid using aliases and instead using the cmdlet names when coding.

**Native Commands**

Any commands that can be processed by the operating system is known as a **native command**.  It uses the native launcher associated to the filetype. (such as `notepad.exe` to process `.\README.txt`) As long as the command is not part of a pipeline or part of a **Wait-Process**, PowerShell will continue to run the function or script while the native launcher is active.  You also have the ability to run a separate process of PowerShell from within PowerShell, which is great if you want to isolate portions of a script to a process.

```
powershell { Get-Process win* } | Format-Table CPU, ProcessName
```

For more information see Chapter 11

**Desired State Configuration**

Windows Powershell as a configuration management platform known as Desired State Configuration (DSC) which enables the management of configuration data (known as a Managed Object Format (MOF) file) for software services and the operating system environment. These can be deployed remotely.

### 1.3.4. Aliases and Elastic Syntax

Get-Command will allow you to see the real command for an aliased command and will allow you to get infromation about non-aliased commands.

```
Get-Command ls
Get-Command Get-Command
```

Avoid aliases.  Parameters aliases are created by the author of the cmdlet, script, or function and will be explained in Chapter 7.  One reason to make Parameter aliases is to have compatibly with older versions of PowerShell.

## 1.4. Parsing the PowerShell language

User types in an expression is tokenized by the parser and is converted to an internal representation, then the execution engine evaluates the parsed representation.

### 1.4.1. How PowerShell Parses

### 1.4.2. Quoting

Required when the parser may tokenize a string as a parameter or when your string contains characters like spaces.  Quotes are not required if you use the backquote character (``` ``)  to negate characters that the parser deem as not part of the string, for example:

```
Set-Location C:\Program` Files` `(x86`)
Write-Output "`$PID = $PID"
```

The backquote is also used for escape sequences like newlines, more information can be found at `Get-Help about_Escape_Characters`.

### 1.4.3. Expression-mode and command-mode parsing

