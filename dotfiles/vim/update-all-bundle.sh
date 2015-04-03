#!/bin/sh
gitUpdateSubmodule() {
	git submodule foreach git pull --rebase=true origin master
	git submodule update --merge
}

rDir() {
	for d in "$1"/*; do
		[ $d = "." -o $d = ".." -o -f $d ] && continue
		echo $d
   		$2
   		done
}

rDir bundle-deactivated gitUpdateSubmodule