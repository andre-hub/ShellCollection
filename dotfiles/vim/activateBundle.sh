#!/bin/sh
CleanBundleDir() {
	rm ~/.vim/bundle/*
}

ActivateBundle() {
	vimcfgPath="/home/andre/.vim"
	pathActivated="bundle"
	pathDeactivated="bundle-deactivated"

	ln -s $vimcfgPath/$pathDeactivated/$1/ $vimcfgPath/$pathActivated/$1
}

CleanBundleDir
ActivateBundle "jedi-vim"
ActivateBundle "markdown"
ActivateBundle "neocomplcache"
ActivateBundle "neosnippet"
ActivateBundle "nerdtree"
ActivateBundle "syntastic"
ActivateBundle "vim-go"
