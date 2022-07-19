<<"COMMENT"
	A Bash shell script that provides functions for manipulating a collection
	of GitHub repositories that you find interesting or useful and have saved a
	clone of in case the repositories are deleted or made private. This script
	lets you add a repository to your collection, update the repositories to 
	the latest version, if it exists, or remove a repository from your 
	collection. 

	To add a repository, provide the script with the GitHub cloning URL of the 
	repository you want. It will log the URL in a text file, clone the URL and 
	then discard the .git folder inside the cloned repository to allow Git to 
	push the parent directory to your personal GitHub account.

	USAGE: bash repo_manager.sh add URL

	To update the repositories, the script will read through this list of
	sources and attempt to clone the repository at that URL. If the clone is
	successful, it discards the old repository folder. If the clone is
	unsuccessful (i.e. the original repository has been deleted or been made
	private), it preserves the existing repository directory.

	USAGE: bash repo_manager.sh update

	To remove a repository, provide the script with the name of the directory
	containing the repository. It will remove the URL from the list of sources
	and then remove the directory itself.

	USAGE: bash repo_manager.sh remove DIRECTORY

	@author Aanish Pradhan
	@version 07/19/2022
COMMENT

# SPECIFY SHELL
#!/bin/bash

# FUNCTIONS

## ADD REPOSITORY TO COLLECTION
function addRepository() {
	
	### Checks if URL argument has been provided
	if [[ -z "$1" ]]; then
		echo ""
		echo "ERROR! The URL of the GitHub repository to clone has not been provided."
		exit 1
	fi 

	### Checks if sources file doesn't exist
	sourcesFile=./sources.txt
	if [[ ! -f  "$sourcesFile" ]]; then
		echo ""
		echo "WARNING! Sources file does not exist. Creating source file..."
		touch sources.txt
	else
		echo ""
		echo "Sources file exists. Proceeding..."
	fi

	### Checks if URL has already been added to the sources list
	existingURL=$(grep "$1" ./sources.txt)
	if [[ -n "$existingURL" ]]; then
		echo ""
		echo "ERROR! URL already exists in sources file."
		exit 1
	fi

	### Clone the repository
	git clone "$1"

	### Remove .git files and folders inside the newly cloned repository
	directoryName=$(ls -td -- */ | head -n 1 | cut -d'/' -f1)
	cd "$directoryName"
	rm -rf .git/
	rm .git*
	cd ..

	### Add the URL to the list of sources
	echo "$1" >> ./sources.txt

	echo ""
	echo "SUCCESS! The repository has been cloned and the URL has been logged to the sources list."
	exit 0
}

## UPDATE REPOSITORIES IN COLLECTION
function updateRepositories() {
	
	### Checks if sources file doesn't exist
	sourcesFile=./sources.txt
	if [[ ! -f "$sourcesFile" ]]; then
		echo ""
		echo "ERROR! Sources file does not exist. There are no repositories in the collection to update. Add repositories first."
		exit 1
	else
		echo ""
		echo "Sources file exists. Proceeding..."
	fi

	for directory in */
	do
		### Obtain the URL of the repository to clone from the directory name
		directoryName="${directory::-1}"
		repoToClone=$(grep "$directoryName" ./sources.txt)
		
		### Temporarily rename the repository
		mv $directory temp

		### Cloning process
		cloneResult=$(git clone "$repoToClone" 2>&1)

		if [[ $cloneResult == *"fatal"* ]]; then
			echo ""
			echo "WARNING! Update for "$directoryName" failed. "$repoToClone" has been deleted or been made private. You currently have the latest version." 
			mv temp/ "$directoryName"
		else
			echo ""
			echo "SUCCESS! Obtained the latest version of "$directoryName" and removed the old version."
			cd $directoryName
			rm -rf .git/
			rm .git*
			cd ..
			rm -rf temp/
		fi
	done
}

## REMOVE REPOSITORIES FROM COLLECTION
function removeRepository() {
	
	### Checks if directory name argument has been provided
	if [[ -z "$1" ]]; then
		echo ""
		echo "ERROR! The directory name of the repository to remove has not been provided."
		exit 1
	fi
	
	### Checks if sources file doesn't exist
	sourcesFile=./sources.txt
	if [[ ! -f "$sourcesFile" ]]; then
		echo ""
		echo "WARNING! Sources file does not exist. There are no repositories to remove. Add repositories first."
		exit 1
	else
		echo ""
		echo "Sources file exists. Proceeding..."
	fi

	### Checks if sources file is empty
	if [[ ! -s ./sources.txt ]]; then
		echo ""
		echo "ERROR! Sources file is empty and does not contain any URLs. Add a repository first."
		exit 1
	fi

	### Checks if directory does not exist
	if [[ ! -d "$1" ]]; then
		echo ""
		echo "ERROR! Directory does not exist."
		exit 1
	fi

	### Corrects directory name if needed
	param="$1"
	URL=""
	if [[ "$1" == *"/"* ]]; then
		correctedParam="${param::-1}" # Removes the forward slash from the argument
		URL=$(grep "$correctedParam" sources.txt)
	else
		URL=$(grep "$1" sources.txt)
	fi

	### Removes URL from source
	touch tmpfile.txt
	grep -v "$URL" sources.txt > tmpfile.txt
	mv tmpfile.txt sources.txt

	### Removes directory
	rm -rf "$1"

	echo ""
	echo "SUCCESS! The repository has been removed from the collection."
}

# MAIN FUNCTION
if [[ "$1" == "add" ]]; then
	addRepository $2
elif [[ "$1" == "update" ]]; then
	updateRepositories
elif [[ "$1" == "remove" ]]; then
	removeRepository $2
elif [[ "$1" == "help" ]]; then
	head -n 27 repo_manager.sh | tail -n 26
else
	echo "ERROR! Invalid option. Run 'bash repo_manager.sh help' to see correct script usage."
fi
