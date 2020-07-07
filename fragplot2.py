# coding=utf-8
#!/usr/bin/python

import re, glob, sys, shutil #importing regular expressions and glob to find files and shutil


path_to_database = sys.argv[1]
path = sys.argv[2] #path to results folder
print path
IDS= [] #empty list to keep the IDS of the genomes

shutil.copyfile(path_to_database+"/"+"db_id_name.txt", path+"/"+"db_id_name.txt")

with open(path+"/"+"db_id_name.txt", "r") as idfile: #opening the IDs file
	for line in idfile:
		IDS.append(line.split("\t")[0]) #getting the first column, which has the IDS


print IDS


samfiles = glob.glob(path+"/"+"*sam") #list of samfiles

print samfiles

for GenomeID in IDS: #for each genome, go through all the proccess
	
	for samfile in samfiles: #for each genome, go through all the samfiles

		metaID = samfile.split("/")[-1].split("_vs_")[0] #arreglar, si el metagenoma no tiene barrabaja no funciona. O poner un aviso al principio del código
		
		outfile = open(path+"/"+GenomeID+"_in_"+metaID+"_identities.tab", "a") #one output per Genome and metagenome
		for line in open(samfile).readlines():
			if not line.startswith("@"):
				if line.split("\t")[2] == GenomeID:


					CIGAR = (line.split("\t")[5]) #the CIGAR is in the 6th position of the line 

					NM = int(line.split("\t")[11].split(":")[2]) #the NM are in the 12th position, we only need which is behind the second colons

					Matches = re.findall(r"(\d*)M", CIGAR) #matches (and mismatches) are next to the Ms

					Insertions = re.findall(r"(\d*)I", CIGAR) #insertions are next to I

					Deletions = re.findall(r"(\d*)D", CIGAR) #Deletions are nex to D

					Soft = re.findall(r"(\d*)S", CIGAR) #Soft clipped nucleotides

					Start = (line.split("\t")[3])

					#now, it counts numbers of M, I, S and D
					M = 0 #restarting the counter
					for number in Matches:
						number = int(number)
						M+=number

					I = 0 #restarting the counter
					for number in Insertions:
						number = int(number)
						I+=number

					S = 0 #restarting the counter
					for number in Soft:
						number = int(number)
						S+=number

					D=0 #restarting the counter
					for number in Deletions:
						number = int(number)
						D+=number

					Hits = float(M-NM) #

					Length = M+S+I

					Identity = (Hits/Length)*100

				

					output = GenomeID+"\t"+Start+"\t"+str(Length)+"\t"+str(Identity)+"\n" #formatting the output

					#print output

					outfile.write(output) #writing the output
