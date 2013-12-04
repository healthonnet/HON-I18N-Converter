use strict;
use warnings;

use Data::Dumper;
use HON::I18N::Converter;

use Test::More tests => 9;

my $converter =
  HON::I18N::Converter->new( excel => 't/resources/1-language/input/file.xls' );

can_ok( $converter, 'p_getLanguage' );
can_ok( $converter, 'p_buildHash' );
can_ok( $converter, 'p_write_JS_i18n' );
can_ok( $converter, 'p_write_INI_i18n' );
can_ok( $converter, 'build_properties_file' );

my $data = [
  {
    'file'     => 't/resources/1-language/input/file.xls',
    'language' => ['en'],
    'labels'   => {
      'en' => {
        'ALL'    => 'All',
        'CANCER' => 'Cancer'
      },
    },
  },
  {
    'file'     => 't/resources/3-language/input/file.xls',
    'language' => [ 'en', 'fr', 'it' ],
    'labels'   => {
      'en' => {
        'ALL'    => 'All',
        'CANCER' => 'Cancer'
      },
      'fr' => {
        'ALL'    => 'Tout',
        'CANCER' => 'Cancer'
      },
      'it' => {
        'ALL'    => 'Tutto',
        'CANCER' => 'Cancro'
      },
    },
  }
];

foreach my $row ( @{$data} ) {

  $converter = HON::I18N::Converter->new( excel => $row->{'file'} );
  my @listLanguage = $converter->p_getLanguage();
  $converter->p_buildHash( \@listLanguage );
  shift @listLanguage;
  my $hash = $converter->labels();
  
  is_deeply( \@listLanguage, $row->{'language'}, 'wrong languages' );
  is_deeply( $hash, $row->{'labels'}, 'wrong labels' );
}

__END__

use File::Temp qw/ tempfile tempdir /;
use IO::All;
use Encode;

use Data::Dumper;
use Test::File;
use Test::Exception;


my $dir = File::Temp->newdir();
warn $dir;

$converter->build_properties_file('JS', $dir);

file_exists_ok( $dir.'/en.js' );




my $parser = HON::I18N::Converter->new(excel => 't/resources/TestConversionFichierExcel.xls');
my $parser2 = HON::I18N::Converter->new(excel => 't/resources/test-file.xls');
my $parser3 = HON::I18N::Converter->new(excel => 't/resources/TestConversionENES.xls');



my @languages = ('ar');

my @langs = $parser->p_getLanguage();
$parser->p_buildHash(\@langs);
my @langs2 = $parser2->p_getLanguage();
$parser2->p_buildHash(\@langs2);
my @langs3 = $parser3->p_getLanguage();
$parser3->p_buildHash(\@langs3);

shift @langs;

is_deeply(\@langs,\@languages, 'bad languages' );

my $data = [
  { 'label' => 'CHILD', 'lang' => 'ar', 'value' => 'طفل' },
];

my $hash = $parser->labels();
foreach my $row (@{$data}){
  is($hash->{$row->{lang}}->{$row->{label}}, decode('utf-8', $row->{value}), 'wrong label in hash');
}

#affichage de la valeur d'une variable
#warn Dumper $parser->labels;

#Test permettant de générer un fichier javascript à partir du document arabe: OK
#my $content = $parser->build_properties_file('JS');
#$content = encode('utf-8', $content);
#$content > io('t/resources/output2.js');

#Test permettant de générer un fichier .ini à partir du document arabe: OK
my $content2 = $parser->build_properties_file('INI', 't/resources/');

#Test permettant de générer un fichier .ini à partir du document à plusieurs langues: OK
my $content3 = $parser2->build_properties_file('INI', 't/resources/');

#Test permettant de générer un fichier .ini à partir du document Anglais/Espagnol: OK
my $content4 = $parser3->build_properties_file('INI', 't/resources/');

#Test permettant de générer un fichier .ini à partir du document Anglais/Espagnol: 
my $content5 = $parser3->build_properties_file('INI', 't/resources/');

#Test permettant de générer un fichier .js à partir du document à plusieurs langues:
my $content6 = $parser2->build_properties_file('JS', 't/resources/');

#Test de comparaison pour voir si le fichier .ini généré du document Anglais/Espagnol est bien celui attendu: OK 
#(mais pour lui les deux docs sont différents)
#my $output < io('t/resources/verificationENES.ini');
#is($content4, $output, 'not same content');

#Test pour vérifier les noms de fichiers
dies_ok { HON::I18N::Converter->new($parser3,'t/resources/foobar.xls') } 'file read';
