#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;
use IO::All -utf8;

use HON::I18N::Converter;

=head1 NAME

build-properties-JS-file.pl

=head1 DESCRIPTION

build the javascript file and the .js file for the Search Engine language

=head1 SYNOPSIS

./build-rss-valid-link.pl --help

./build-properties-JS-file.pl --i18n=i18n/TestConversionENES.xls --output=/Users/chahlalsamia/Desktop/ENES.js

=head1 ARGUMENTS

=over 2

=item --i18n=i18n/TestConversionENES.xls

The excel file with all the language label -> traduction

=item --output=/Users/chahlalsamia/Desktop/ENES.js

The output javascript file

=cut

my ( $help, $i18n, $output );

GetOptions(
  "i18n=s"      => \$i18n,
  "output=s"    => \$output, 
  "help"        => \$help,
  )
  || pod2usage(2);

if ( $help || !$i18n ) {
  pod2usage(1);
  exit(0);
}

my $parser = HON::I18N::Converter->new(excel => $i18n );

my $content = <<EOS;
// Automatically generated by the HON-I18N-Converter project
// Please do not modify this file directly!!
// See http://tools.hon.ch/jenkins/job/Build%20HON-SearchEngine-i18n/ for more info.

EOS

$content .= $parser->build_properties_JS_file();

if ($output){
  $content > io($output);
} else{
  print $content;
}