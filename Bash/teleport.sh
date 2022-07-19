<<"COMMENT"
	A Bash shell script that allows users to code-in paths of directories they 
	frequently visit or work in several times a day and a nickname. When users 
	run the script and specify a nickname, they are quickly "teleported" to the 
	corresponding directory. Users can add their own shortcuts after

	if [[ $1 == "home" ]]; then
		cd ~

	and before
	
	else
		# Clears screen after teleportation
		clear
		
		# Prints user message	
		echo "Teleport: Nothing was matched"
		shouldClear="no"
	fi

	within this script. The general format of a shortcut is as follows: 

	elif [[ $1 == "NICKNAME" ]]; then
		cd $PREFIX/PATH TO DIRECTORY

	Example script:

	if [[ $1 == "home" ]]; then
		cd ~
	
	# Shortcut 1
	elif [[ $1 == "music" ]]; then
		cd $PREFIX/Music
	
	# Shortcut 2
	elif [[ $1 == "crypto" ]]; then
		cd $PREFIX/Projects/Blockchain/crypto/
	
	else
		# Clears screen after teleportation
		clear
		
		# Prints user message	
		echo "Teleport: Nothing was matched"
		shouldClear="no"
	fi

	USAGE: $ bash teleport.sh NICKNAME

	OPTIONAL: Alias "teleport.sh" to "teleport" in the .bashrc file as such: 

	alias teleport="bash ~/teleport.sh"

	This will make running the script more convenient. If this alias is 
	created, you can utilize the script as such: 

	$ teleport NICKNAME

	@author Amanuel Ephrem
	@version 11/26/2021

	@author Aanish Pradhan
	@version 07/19/2022
COMMENT

# SPECIFY SHELL
#!/bin/bash

PREFIX=/home/$USERNAME
shouldClear="yes"

## Home shortcut
if [[ $1 == "home" ]]; then 
	cd ~

## Add shortcuts under here

else
	# Clears screen after teleportation
	clear
	
	# Prints user message	
	echo "Teleport: Nothing was matched"
	shouldClear="no"
fi

## Clear prompt
if [ $shouldClear = "no" ]
then	
	clear
fi
