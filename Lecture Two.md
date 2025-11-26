# Lecture Two: Shell Tools and Scripting

---

Homework:

Q1:
```bash
ls -a -lt -h --color
```

Q2:

marco:
```bash
#!/bin/bash
marco() {
	export DIR="$PWD"
	echo "Exported: $DIR"
}
```

polo:
```bash
#!/bin/bash
cd "$DIR"
```

Q3:

```bash
#!/bin/bash
ranNum() {
	 n=$(( RANDOM % 100 ))
	 if [[ n -eq 42 ]]; then
	    echo "Something went wrong"
    >	&2 echo "The error was using magic numbers"
	    exit 1
	 fi
	 echo "Everything went according to plan"
 }

capture() {
	status=0
	times=0
	touch output.txt
	while ["$status" -eq 0];
	do
		output=$(ranNum 2> sterr.txt)
		status="$?"
		((time++))
		
	done
	echo "$output" >> stdout.txt
	echo "Program exectued for $time times then failed"
	echo "status code: $status"
	echo "Standard output:" 
	cat stdout.txt 
	echo 
	echo "Standard error:" 
	cat stderr.txt
}

capture
```

Q4:
```bash
find . -name "*.html" | xargs zip html.zip
```

xargs -- convert STDIN to arguments

Q5:

list newest file
```bash
find . -type f -printf '%T+ %p\n' | sort -r | head -1
```
list all files by recency
```bash
find . -type f -printf '%T+ %p\n' | sort -r
```

