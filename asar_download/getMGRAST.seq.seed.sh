#!/bin/bash
#SBATCH --job-name=s.getMGRAST
#SBATCH --partition=compute
#SBATCH --c 1
#SBATCH --output=getMGRAST_%j.out
#SBATCH --error=getMGRAST_%j.err

key=$1
mgid=$2
datdir=$3
echo "$1 SEED for $2"

wd=$PWD
# create a temporary directory for this job and save the name 
tempdir=$(mktemp -d /flash/GoryaninU/lptolik/getMGRAST.XXXXXX)
echo $tempdir

# enter the temporary directory
cd $tempdir

srun curl  -H "auth: $key" -H 'Accept-Encoding: gzip,deflate' "http://api.metagenomics.anl.gov/1/annotation/sequence/$mgid?source=SEED&evalue=10&type=organism" -o "$mgid.seq.seed"

# copy our result back to bucket. We need to use "scp"
# to copy the data back as bucket isn't writable directly. 
scp "$mgid.seq.seed" deigo:"$datdir/$mgid.seq.seed"

cd $wd
# Clean up by removing our temporary directory 
rm -r $tempdir
