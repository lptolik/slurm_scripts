#!/bin/bash
#SBATCH --job-name=tar
#SBATCH --partition=compute
#SBATCH --c 1
#SBATCH --output=tar_%j.out
#SBATCH --error=tar_%j.err

tar --exclude='*.out' --exclude='*.err'  --exclude='*.sh' -cvjf projects.tbz2 project.mgp*
