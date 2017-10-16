#!/bin/sh

git submodule foreach "git fetch && git merge"

