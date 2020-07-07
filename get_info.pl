#!/usr/bin/perl
#from a multifasta, get a file with id, name and size of each sequence

my $oldhead=<>;
my $seq = '';
chomp($oldhead);
$oldhead=~s#^>##;
while (<>) {
	chomp;
	if (s/^>//) {
		my @fields = split(/\s+/, $oldhead);
		$id = shift(@fields);
		$name = join(' ',@fields);
		$size = length($seq);
		print "$id\t$name\t$size\n";
		$size=0;
		$seq = '';
		$oldhead = $_;
	} else {
		$seq = $seq.$_;
	}
}
my @fields = split(/\s+/, $oldhead);
$id = shift(@fields);
$name = join(' ',@fields);
$size = length($seq);
print "$id\t$name\t$size\n";

