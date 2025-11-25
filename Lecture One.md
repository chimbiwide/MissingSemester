
# Lecture One: Course Overview & The Shell


Aside from the common commands used to navigate the file system such as `cd` and `ls`, there are a lot of far more interesting features of the Linux shell

#### `man`
access the manual of a specified program
e.g. `man ls`

### Connecting Programs

#### `<` and `>`

they rewire the input and output streams of a program to a file respectively

e.g. `echo hello > hello.txt`

#### `>>` appends to a file

#### `|` makes the output of one file the input of another

### The Super User (`sudo`)

one really interesting directory would the `/sys`
where you can have access to the kernel and can make changes that effect you entire computer

e.g. `/sys/class/backlight`

or 
`/sys/class/thermal/thermal_zone0/temp`
which gives you the temp of the cpu in milidegress of celcius