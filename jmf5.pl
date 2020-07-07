#Version 5 09/12/2017
#jmf_palpatine.pl [path to fasta file that would be the database] [path to datasets containing folder] [path to results directory that would be created] [mapper to be used: smalt or hisat2]

#$ARGV[0]= database fasta file, complete path
#$ARGV[1]= path to folder with datasets
#$ARGV[2]= path to results folder that would be created
#$ARGV[3]= mapper to use, either hisat2 or smalt
#$ARGV[4]= average genome length to use 

$run="mkdir -p $ARGV[2]";
system $run;

##0. selected mapper
my $map = $ARGV[3];

##1. contruct database index

#hisat2-build /home/acobian/frap_map/example_files/DB_viral_refseq/all_viruses.fna all_viruses
#/home/acobian/frap_map/example_files/DB_viral_refseq/all_viruses.fna
# db_id=  split by slash, take the last element, split by dot, take the first element
# smalt index example: smalt index -k 15 -s 5 /home/acobian/DBS_CF/toto2 /home/acobian/DBS_CF/all_viruses.fna

my @db_name = split (/\//,$ARGV[0]);
my $last_name = pop @db_name;
my $db_id = (split(/\./,$last_name))[0];
my $db_id_path = (split(/\./,$ARGV[0]))[0];

if ($map eq 'hisat2') {
$run="hisat2-build $ARGV[0] $db_id_path";
print "$run\n";
system $run;
} elsif ($map eq 'smalt') {
$run="smalt index -k 10 -s 5 $db_id_path $ARGV[0]";
print "$run\n";
system $run;
} else {
die "select a valid mapper";
}


##2. map datasets to database

#2.1 get ids list

$run="ls $ARGV[1] | grep 'fasta' | cut -d '.' -f1 > $ARGV[2]/IDS.txt";
system $run;

my $x = "/IDS.txt";
my $path_to_ids = $ARGV[2].$x;

open my $handle, '<', $path_to_ids;
chomp(my @IDS = <$handle>);
close $handle;

print "@IDS\n";

#2.2 map

if ($map eq 'hisat2') {

foreach(@IDS) {
$run="hisat2  -x $db_id_path -f -U $ARGV[1]/$_.fasta -S $ARGV[2]/$_"."_vs_$db_id.sam";
print "$run\n";
system $run;
}

} elsif ($map eq 'smalt') {

foreach(@IDS) {
$run="smalt map -n 20 -f sam -y 0.8 -o $ARGV[2]/$_"."_vs_$db_id.sam $db_id_path $ARGV[1]/$_.fasta";
print "$run\n";
system $run;
}

}

##3. get hits individual tables
foreach(@IDS){
               $run = "grep -v ^@ $ARGV[2]/$_"."_vs_$db_id.sam | cut -f1,3 | sort | uniq | cut -f2 | sort | uniq -c | sort -nr  | sed -e \"s/^ *//\" | tr \" \" \"\t\"  > $ARGV[2]/vs_$db_id"."_hits.$_.tab";
                print "$run\n";
                system $run;
}

##4. create number of reads per dataset table

my $tj='';

foreach(@IDS){
        $tj.=`echo -n "$_ "; grep -c ">" $ARGV[1]/$_.fasta`;
}

open OUT, '>' , "$ARGV[2]/tj.txt";
print OUT $tj;
close OUT;

##5. Normalization

$run="perl frap_normalization.pl -t $ARGV[2]/tj.txt -n -l $ARGV[4] -f $ARGV[0] $ARGV[2]/*.tab > $ARGV[2]/all_normalized.txt";
print "$run\n";
system $run;

##6. Hits  

$run="perl frap_normalization.pl -t $ARGV[2]/tj.txt -h -f $ARGV[0] $ARGV[2]/*.tab > $ARGV[2]/all_hits.txt";
print "$run\n";
system $run;


##7. Normalization million   

$run="perl frap_normalization.pl -t $ARGV[2]/tj.txt -m -l $ARGV[4] -f $ARGV[0] $ARGV[2]/*.tab > $ARGV[2]/all_normalized_per_million.txt";
print "$run\n";
system $run;
