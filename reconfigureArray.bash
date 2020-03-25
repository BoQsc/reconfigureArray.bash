#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
fi

if [ -z "$1" ]
  then
    echo "No argument supplied"
fi

	

	#local isBefore=false; 
	#local isAfter=false;  

	#local isInsertAfter=false;
	#local isInsertBefore=true; 


function reconstructArray(){
	local TEXT_TO_PARSE=$1;
	local MANIPULATION_MODE=$2;

	# ${array} insert "'randomExample.desktop', " after 5
	if [ "$MANIPULATION_MODE" == "insert" ]; then
		local ARRAY_ELEMENT=$3; # element to insert
		local QUERY_OPTION=$4;
		[ "$QUERY_OPTION" == "after" ] && {
								#local ARRAY_ELEMENT_POSITION=$5; # element to insert at
			local ARRAY_ITEM_POSITION=$5;
			local INSERT_AFTER_POSITION=$ARRAY_ELEMENT;
		}

		[ "$QUERY_OPTION" == "before" ] && {
								#local ARRAY_ELEMENT_POSITION=$5; # element to insert at
			local ARRAY_ITEM_POSITION=$5;
			local INSERT_BEFORE_POSITION=$ARRAY_ELEMENT;
			local POSITION_BEFORE_ARRAY_ITEM=1;
		}
		
	fi

	if [ "$MANIPULATION_MODE" == "replace" ]; then
		local QUERY_OPTION=$3;
		[ "$QUERY_OPTION" == "at" ] && {
			local ARRAY_ITEM_POSITION=$4;
			local QUERY_OPTION_TWO=$5
			[ "$QUERY_OPTION_TWO" == "with" ] && {
				local ARRAY_ELEMENT=$6;
				local isRemove=true;
				local INSERT_AFTER_POSITION=$ARRAY_ELEMENT;
 				
			}
		}

	fi
	
	if [ "$MANIPULATION_MODE" == "search" ]; then
		local GLOB_PATTERN_MATCHING="\'*$3*\'";
		local QUERY_OPTION=$4;
		[ "$QUERY_OPTION" == "and" ] && {
			local QUERY_OPTION_TWO=$5;
			[ "$QUERY_OPTION_TWO" == "replace with" ] && {
				local ARRAY_ELEMENT=$6;
				local INSERT_AFTER_POSITION=$ARRAY_ELEMENT;
			}
			[ "$QUERY_OPTION_TWO" == "remove" ] && {
				local ARRAY_ELEMENT;
			}
		}
	fi
	if [ "$MANIPULATION_MODE" == "delete" ]; then
		local QUERY_OPTION=$3;
		[ "$QUERY_OPTION" == "at" ] && {
			local ARRAY_ITEM_POSITION=$4; 
			local isRemove=true;
		}
	fi

	#local INSERT_BEFORE_ARRAY="'randomExample.desktop', ";
	#local INSERT_AFTER_ARRAY=", 'randomExample.desktop'";
	#local INSERT_AFTER_POSITION="'randomExample.desktop', ";
	#local INSERT_BEFORE_POSITION="'randomExample.desktop', ";
	#local ARRAY_ITEM_POSITION=5;
	#local POSITION_BEFORE_ARRAY_ITEM=2;

	
	local i=0;
	local REGEX_PATTERN="'.([^']*)'";
	#local GLOB_PATTERN_MATCHING="\'*google*\'";

	
	local NEW_ARRAY="[";
	[ ! -z "${INSERT_BEFORE_ARRAY}" ] && {
		local NEW_ARRAY+="$INSERT_BEFORE_ARRAY";  
	}

	while [[ ${TEXT_TO_PARSE} =~ (${REGEX_PATTERN}) ]]; do
		
		let i++;
		echo "$i ${BASH_REMATCH[1]}";


		## TODO: IF the first element in the array is not the match, wait before the match and only then remove the element4
		# Right now It removes every item until the match and then removes the matched then replaces it
		if [ "$MANIPULATION_MODE" == "search" ]; then
			local ARRAY_ITEM_POSITION=0;
			if  [[ ${BASH_REMATCH[1]} == ${GLOB_PATTERN_MATCHING} ]]; then
				local ARRAY_ITEM_POSITION=$i;
				echo "^_ Found a Match at $i Array position"
			fi
			if [ "$QUERY_OPTION_TWO" == "replace with" ] || [ "$QUERY_OPTION_TWO" == "remove" ]; then
				[ ! $i -eq $ARRAY_ITEM_POSITION ] && NEW_ARRAY+="${BASH_REMATCH[1]}, ";
			fi
		fi

		if [ ! -z "${isRemove}" ]; then 
			 [ ! $i -eq $ARRAY_ITEM_POSITION ] && NEW_ARRAY+="${BASH_REMATCH[1]}, ";
		fi

		if [ -z "${isRemove}" ] && [ ! "$MANIPULATION_MODE" == "search" ]; then 
			NEW_ARRAY+="${BASH_REMATCH[1]}, ";
		fi
		
	
		
		if [ ! -z "${INSERT_AFTER_POSITION}" ] && [ $i -eq $ARRAY_ITEM_POSITION ]; then
			local NEW_ARRAY+="$INSERT_AFTER_POSITION";  
		fi
		
		if [ ! -z "${INSERT_BEFORE_POSITION}" ] && [ $i -eq $(expr $ARRAY_ITEM_POSITION - $POSITION_BEFORE_ARRAY_ITEM) ]; then
			local NEW_ARRAY+="$INSERT_BEFORE_POSITION";  
			
		fi

		
		TEXT_TO_PARSE=${TEXT_TO_PARSE##*${BASH_REMATCH[1]}};
	done

		[ ! "$NEW_ARRAY" == "[" ] && {
			declare NEW_ARRAY=${NEW_ARRAY::-2};
		}

		
		[ ! -z "${INSERT_AFTER_ARRAY}" ] && {
			local NEW_ARRAY+="$INSERT_AFTER_ARRAY";  
		}

		
		NEW_ARRAY+="]";
		echo "";
		echo "Newly constructed Array: ";
		echo "$NEW_ARRAY";

}
#reconstructArray "$(gsettings get org.gnome.shell favorite-apps)" insert "'randomExample.desktop', " after 5;
#reconstructArray "$(gsettings get org.gnome.shell favorite-apps)" replace at 5 with "'randomExample.desktop', ";
#reconstructArray "$(gsettings get org.gnome.shell favorite-apps)" search "google" and "replace with" "'randomExample.desktop', ";
#reconstructArray "$(gsettings get org.gnome.shell favorite-apps)" search "google" and remove;
reconstructArray "$(gsettings get org.gnome.shell favorite-apps)" delete at 5;
