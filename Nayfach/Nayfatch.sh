#Changing list's names for forward FASTA sequence extraction
$ sed -i -e 's/^/fna\//' list.txt
$ sed -i -e 's/$/.fna.gz/' list.txt

#Extract MAG's
$ for i in $(cat list.txt);do(tar -xf /tres/DB/Nayfach_MAGs/fna.tar $i);done

#Individual analysis of MAG's according to Nayfach project
$ ls *fna* | sed s'/.fna.gz//g' > list.txt
$ for i in $(cat list.txt);do (mkdir $i) ;done
$ for i in $(cat list.txt);do (mv fna/$i.fna.gz* $i/) ;done
$ for i in $(cat list.txt);do (cd $i && gzip -d *.gz);done
$ for i in $(cat list.txt);do (cd $i && ln -s ~/scripts/diamond.sh .) ;done
$ for i in $(cat list.txt);do (cd $i && qsub -V diamond.sh) ;done

$ for i in $(cat list.txt);do (cd $i && cut -f2 pul.matches.tsv | sort | uniq -c >> $i.matches.out) ;done
$ for i in $(cat list.txt);do (cd $i && cut -f2 pul.matches.tsv | sort | uniq -c >> ../results/$i.matches.out) ;done
