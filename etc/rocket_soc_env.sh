#!/bin/sh

source_script=$_
if test $source_script = $0; then
  echo "Error: expect to have script sourced"
  exit 1
fi

etc_dir=`dirname $source_script`
ROCKET_SOC=`cd $etc_dir/.. ; pwd`
export ROCKET_SOC

# Add a path to the simscripts directory
export PATH=$ROCKET_SOC/packages/simscripts/bin:$PATH



