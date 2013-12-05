use strict;
use warnings;

use IO::All;
use File::Compare;
use File::Temp qw/tempfile tempdir/;
use HON::I18N::Converter;

use Test::File;
use Test::More tests => 6;

my $data = [
  {
    'file'     => 't/resources/1-language/input/file.xls',
    'language' => ['en'],
    'output'   => 't/resources/1-language/output/'
  },
  {
    'file'     => 't/resources/3-language/input/file.xls',
    'language' => [ 'en', 'fr', 'it' ],
    'output'   => 't/resources/3-language/output/'
  }
];

foreach my $row ( @{$data} ) {
  my $dir = File::Temp->newdir();
  my $converter = HON::I18N::Converter->new( excel => $row->{'file'} );
  $converter->build_properties_file('JS', $dir, '');
  
    file_exists_ok( $dir.'/jQuery-i18n.js' );
    file_not_empty_ok( $dir.'/jQuery-i18n.js'  );
    
    is( 
      compare(
        $row->{'output'}.'/i18n.js' , 
        $dir.'/jQuery-i18n.js' 
      ), 
      0, 
      'not the same file'
    );
}