#!/bin/bash
##FRAP and Fragment Recruitment Plots 

#To run do: thisscrit.sh 
#[path to database containing folder] $1
#[database fasta file name] $2
#[path to dataset containing folder] $3
#[path to output folder] $4
#[dataset name] $5

#bash fragplot.sh ....
#bash fragplot.sh /home/acobian/cobian2018_CFRR/mg/P10_frap_plots_bacteria/CF01mgD8/DB bacteriagenomes.fasta /home/acobian/cobian2018_CFRR/mg/P03_polished/CF01mgD8 /home/acobian/cobian2018_CFRR/mg/P10_frap_plots_bacteria/CF01mgD8/vsbacteria polished_CF01mgD8

# $1 is the database complete path 
# $2 is database fasta file
# $3 is the path to the dataset containing folder
# $4 is the output folder 
# $5 dataset name 

#1. use FRAP 
#perl jmf5.pl /home/acobian/cobian2018_CFRR/mg/P10_frap_plots_bacteria/CF418mg05182018/DB/bacteriagenomes.fasta /home/acobian/cobian2018_CFRR/mg/P03_polished/CF418/ /home/acobian/cobian2018_CFRR/mg/P10_frap_plots_bacteria/CF418mg05182018/vsbacteria smalt 50000
perl jmf5.pl $1/$2 $3 $4 smalt 50000

#2. Make db_id_name file in the results folder
#perl get_info.pl /home/acobian/cobian2018_CFRR/mg/P10_frap_plots_bacteria/CF418mg05182018/DB/bacteriagenomes.fasta > /home/acobian/cobian2018_CFRR/mg/P10_frap_plots_bacteria/CF418mg05182018/vsbacteria/db_id_names.txt
perl get_info.pl $1/$2 > $4/db_id_name.txt
cp $4/db_id_name.txt $1/db_id_name.txt

#3. Make top10_dbid.txt file in the results folder, containing the IDS for which plots will be made
cut -f 1 $4/db_id_name.txt > $4/top10_dbid.txt

#4. Get identity files
#python fragplot2.py /home/acobian/cobian2018_CFRR/mg/P10_frap_plots_bacteria/CF418mg05182018/DB /home/acobian/cobian2018_CFRR/mg/P10_frap_plots_bacteria/CF418mg05182018/vsbacteria
python fragplot2.py $1 $4

#5. Make plots
#Rscript Recruitment_Plot3.R CP014028.2 /home/acobian/cobian2018_CFRR/mg/P10_frap_plots_bacteria/CF418mg05182018/vsbacteria CP014028.2_in_polished_CF418mg05182018_identities.tab
cat $4/top10_dbid.txt | xargs -I{ID} sh -c "Rscript Recruitment_Plot4.R {ID} $4 $5" 
