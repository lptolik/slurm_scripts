#!/bin/bash
#SBATCH --job-name=gzip
#SBATCH --mail-user=lptolik@gmail.com
#SBATCH --partition=short
#SBATCH --c 1
#SBATCH --output=gzip_%j.out
#SBATCH --error=gzip_%j.err

tmpl=$1
datdir=$2
echo "$1 for $2"

wd=$PWD
# create a temporary directory for this job and save the name 
tempdir=$(mktemp -d /flash/GoryaninU/lptolik/gzip.XXXXXX)
echo $tempdir

# enter the temporary directory
cd $tempdir


for f in $tmpl; do 
fn=$(basename "$f")
echo $fn
gzip -c $f > "$fn.gz"
done

# copy our result back to bucket. We need to use "scp"
# to copy the data back as bucket isn't writable directly. 
scp "*.gz" deigo:"$datdir/"

cd $wd
# Clean up by removing our temporary directory 
rm -r $tempdir
