#!/bin/sh

etc_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd)"
ROCKET_SOC=`cd $etc_dir/.. ; pwd`
export ROCKET_SOC

# Add a path to the simscripts directory
export PATH=$ROCKET_SOC/packages/simscripts/bin:$PATH

# Force the PACKAGES_DIR
export PACKAGES_DIR=$ROCKET_SOC/packages

