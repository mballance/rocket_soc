#!/bin/sh

git status --ignore-submodules
git submodule foreach "git status --ignore-submodules"

