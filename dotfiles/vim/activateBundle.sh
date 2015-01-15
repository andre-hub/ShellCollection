#!/bin/sh
CleanBundleDir() {
	rm bundle/*
}

ActivateBundle() {
	pathActivated="bundle"
	pathDeactivated="../bundle-deactivated"

	ln -s $pathDeactivated/$1/ $pathActivated/$1
}

CleanBundleDir
ActivateBundle "jedi-vim"
ActivateBundle "neocomplcache"
ActivateBundle "neosnippet"
ActivateBundle "nerdtree"
ActivateBundle "supertab"
ActivateBundle "syntastic"
ActivateBundle "vim-go"
ActivateBundle "vim-pathogen"
ActivateBundle "vim-markdown"