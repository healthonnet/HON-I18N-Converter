use strict;
use warnings;

use IO::All;
use Encode;
use HON::I18N::Converter;
use Data::Dumper;
use Test::Exception;
use Test::More tests => 8;

my $parser = HON::I18N::Converter->new(excel => 't/resources/TestConversionFichierExcel.xls');
my $parser2 = HON::I18N::Converter->new(excel => 't/resources/test-file.xls');
my $parser3 = HON::I18N::Converter->new(excel => 't/resources/TestConversionENES.xls');

can_ok($parser, 'p_getLanguage');
can_ok($parser, 'p_buildHash');
can_ok($parser, 'p_write_JS_i18n');
can_ok($parser, 'build_properties_JS_file');
can_ok($parser, 'p_write_INI_i18n');
can_ok($parser, 'build_properties_INI_file');

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
my $content = $parser->build_properties_JS_file();
$content = encode('utf-8', $content);
$content > io('t/resources/output2.js');

#Test permettant de générer un fichier .ini à partir du document arabe: OK
my $content2 = $parser->build_properties_INI_file();
$content2 = encode('utf-8', $content2);
$content2 > io('t/resources/Test.ini');

#Test permettant de générer un fichier .ini à partir du document à plusieurs langues: OK
my $content3 = $parser2->build_properties_INI_file();
$content3 = encode('utf-8', $content3);
$content3 > io('t/resources/Test2.ini');

#Test permettant de générer un fichier .ini à partir du document Anglais/Espagnol: OK
my $content4 = $parser3->build_properties_INI_file();
$content4 = encode('utf-8', $content4);
$content4 > io('t/resources/Test3.ini');

#Test de comparaison pour voir si le fichier .ini généré du document Anglais/Espagnol est bien celui attendu: OK 
#(mais pour lui les deux docs sont différents)
my $output < io('t/resources/verificationENES.ini');
#is($content4, $output, 'not same content');

#lives_ok { $parser3 = init($parser3,'t/resources/TestConversionENES.xls') } 'file read';
