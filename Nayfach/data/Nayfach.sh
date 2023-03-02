#Individual analysis of MAG's according to Nayfach project
$ ls *fna* | sed s'/.fna.gz//g' > list.txt
$ for i in $(cat list.txt);do (mkdir $i) ;done
$ for i in $(cat list.txt);do (mv fna/$i.fna.gz* $i/) ;done
$ for i in $(cat list.txt);do (cd $i && gzip -d *.gz);done
$ for i in $(cat list.txt);do (cd $i && ln -s ~/scripts/diamond.sh .) ;done
$ for i in $(cat list.txt);do (cd $i && qsub -V diamond.sh) ;done

$ for i in $(cat list.txt);do (cd $i && cut -f2,11 pul.matches.tsv | tr '_' '\t' | cut -f1,3 | tr '\t' ';' | awk -F ";" '$2~/^[1-9]\.[0-9]+[e]/ {print}' | tr '-' '\t' | awk -F "\t" '{ if ($2 >= 4) print}' | tr '\t' '-' | tr ';' '\t' | sort | uniq -c | sort | uniq -c >> $i.matches_evalue.out) ;done
$ for i in $(cat list.txt);do (cd $i && cut -f2,11 pul.matches.tsv | tr '_' '\t' | cut -f1,3 | tr '\t' ';' | awk -F ";" '$2~/^[1-9]\.[0-9]+[e]/ {print}' | tr '-' '\t' | awk -F "\t" '{ if ($2 >= 4) print}' | tr '\t' '-' | tr ';' '\t' | cut -f1 | sort | uniq -c | awk '{print $2,$1}' >> $i.matches_counts.out) ;done
