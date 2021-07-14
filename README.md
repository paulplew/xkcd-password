# Password Generator using the XKCD Method
Read more about the [XKCD Password Generator](https://xkcd.com/936/).

## Examples
1. Basic Generation
``` Bash
$ ./xkcd.sh
eleventhsavagingballroomcrevices
```
2. using `-w` flag
``` Bash
$ ./xkcd.sh -w 10
floppygruesomelyexperiencestrutsocksmiserlinessutteredvibratedfamousframed
```
3. using `-c` flag
``` Bash
./xkcd.sh -c 2
UnderfundingstylisedChaperonedoverpressure
```
4. using the `-n` flag
``` Bash
./xkcd.sh -n 15
5literaturespromulgate2expressionists83ambushed4
```
5. using the `-s` flag
``` Bash
./xkcd.sh -s 5
;informing$;splittabledemographers.layoff%
```

## Usage
Flags:
- `-w $NUMBER` include $NUMBER words in the password
- `-c $NUMBER` capitalize the given number of words
- `-n $NUMBER` insert $NUMBER random digits in the password
- `-s $NUMBER` insert $NUMBER random symbols in the password
- `--wordlist /path/to/wordlist` specify a custom wordlist   
  
run the program with the `-h` flag for more info

## Requirements
1. Bash 4.X.X or greater
2. GNU Core Utils

###### Coded with love in Bash by Paul Plew
