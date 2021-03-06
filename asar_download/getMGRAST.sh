#!/bin/bash
#SBATCH --job-name=getMGRAST
#SBATCH --partition=compute
#SBATCH --c 1
#SBATCH --output=getMGRAST_%j.out
#SBATCH --error=getMGRAST_%j.err

key=$1
mgid=$2
datdir=$3
echo "$1 for $2"

wd=$PWD
# create a temporary directory for this job and save the name 
tempdir=$(mktemp -d /flash/GoryaninU/lptolik/getMGRAST.XXXXXX)
echo $tempdir

# enter the temporary directory
cd $tempdir

srun curl  -H "auth: $key" -H 'Accept-Encoding: gzip,deflate' "http://api.metagenomics.anl.gov/1/annotation/similarity/$mgid?source=SEED&type=organism&identity=60&length=15" -o "$mgid.seed"
srun curl  -H "auth: $key" -H 'Accept-Encoding: gzip,deflate' "http://api.metagenomics.anl.gov/1/annotation/similarity/$mgid?source=SEED&type=function&identity=60&length=15" -o "$mgid.fseed"
srun curl  -H "auth: $key" -H 'Accept-Encoding: gzip,deflate' "http://api.metagenomics.anl.gov/1/annotation/similarity/$mgid?source=KO&type=ontology&identity=60&length=15" -o "$mgid.ko"
srun curl  -H "auth: $key" -H 'Accept-Encoding: gzip,deflate' "http://api.metagenomics.anl.gov/1/annotation/similarity/$mgid?source=Subsystems&type=ontology&identity=60&length=15" -o "$mgid.fsub"

# copy our result back to bucket. We need to use "scp"
# to copy the data back as bucket isn't writable directly. 
scp "$mgid.seed" deigo:"$datdir/$mgid.seed"
scp "$mgid.seed" deigo:"$datdir/$mgid.fseed"
scp "$mgid.ko" deigo:"$datdir/$mgid.ko"
scp "$mgid.fsub" deigo:"$datdir/$mgid.fsub"

cd $wd
# Clean up by removing our temporary directory 
rm -r $tempdir
