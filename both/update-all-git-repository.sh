#!/bin/sh
gitCleanPull() {
	git stash clear
	git clean -f -f *
	git checkout master --force
	git pull --rebase
	#git fetch --progress --all --prune
}

rDir() {
	for d in "$1"/*; do
		[ $d = "." -o $d = ".." -o -f $d ] && continue
		[[ "${d}" != *.git* ]] && continue
		echo $d
   		cd $d && $2 && cd ..
   		done
}

rDir ~/YourMainWorkspace gitCleanPull