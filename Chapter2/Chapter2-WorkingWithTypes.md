# Chapter 2. Working with Types

## 2.1 Type management

Few languages are truely staticly typed (where the type of the object is explicitly stated) and instead most languages are (at least somewhat) dynamically typed, where the type of the object is inferred.

### 2.1.1. Types and classes

In object-oriented PowerShell: **Type/Class** is interchangable terms, **Property** is a single value in the Type/Class, **Method** are the behaviors/functions in the Type/Class. **Member** is either a Property or Method inside of a Type/Class, **Events** are Methods that are called indirectly by another method (think private method), **Generics** map one type to another.

### 2.1.2. PowerShell: A type-promiscuous language

Examples of PowerShells type-conversion system,

```
( 1 + 2.0 ).GetType().FullName # System.Double - with the expression value of 3
( 1 + 2.0 + '3' ).GetType().FullName # System.Double - with the expression value of 6
( 7/3 ).GetType().FullName # System.Double - with an expression value of 2.333...
( '1' + '1' ).GetType().FullName # System.String - with the expression value of "11"
( '1' + 1 ).GetType().FullName # System.String - with the expression value of 11
( 1 + '1' ).GetType().FullName # System.Int32 - with the expression value of 2
( 4/2 ).GetType().FullName # System.Int32 - with an expression value of 2
```

### 2.1.3. Type system and type adaptation

PowerShell's type systems main goal is interfacing data as many different sources, including .NET, .XML and WMI.

Member resolution has synthetic, native and fallback members.

PSObject wrapper allows you to change the set of members on that type.  You can even overwrite an existing member duing runtime, thereby changing the class behavior.  These attachements are known as singletons.  More on Chapter 10.

**Native Members**

the **Get-Member** cmdlet reveals the Members present in another cmdlet.  For example:

```
Get-Alias | Get-Member
```

Fallback members are members that are user defined.

### 2.1.4. Finding the available types

PowerShell has a pythera of types available (mostly for .NET compatibility).  For Windows machines, you can access .NET core:

```
[System.AppDomain]::CurrentDomain.GetAssemblies() # returns all the assemblies
$numOfTypes = [System.AppDomain]::CurrentDomain.GetAssemblies().GetTypes().Count
echo "`nNumber of Types: $numOfTypes"
```

The number of types are in the tens of thousands, therefore you should use a function like Find-Type to find a specific type:

```
function Find-Type ([regex]$Pattern) {
    $TypesArr = [System.AppDomain]::CurrentDomain.GetAssemblies().GetTypes() | Select-String $Pattern
    foreach ($t in $TypesArr) {
        $t.toString().split(',')[0]
    }
}

Find-Type datetime
```

## 2.2. Basic types and literals

Lterals include strings, numbers, arrays, dictionaries, and hashtables.

### 2.2.1. String literals

Recommended are single-quoted strings and here-strings, examples

```
$str1 = 'Single Quoted (double is allowed when doing variable expansion)'
$herestr1 = @'Single Quoted (double is allowed when doing variable expansion)'
```

**String representation in PowerShell**

Strings are based on .Net System.String type which is a 16-bit Unicode type allowing text to have multilingual support.

**Strings are immutable** - contents connot be changed without creating an entirely new string.  Strings may not be appended. Strings are either single or double quoted, and to add a quote in a string, you either add the quote character twice, or you use the escape character.

```
"Add double Quotes "" or `" allows string expansion like $PID"
'Add single Quotes '' only ... $PID is not expanded'
```

Allow evaluation or commands by using here-string:

```
$b = @"
42 is $(7*6)
$(Get-Date)
"@ ; $b
```

### 2.2.2. Numbers and numeric literal

| Example      | Name           | type name           |
| ------------ | -------------- | ------------------- |
| 1 or 1xFFFF  | System.Int32   | [int]               |
| 100000000000 | System.Int64   | [long]              |
| 1.1 or 1e3   | System.Double  | [double]            |
| [float]1.3   | System.Single  | [single] or [float] |
| 1d or 1.123d | System.Decimal | [decimal]           |

*Note: Single precision must be made with cast.*

Typically, you don't specify the types of the numberic literals.  The PowerShell system will parse the type depending on the input, with the only exception being decimal.

**Multiplier suffixes**

When working with power of ten types like kilo, mega, giga, tera and petabytes, you will want to utilize Multiplier Suffixes to handle these cases.  These conventions go against the ISO/IEC conventions - and instead rely on sizes that are more familiar to Computer Science Majors.  Sizes or TB and PB were introduced in PowerShell v2.

KB, MB, GB, TB, PB or (lowercase) kb, mb, gb, tb, or pb. in sizes that increase by 1024.

**Hexadecimal literals**

Start with 0x following sequences of Numbers and A-F.

## 2.3. Collections: dictionaries and hashtables

Hashtables *(System.Collections.hashtable)* allow Powershell users to map key-value pairs. A simuliar interface System.Collections.IDictionary will also work with System.Collections.Hashtable.

### 2.3.1. Creating and inspecting hashtables

```
$examplehash = @{ CompanyName = 'Microstuff'; CompanyAddress = '1010 Leet Street'; CompanyCity = 'Silicon City'; CompanyState ='CA' }; $examplehash
```

also known as

```
$examplehash = @{
CompanyName = 'Microstuff'
CompanyAddress = '1010 Leet Street'
CompanyCity = 'Silicon City'
CompanyState ='CA'
}; $examplehash
```

**Output**:

| `Key`            | `Value`            |
| ---------------- | ------------------ |
| `---`            | `-----`            |
| `CompanyName`    | `Microstuff`       |
| `CompanyAddress` | `1010 Leet Street` |
| `CompanyCity`    | `Silicon City`     |
| `CompanyState`   | `CA`               |

```
$examplehash.keys; $examplehash.CompanyName; $examplehash['CompanyAddress', 'CompanyCity', 'CompanyState']; 
```

also known as *(note: same fields but not in the same order for the values)*

```
$examplehash.Keys; $examplehash[$examplehash.Keys] # or
$examplehash.Keys; $examplehash.Values
```

**Output:**

`CompanyAddress
CompanyState
CompanyCity
CompanyName
Microstuff
1010 Leet Street
Silicon City
CA`

**Note:**

Use Sort-Object to set the ordering of the keys; all keys expect type string.

###  A Digression: Sorting, Enumerating, and Hashtables

To loop though a hashtable, you must use an enumerator to do so, so for example:

```
$ascii = @{ 'a' = [byte][char]'a'; 'b' = [byte][char]'b'; 'c' = [byte][char]'c'; }
ForEach ($a in $ascii.GetEnumerator()) { $a.key + ' = ' + $a.value }
```

### 2.3.2. Ordered Hashtables

