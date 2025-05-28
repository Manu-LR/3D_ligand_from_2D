#!/bin/bash

mkdir results

for i in *.mol; do
	mkdir ${i%.*}
	cp $i ${i%.*}/
	cd  ${i%.*}/
	obabel $i -O ${i%.*}_alpha.mol2 --gen3d best -d --conformer --nconf 100 --systematic --log --ff MMFF94 |& tee -a log_obabel.txt
	echo "" >> log_obabel.txt
	obabel ${i%.*}_alpha.mol2 -O ${i%.*}_beta.mol2 --energy -d --ff MMFF94 --log --append "Energy" |& tee -a log_obabel.txt
        echo "" >> log_obabel.txt
	obabel ${i%.*}_beta.mol2 -O ${i%.*}_gamma.mol2 --minimize --steps 50000 -d --sd --ff MMFF94 --log |& tee -a log_obabel.txt
	echo "" >> log_obabel.txt
	obabel ${i%.*}_gamma.mol2 -O ${i%.*}_DEF.mol2 --partialcharge mmff94 -p 7.0 --log |& tee -a log_obabel.txt
	echo "" >> log_obabel.txt
	cp ${i%.*}_DEF.mol2 ../results/${i%.*}.mol2
	cd ..
done

