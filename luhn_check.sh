#!/bin/bash

#######
## Author: Piotr Natkaniec
## Validates whether a number passes the Luhn's algo check. This can be used for e.g. Canadian SID or credit/debit card number validation, and many other loyalty card numbers.
## Example with PAN: ./luhn_check.sh "4539319503436467" 
## Example with SID: ./luhn_check.sh "055-444-224"
#######

function validateCardNumber() {
	CardNumber=''
	for i in $@; do
		CardNumber+=${i} 
	done
	
    CardNumber=$(echo ${CardNumber} | sed 's/'\s'//g; s/[^0-9.]//g') 
	
    if [[ ${#CardNumber} -gt 1 ]]; then 
		declare -a digits;
		sum=0
		for (( i=0 ;i<${#CardNumber}; i++)); do
			digits[i]=${CardNumber:$i:1}
		done
	
        for (( i=${#digits[@]} - 1 ; i >= 0 ; i-- )); do
			if [[ $((${#digits[@]}%2)) -eq 0 ]]; then
				if [[ $(($i%2)) -eq 0 ]]; then
					digits[i]=$((${digits[i]}*2));
						if [[ ${digits[i]} -gt 9 ]];    then
                        digits[i]=$((${digits[i]}-9));
						fi
				fi
			else 
				if [[ $(($i%2)) -ne 0 ]]; then
					digits[i]=$((${digits[i]}*2));
						if [[ ${digits[i]} -gt 9 ]];    then
                        digits[i]=$((${digits[i]}-9));
						fi
				fi
            fi
            sum=$(($sum+${digits[i]}))
        done
		
        if [[ $(($sum%2)) -eq 0 ]];  then
            echo "${CardNumber} is valid";
        else
            echo "${CardNumber} is not valid";
        fi
    else 
        echo "${CardNumber} is not valid"
   fi
}

validateCardNumber $@
