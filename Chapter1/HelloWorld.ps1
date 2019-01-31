# 1.2.5. Scripts and functions
# running without parameter outputs Hello World.
# running with parameter outputs "Hello" with of the first parameter.

param($name = 'World')
"Hello $name."

# you can also make a function in powershell
# function hello { param($name = 'World'); "Hello $name." }