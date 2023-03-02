#Integrate all normal matrixes in one. We do this with Alejandra's Escobar Zepeda matrix_integrator_bmk.pl script and a list with all the metagenomes.
$ cp ../list.txt . 
#Make symbolic link to each file of th
$ for loko in $(cat list.txt); do(ln -s /direccionarchivopul/ $loko);done
$ ~/scripts/matrix_integrator_bmk.pl list.txt

mv integrated_matrix.txt pul.matrix.txt