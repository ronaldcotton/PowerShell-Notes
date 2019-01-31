# 1.4.4. Statement termination

Write-Output "Strings
can
span
multiple
lines."

# adds values
$b = $( 21 +
21 )
$b

# works not as expected
$b = $( 21
+ 21 )
$b