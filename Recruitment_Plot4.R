#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

genomeid <- args[1]
path <- args[2] #path to result folder
samplename <- args[3]

#print(genomeid)
namesfile <- paste (path, "/","db_id_name.txt", sep="")
#print(namesfile)
namesfile <- read.table (namesfile, sep='\t', row.names=1)
#print(namesfile)
genomename <- namesfile[genomeid,"V2"]
#print(genomename)
genomelength <- namesfile[genomeid,"V3"]
print(genomelength)

identityfile <- paste (path, "/", genomeid, "_in_", samplename, "_identities.tab", sep="")
fragplot <- read.table(identityfile, sep='\t')

imagename <- paste (path, "/","fragplot_", samplename, "_", genomeid,".png", sep="")
png(imagename,width=25,height=10,units="cm",res=600)

plot(c(1,2), c(3,4),type="n",yaxs="i", #yaxs dice que empiece el eje y justo en 0
     xlim = c(0,genomelength), ylim = c(96, 100.5), xlab = paste(genomename, genomeid, sep = " "), ylab = "Identity",
     main = samplename)

for (i in 0:length(fragplot$V1)){
  
  lines(c(fragplot$V2[i], fragplot$V2[i]+fragplot$V3[i]), c(fragplot$V4[i], fragplot$V4[i]))
}

dev.off()
