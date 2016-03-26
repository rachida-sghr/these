# Found at http://tex.stackexchange.com/a/123438/32098
# seems to work quite well :)

$recorder = 1;
$pdf_mode = 1;
$bibtex_use = 2;
$pdflatex = "pdflatex --shell-escape %O %S";
# $pdf_previewer = "start open -a preview %O %S";

add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('glo2', 'gls2', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');
add_cus_dep('slo', 'sls', 0, 'run_makeglossaries');

sub run_makeglossaries {
    $dir = dirname($_[0]);
    $file = basename($_[0]);
    if ( $silent ) {
        system "makeglossaries -q -d '$dir' '$file'";
    }
    else {
        system "makeglossaries -d '$dir' '$file'";
    };
}

add_cus_dep('idx', 'ind', 0, 'texindy');
sub texindy{
    system("texindy -L french \"$_[0].idx\"");
}

add_cus_dep( 'eps', 'pdf', 0, 'cus_dep_require_primary_run' );

@generated_exts = qw(aux idx ind lo* out toc acn acr alg bbl bcf fls gl* ist run.xml sbl* sl* sym* xdy unq synctex.gz mw *~);
