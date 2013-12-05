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

Convert an excel i18n file to jQuery i18n plugin format

=head1 SYNOPSIS

./build-properties-JS-file.pl --help

./build-properties-JS-file.pl --i18n=path/to/my/file.xls --output=/tmp/js

=head1 ARGUMENTS

=over 2

=item --i18n=path/to/my/file.xls

The excel file with all the language label -> traduction

=item --output=/tmp/js

The destination folder

=cut

my ( $help, $i18n, $output );

GetOptions(
  "i18n=s"      => \$i18n,
  "output=s"    => \$output, 
  "help"        => \$help,
  )
  || pod2usage(2);

if ( $help || !$i18n || !$output ) {
  pod2usage(1);
  exit(0);
}

my $parser = HON::I18N::Converter->new(excel => $i18n );

my $header = <<EOS;
// Automatically generated by the HON-I18N-Converter project
// Please do not modify this file directly!!

EOS

$parser->build_properties_file('JS', $output, $header);