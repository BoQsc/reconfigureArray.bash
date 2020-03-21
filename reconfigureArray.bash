#!/bin/bash
function reconstructArray(){
	local TEXT_TO_PARSE=$1;
	local ARRAY_ELEMENT=$2;

	#TODO Command Line Interface
	# MANIPULATION_MODE
	# Remove, Add, Replace
	local MANIPULATION_MODE=$3;
	# Position in the array
	# Search In Array items and remove

	# Append to the start, end or after
	# Array item search/find
		
		# Search mode or Position mode
		# search "" add after "$ArrayElement"
		# search "" remove after "$ArrayElement"
	# Array item position location
		# locate "" add "$ArrayElement"
		# Array prepositions
			# locate "" add after "$ArrayElement"
			# locate "" add before "$ArrayElement"
			# locate "" remove after "$ArrayElement"
			# locate "" remove before "$ArrayElement"
	# Replace 
	
	# search for "" in "$input" add after ""
	# locate "" in "$input" add after ""
	# locate "" in "$input" replace with ""

	# search and delete "" in ""
	# search and delete "" in ""
	# locate and delete "" in ""
	# locate and delete "" in ""
	

	# append "" in "" to ""


	# [ $isLocate ]
	# [ $isSearch ]
	# [ $isAdd ]
	# [ $isRemove ]
	# [ $isReplace ]
	# [ $isBefore ]
	# [ $isAfter ]

	# Documentation about capability to append large portion of Array items. 

	local isBefore=false;
	local isAfter=false;

	local isRemove=false;

	local isInsertAfter=false;

	
	local i=0;
	local REGEX_PATTERN="'.([^']*)'";
	local GLOB_PATTERN_MATCHING="\'*google*\'"

	# Start Array
	local NEW_ARRAY="[";
	
	# Append element to the start of the Array
	[ $isBefore == true ] && {
		local NEW_ARRAY+="'randomExample.desktop', ";  
	}

	while [[ ${TEXT_TO_PARSE} =~ (${REGEX_PATTERN}) ]]; do
		
		# Loop Increment
		let i++;
		echo "$i ${BASH_REMATCH[1]}";


		# If isRemove is enabled, skip the element and populate the array
		if [ $isRemove == true ] && [ ! $i -eq 5 ]; then 
			NEW_ARRAY+="${BASH_REMATCH[1]}, ";
		fi
	
		# Search element by text pattern
		if  [[ ${BASH_REMATCH[1]} == ${GLOB_PATTERN_MATCHING} ]]; then
			echo "^_ Found a Match at $i Array position"
		fi
		
		# Append after nth element of the Array
		if [ $isInsertAfter == true ] &&[ $i -eq 5 ]; then
			NEW_ARRAY+="'randomExample.desktop', ";
		fi
	
		# If matched Regex Result BASH_REMATCH matches an Item 
		# in the array TEXT_TO_PARSE, remove it from the array
		TEXT_TO_PARSE=${TEXT_TO_PARSE##*${BASH_REMATCH[1]}};
	done

		# Check if Variable is not empty and:
		# Remove empty space and a comma symbol from the end of array 
		[ -z "${NEW_ARRAY}" ] && declare NEW_ARRAY=${NEW_ARRAY::-2};

		# Append element to the end of the Array
		[ $isAfter == true ] && {
			NEW_ARRAY+=", 'randomExample.desktop'"; 
		}

		# End Array
		NEW_ARRAY+="]";
		echo "";
		echo "Newly constructed Array: ";
		echo "$NEW_ARRAY";
}
reconstructArray "$(gsettings get org.gnome.shell favorite-apps)";
