#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
fi

if [ -z "$1" ]
  then
    echo "No argument supplied"
fi

	#local isRemove=false;

	#local isBefore=false; 
	#local isAfter=false;  

	#local isInsertAfter=false;
	#local isInsertBefore=true; 


function reconstructArray(){
	local TEXT_TO_PARSE=$1;
	local ARRAY_ELEMENT=$2;
	local MANIPULATION_MODE=$3;


	local insertBefore="'randomExample.desktop', ";
	
	local i=0;
	local REGEX_PATTERN="'.([^']*)'";
	local GLOB_PATTERN_MATCHING="\'*google*\'";

	
	local NEW_ARRAY="[";
	echo ---------
	[ ! -z "${insertBefore}" ] && {
		local NEW_ARRAY+="$insertBefore";  
	}

	while [[ ${TEXT_TO_PARSE} =~ (${REGEX_PATTERN}) ]]; do
		
		let i++;
		echo "$i ${BASH_REMATCH[1]}";

		if [ -z "${isRemove}" ]; then 
			NEW_ARRAY+="${BASH_REMATCH[1]}, ";
		fi
	
		if [ ! -z "${isRemove}" ]; then 
			 [ ! $i -eq 1 ] && NEW_ARRAY+="${BASH_REMATCH[1]}, ";
		fi
		
		if  [[ ${BASH_REMATCH[1]} == ${GLOB_PATTERN_MATCHING} ]]; then
			echo "^_ Found a Match at $i Array position"
		fi
		
		
		if [ ! -z "${isInsertAfter}" ] &&[ $i -eq 5 ]; then
			NEW_ARRAY+="'randomExample.desktop', ";
		fi

		if [ ! -z "${isInsertBefore}" ] &&[ $i -eq $(expr 5 - 2) ]; then
			NEW_ARRAY+="'randomExample.desktop', ";
		fi
		
		TEXT_TO_PARSE=${TEXT_TO_PARSE##*${BASH_REMATCH[1]}};
	done

		[ ! "$NEW_ARRAY" == "[" ] && {
			declare NEW_ARRAY=${NEW_ARRAY::-2};
		}

		
		[ ! -z "${isAfter}" ] && {
			NEW_ARRAY+=", 'randomExample.desktop'"; 
		}
		
		NEW_ARRAY+="]";
		echo "";
		echo "Newly constructed Array: ";
		echo "$NEW_ARRAY";

}
reconstructArray "$(gsettings get org.gnome.shell favorite-apps)";
