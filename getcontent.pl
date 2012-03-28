#!/usr/bin/perl
use warnings;
use strict;
use CGI;
use IPC::Cmd qw( run );

my $q = CGI->new;
print $q->header;
my $param = $q->Vars;

my $filepath = "text/$param->{'page'}.text";
unless ( -e $filepath ) {
	$filepath = "text/404.text";
}
my $cmd = ["./Markdown/Markdown.pl", $filepath];
my $output;
run(
	command	=> $cmd,
	verbose	=> 0,
	buffer	=> \$output,
	timeout => 20);

$output =~ s@.*<body>(.*)</body>.*@$1@si;
print $output;
