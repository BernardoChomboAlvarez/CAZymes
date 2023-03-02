#!/bin/bash
#$ -N diamond
#$ -cwd
#$ -pe mpi 16
#$ -j y
#$ -l h_vmem=8G

diamond2 blastx --db /tres/DB/dbCAN-PUL/PUL.dmnd -k 1 --query *.fna --out pul.matches.tsv --ultra-sensitive --threads 16

