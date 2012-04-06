#!/usr/bin/perl
use warnings;
use strict;
use CGI;
use IPC::Cmd qw( run );

my $q = CGI->new;
print $q->header;
my $param = $q->Vars;

my $path_template = "../htdocs/md/%s";

#	Setup the file path for the requested page.
#	Default to index page.
my $filepath = sprintf($path_template,"index");
if (defined $param->{'page'}) {
	$filepath = sprintf($path_template,$param->{'page'});
}

# use index page if there is a folder with requested name
if ( -e $filepath ) {
	$filepath = $filepath."/index.text";
} else {
	$filepath = $filepath.".text";
}

#	If the file requested doesn't exist show a 404.
unless ( -e $filepath ) {
	$filepath = sprintf($path_template,"etc/404.text");
}

#	Convert the tile from Markdown to HTML
my $cmd = ["./Markdown/Markdown.pl", $filepath];
my $output;
run(
	command	=> $cmd,
	verbose	=> 0,
	buffer	=> \$output,
timeout => 20);

#	Scrape the content of the page.
$output =~ s@.*<body>(.*)</body>.*@$1@si;

#	And output the result.
print $output;
