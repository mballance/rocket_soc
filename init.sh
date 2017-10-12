#!/bin/sh

cwd=`pwd`
for git_dir in `find -name '.git'`; do 
	cd `dirname $git_dir` 
	git checkout master 
	cd $cwd
done

