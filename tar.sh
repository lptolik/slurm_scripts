#!/bin/bash

#SBATCH --job-name=tar
#SBATCH --mail-user=lptolik@gmail.com
#SBATCH --partition=compute
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=4:00:00
#SBATCH --output=tar_%j.out
#SBATCH --error=tar_%j.err


tar xvzf YAMP_resources_20171128.tar.gz 


