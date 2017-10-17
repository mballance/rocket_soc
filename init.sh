#!/bin/sh

git submodule foreach "git submodule update --init"
git submodule foreach "git checkout master"

