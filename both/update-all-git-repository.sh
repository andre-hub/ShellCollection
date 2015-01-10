#!/bin/sh
gitCleanHelp() {
	echo "recusive git clean and remote pull\n"
	echo "\tUseage: update-all-git-repository [option] \n"
	echo "\tOption: \n\t\tCleanWorking - Clean working directory and fetch all remote git repositories"
}

gitCleanPull() {
	echo "git fetch ..."
	git fetch --progress --prune origin
	echo "git pull ..."
	git pull --rebase --progress
	echo "git reset master ..."
	git reset --hard origin/master
}

gitCleanWorkingDir() {
	echo "stash cleaning ..."
	git stash clear
	echo "working dir cleaning ..."
	git clean -fdx *
	echo "checkout last HEAD"
	git checkout . --force
}

gitCleanAndPull() {
	gitCleanWorkingDir
	gitCleanPull
}

rDir() {
	for d in "$1"/*; do
		[ $d = "." -o $d = ".." -o -f $d ] && continue
		[ "${d#*.git}" = "$d" ] && continue
		echo "\n\n############\n$d"
   		cd $d && $2 && cd ..
   		done
}

if [ "${1#-h}" != "$1" -o "${1#help}" != "$1" -o "${1#--help}" != "$1" ]; then
	gitCleanHelp
	exit 0
fi

if [ "$2" != "" ]; then
	workingDir="$2"
else
	workingDir=`pwd`	
fi

echo "working directory: $workingDir"

if [ "$1"="CleanWorking" ]; then
	rDir $workingDir gitCleanAndPull
else
	rDir $workingDir gitCleanPull
fi

echo "\n\n------------------------------\nFinish git cleaning or pull"