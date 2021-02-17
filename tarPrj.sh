#!/bin/bash
#SBATCH --job-name=tar
#SBATCH --partition=compute
#SBATCH --c 1
#SBATCH --output=tar_%j.out
#SBATCH --error=tar_%j.err

prj=$1
echo $prj
datdir=$2

wd=$PWD
# create a temporary directory for this job and save the name 
tempdir=$(mktemp -d /flash/GoryaninU/lptolik/tarprj.XXXXXX)
echo $tempdir

# enter the temporary directory
cd $tempdir

tar --exclude='*.out' --exclude='*.err'  --exclude='*.sh' -cvjf "${prj}.tbz2" $prj

# copy our result back to bucket. We need to use "scp"
# to copy the data back as bucket isn't writable directly. 
scp "${prj}.tbz2" deigo:"$datdir/"

cd $wd
# Clean up by removing our temporary directory 
rm -r $tempdir

