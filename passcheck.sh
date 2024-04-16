#!/bin/bash 

read -s  -p "enter password to check:  "   pass

full_hash=$(echo -n $pass | sha1sum | awk '{print substr($1, 0, 40)}')
prefix=$(echo $full_hash | awk '{print substr($1, 0, 5)}')
suffix=$(echo $full_hash | awk '{print substr($1, 6, 40)}')
if curl https://api.pwnedpasswords.com/range/$prefix | grep -i $suffix ; then

	echo "################# Your password is compromised #########################"
else 
	echo "################# Your password is not compromised #####################"
fi

