#!/bin/bash
#SBATCH --job-name=getMGRAST
#SBATCH --partition=compute
#SBATCH --c 1
#SBATCH --output=getMGRAST_%j.out
#SBATCH --error=getMGRAST_%j.err
key=$1

#ignore first parm1
shift

wd=$PWD
# create a temporary directory for this job and save the name 
tempdir=$(mktemp -d /flash/GoryaninU/lptolik/getMGRAST.XXXXXX)
echo $tempdir

# enter the temporary directory
cd $tempdir


# iterate
while test ${#} -gt 0
do
  echo $1
  mgid=$1
  shift
  echo "$1 SEQ for $2"
  srun curl  -H "auth: $key" -H 'Accept-Encoding: gzip,deflate' "http://api.metagenomics.anl.gov/1/annotation/sequence/$mgid?source=SEED&evalue=10&type=organism" -o "$mgid.seq.seed"
done


datdir=`echo $wd| sed s/flash/bucket/`

ssh deigo "mkdir -p $datdir"

# copy our result back to bucket. We need to use "scp"
# to copy the data back as bucket isn't writable directly. 
scp "*.seq.seed" deigo:"$datdir/"

cd $wd
# Clean up by removing our temporary directory 
rm -r $tempdir
