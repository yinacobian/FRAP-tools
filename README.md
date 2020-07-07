# FRAP-tools
Fragment Recruitment plots from FRAP 

1. Download this repository

`git clone https://github.com/yinacobian/FRAP-tools.git`

2. Go to the FRAP-tools folder

`cd FRAP-tools`

3. Create a directory for the reference genomes

`mkdir DB`

4. Create a directory for the datasets

`mkdir DS`

5. Create a multifasta file with all the genomes for which you want Fragment Recruitment plots

  The header of each fasta file should have an ID and a sequence description, there should be an space between the ID and the sequence description
  
  Put the multifasta file inside the reference genomes directory
  
6. Put the dataset inside the datasets directory

7. Get the name of the dataset (anything that is before .fasta)

8. Run fragplot2.sh

The arguments for fragplot2.sh are: 

* [path to database containing folder] $1
* [database fasta file name] $2
* [path to dataset containing folder] $3
* [path to output folder] $4
* [dataset name] $5

`bash fragplot2.sh ~/FRAP-tools/DB genomes.fasta ~/FRAP-tools/DS ~/FRAP-tools/results dataset1`
