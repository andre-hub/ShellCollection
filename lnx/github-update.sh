#!/bin/zsh
githubUser="GITHUB-ACCOUNT"
array=( "ORIGINACCOUNT/REPOSITORYNAME" )

GithubUrl() {
	repositoryUrl="https://github.com/$1/$2.git"
	echo $repositoryUrl
}

GithubClone() {
	echo "--------------------"
	echo "Git - clone repository"
	git clone $1 $2
}

GitAddRemote() {
	cd $1
	echo "--------------------"
	echo "Git - add remote repository"
	git remote add upstream $2
}

GithubSync() {
	[ "${1#*.git}" = "$1" ] && exit
	[ ! -d $1 ] && exit
	cd $1
	echo "--------------------"
	echo "Git - sync upstream - start"
	git fetch upstream
	git checkout master
	git merge upstream/master
	echo "--------------------"
	echo "Git - sync upstream - finish"
	git push origin --tags --prune
	git push origin master
}

Split() {
	part=${1/\//' '}
	if [ $2 -eq 2 ]; then
		newpart=`echo $part | awk 'BEGIN{FS=OFS=" "}{$1=$3=""}{print}'`
	else
		newpart=`echo $part | awk 'BEGIN{FS=OFS=" "}{$2=$3=""}{print}'`
	fi
	echo "${newpart/ /}"
}

MakeIt() {
	remoteUserName=`Split $1 1`
	remoteRepositoryName=`Split $1 2`
	remoteUrl=$(GithubUrl ${remoteUserName/ /} ${remoteRepositoryName/ /})
	url=$(GithubUrl $2 ${remoteRepositoryName/ /})
	workingDir=`pwd`
	localPath="${remoteRepositoryName/ /}.git"
	GithubClone $url $localPath
	GitAddRemote $localPath $remoteUrl
	cd $workingDir
	GithubSync $localPath
	cd $workingDir
	echo "--------------------"
	echo "Cleaning ..."
	rm -rf $localPath
}

RunArray () {
	action=$3
	username=$4
	i=1
	while (( $i <= $2 ))
	do
		[ "${array[$i]}" = "" ] && $i=$i+1 && continue
		$action ${array[$i]} $username
		echo; echo; echo;
		i=$i+1
	done
}

#RunArray ( ArrayName, Function, Parameter)
MaxItems=${#array[*]}
RunArray array $MaxItems MakeIt $githubUser

echo "all repositories up to date!"; echo "--------------------"; echo;