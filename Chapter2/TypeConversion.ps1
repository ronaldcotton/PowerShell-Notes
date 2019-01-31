# 2.1.2. PowerShell: A type-promiscuous language

( 1 + 2.0 ).GetType().FullName # System.Double - with the expression value of 3
( 1 + 2.0 + '3' ).GetType().FullName # System.Double - with the expression value of 6
( 7/3 ).GetType().FullName # System.Double - with an expression value of 2.333...
( '1' + '1' ).GetType().FullName # System.String - with the expression value of "11"
( '1' + 1 ).GetType().FullName # System.String - with the expression value of 11
( 1 + '1' ).GetType().FullName # System.Int32 - with the expression value of 2
( 4/2 ).GetType().FullName # System.Int32 - with an expression value of 2