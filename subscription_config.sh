#!/bin/bash
clear
MYDIR=$HOME/subscriptions 
MYPATH=$HOME/subscriptions/repos.txt 

# Add more comments describing functions
# Add more 'clear' commands to make er' pretty!!!!! :D
# This would be more efficient if the director and file were stored in variables as well - done
function gather() {
	# Will need to add an error function for more efficient code
	echo "Searching if directory and file exists for program to continue"
	sleep 1
	if [ -d $MYDIR ]
	then
		echo "Directory exists, skipping ..."
		sleep 2
	else
		echo "Creating directory"
		mkdir $MYDIR
		sleep 2
	fi
	if [ -s $MYPATH ]
	then
		local RUNNING=1
		while [ $RUNNING -eq 1 ]
		do
			# add a return button so user can either exit or go to main menu
			echo
			echo "repos.txt exists and contains content"
			sleep .5
			echo "Please select a below option"
			sleep .5
			echo "a) write over repos.txt"
			echo "b) exit the program"
			read ANSWER
			case $ANSWER in 
				a) echo "Continuing..."
				local RUNNING=0
				;;
				b) echo "Exiting..."
					exit 1
					;;
				*) echo "Invalid Option"
					sleep 1
					echo
			esac
		done
	fi
	echo "Creating \"repos.txt\""
	echo "Adding your subscriptions"
	echo "This may take a moment..."
	subscription-manager repos --list-enabled | grep -i "Repo ID" | awk '{print $3}' > $MYPATH 2>> /dev/null
	if [ $? -eq 0 ]
	then		
	echo "Printing your repos.txt file"
	cat $MYPATH
	else
		echo "ERROR: Subscription manger either timed out or reported back an error. Task couldn't be completed!"
	fi
}

function disable_repos() {
	# need exit code checker here as well
	local RUNNING=1
	echo "Disabling your repo subscriptions"
	echo "This may take a moment"
	sleep 1
	if [ ! -s $MYPATH ]
	then
		while [ $RUNNING -eq 1 ]
		do
		echo
		echo "You do not currently have a repos.txt file that contains content"
		echo "This means that if you disable your repos now, your previous repos will not have been saved to enable later"
		echo "Do you wish to continue?"
		echo "a) yes"
		echo "b) no"
		read ANSWER
		case $ANSWER in 
			a) echo "Continuing"
				RUNNING=0
				;;
			b) echo "Exiting"
				exit 1
				;;
			*) echo "Invalid Opiton"
		esac
	done
	fi
	subscription-manager repos --disable "*" > /dev/null 2>&1
	if [ $? -eq 0 ]
	then
		echo "Your repo subscriptions have been disabled"
	else
		echo "ERROR: Subscription Manager Ran into an error and task coudn't be completed!"
	fi
}

function enable_repos() {
	local success=()
	echo "Checking that you have repos.txt to gather repos from"
	if [ ! -s $MYPATH ]
	then
		echo "It looks like you either don't have repos.txt or it doesn't have any content"
		echo "The script will be unable to perform"
		exit 1
	else
		echo "Getting your repos setup, this will take a moment..."
	for i in $@ 
	do
	subscription-manager repos --enable $i # 2>> /dev/null
		if [ $? -eq 0 ]
		then
			echo $i has been enabled
			success+=($i)
		else 
			echo $i failed to be enabled
			echo "This may be caused by the subscription-manager, sometimes you can just run it again, or wait before running again"
		fi
	done
	fi
	if [ $? -eq 0 ]
	then
		echo "Finished enabling the following repos"
		printf "%s\n" "${success[@]}"
	else
		echo "ERROR: Subscription Manager ran into an error and task couldn't be completed!"
	fi
		
}

echo "                                          Welcome to Subscription V1"
echo
sleep 1
MAIN_RUN=1
CONTINUE="none"
echo "This program relies on you to have a \"subscriptions\" directory in your home directory as well as a file in it called \"repos.txt\""
sleep 2
if [ -s $MYPATH ]
then
	REPOS=`cat $MYPATH`
else
	echo
	echo "It was detected that you do not have the appropriate directory, file, or contents of a file to continue"
	sleep 2
	echo "We'll need to gather your current repo subscriptions that are enabled before we can do anything"
	sleep 2
	while [[ "$CONTINUE" != [yn] ]]
	do
		echo
		echo "Would you like to continue to enabled repo subscription gathering or exit? [y/n] "
		read CONTINUE
	done
	if [ $CONTINUE = "y" ]
	then
	echo "Moving you to repo subscription gathering"
	gather
	elif [ $CONTINUE = "n" ]
	then
		echo "Exiting"
		exit 1
	else 
		echo "Invalid Response"
	fi
fi
echo "Press enter to continue"
read 
sleep 1
while [ $MAIN_RUN -eq 1 ]
do
	clear
# Add a button that let's you see your current subscriptions
	echo
	echo "Please select an option below"
	echo
	echo "a) Gather repository subscriptions"
	echo "b) Disable repository subscriptions WARNING: SELECT a) prior if you don't have \"/subscriptions/repos.txt\""
	echo "c) Enable repositroy subscriptionss WARNING: SELECT a) prior if you don't have \"subscriptions/repos.txt\""
	echo "d) Check your enabled repository subscriptions"
	echo "e) Check your \"repos.txt\" file content"
	echo "f) Exit program"
	read MAIN_ANSWER
	case $MAIN_ANSWER in 
		a) gather
			echo $MYDIR $MYPATH
			;;
		b) disable_repos
			;;
		c) enable_repos $REPOS
			;;
		d) subscription-manager repos --list-enabled
			echo "Once finshed reviewing, press any enter to continue"
			read
			;;
		e) cat $MYPATH
			echo "Once finshed reviewing, press any enter to continue"
			read
			;;
		f) echo "Exiting Program"
			exit 0
			;;
		e) echo "Invalid input"
		esac
	done
