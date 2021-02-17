#!/bin/bash
#SBATCH --job-name=makeTSV
#SBATCH --partition=compute
#SBATCH --mem=32G
#SBATCH --c 8
#SBATCH --input=none
#SBATCH --output=makeTSV_%j.out
#SBATCH --error=makeTSV_%j.err

alias ghead='head'
alias gtail='tail'

project=$1
echo $project
datdir=$2

wd=$PWD
# create a temporary directory for this job and save the name 
tempdir=$(mktemp -d /flash/GoryaninU/lptolik/makeTSV.XXXXXX)
echo $tempdir

# enter the temporary directory
cd $tempdir


module load R/3.6.1 

Rscript ../makeTSV.R $project $datdir

gzip *.tsv
# copy our result back to bucket. We need to use "scp"
# to copy the data back as bucket isn't writable directly. 
scp "*.tsv.gz" deigo:"$datdir/"

cd $wd
# Clean up by removing our temporary directory 
rm -r $tempdir

