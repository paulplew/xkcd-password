#!/usr/bin/env bash

# PT Plew
# if this doesn't work for you send me an email with your error message and I will check it out 
# 	open mailto:thepaulplew@gmail.com

# The purpose of this script is to generate a password using the XKCD password
# method more about it here
# 	open https://xkcd.com/936/
# or run with the -h flag
# Requirements:
#   Bash Version 4.X.X or higher


#Set some vars for case with no options
words=4
caps=0
numbers=0
symbolcount=0
file="./words.txt"
syms=( "~" "!" "@" "#" "$" "%" "^" "&" "*" "." ":" ";" )

## integer_input : determines if $2 is an integer
# $1: string to display in the error message if $2 is not an integer
# $2: input to be checked against regex expression
integer_input() {
	# [0-9] : members of 0-9
	# + 	: matches one or more of the expression
	if ! [[ $2 =~ ^[0-9]+$ ]] ; then
   		printf "ERROR: input for $1 ($2) is not a integerr\n" >&2; exit 1
	fi
}

## new_random : uses /dev/random (a crypyographically secure source) to
# produce a new random integer 0-255 in $random
# no inputs
new_random() {
	random=$(head -c 1 /dev/random | od -D | sed "s/[^1-9]//g" | head -n 1)
}

## random_symbol : uses the random number to choose a random symbol from
# the array of symbols defined at the top of the file
# no inputs
random_symbol() {
	new_random
    chosensymbol="${syms[$((random%${#syms[*]}))]}"
}

## show_usage : shows the usage message for this script
# no inputs
show_usage() {
    cat<<EOF
usage: xkcdpwgen [-h] [-w WORDS] [-c CAPS] [-n NUMBERS] [-s SYMBOLS] 
                 [--wordlist /path/to/wordlist]

Generate a secure, memorable password using the XKCD method

optional arguments:
    -h, --help            show this help message and exit
    -w WORDS, --words WORDS
                          include WORDS words in the password (default=4)
    -c CAPS, --caps CAPS  capitalize the first letter of CAPS random words
                          (default=0)
    -n NUMBERS, --numbers NUMBERS
                          insert NUMBERS random numbers in the password
                          (default=0)
    -s SYMBOLS, --symbols SYMBOLS
                          insert SYMBOLS random symbols in the password
                          (default=0)
    --wordlist /path/to/wordlist
                          use your own custom wordlist for the words in the
                          password
EOF
}

## main : the main function that 
# $@: all arguments passed to script
main() {
	while :; do
	    case $1 in
	        -h|-\?|--help) show_usage && exit ;; ## Display usage 
	        -w|--words) ## include WORDS words in the password
	            integer_input "$1" "$2" ## exits if this is not an integer input
	            words=$2 ## set words to the input for this option
	            shift ;;
	        -c|--caps) ## include CAPS capital letters in the password
	            integer_input "$1" "$2" ## exits if this is not an integer input
	            caps=$2 ## set caps to the input for this option
                    # if the number of words is less than the number of caps then set
                    # the caps to the number of words (necessary for the way I capitalized
                    # words down below)
                    if [[ $words -lt $caps ]]; then
                        printf 'WARNING: More CAPS than WORDS: $words WORDS, $caps CAPS %s\n' >&2
                        caps="$words"
                    fi
	            shift ;;
	        -n|--numbers) ## insert NUMBERS random numbers in the password
	            integer_input "$1" "$2" ## exits if this is not an integer input
		    	numbers="$2" ## set numbers to the input for this option
		    	shift ;;
	        -s|--symbols) ## insert SYMBOLS random symbols in the password
	            integer_input "$1" "$2" ## exits if this is not an integer input
		    	symbolcount="$2" ## set symbols to the input for this option
		    	shift ;;
            --wordlist)
                if ! [[ -f "$2" ]]; then
                    printf "WARNING: $file does not exist, using default wordlist \n" >&2
                    file="./words.txt"
                else
                    file=$2
                fi
                shift ;;
	        --) break ;; ## End of all options.
	        -?*) ## if an incorrect option is chosen
	            printf 'WARNING: Unknown option: %s\n' "$1" >&2
	           	shift ;;
	        *) break # Default case: No more options, so break out of the loop.
	    esac
            shift
	done

	declare -a chosenwords
	# fill the array chosenwords with words randomly chosen from a file
    for ((i=0;i<$words;i++)); do
    	chosenwords[i]=$(shuf $file | head -n 1 | tr -d '\r\n')
    done

    # capitalize the number of words specified
    while (( $caps > 0 )); do
    	new_random
    	local tempindex=$((random%((words)))) # temporary index in the array
    	local tempword=${chosenwords[tempindex]} # word to be capitalized
        tempword="${tempword[*]^}"
        # if the word has not already been capitalized add one to the 
        if ! [[ $tempword == ${chosenwords[tempindex]} ]]; then
    		chosenwords[tempindex]="${tempword[*]^}"
    		caps=$((caps-1))  
        fi
    done

    while (( $numbers > 0 )); do
    	new_random
    	# temporary index for the chosenwords array+1 for adding to the end
    	local tempindex=$((random%((words+1)))) 
    	chosenwords[tempindex]="$((random%10))${chosenwords[tempindex]}" ##
    	numbers=$((numbers-1))
    done

    while (( $symbolcount > 0 )); do
    	random_symbol # set chosensymbol to a random symbol from sym
    	new_random
    	# temporary index for the chosenwords array+1 for adding to the end
    	local tempindex=$((random%((words+1)))) 
    	chosenwords[tempindex]="$chosensymbol${chosenwords[tempindex]}"
    	symbolcount=$((symbolcount-1))
    done

    # print the final array on one line 
	printf '%s' "${chosenwords[@]}" 
	printf "\n" # print a newline character
}

main "$@"
