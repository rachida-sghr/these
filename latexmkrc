# Found at http://tex.stackexchange.com/a/123438/32098
# seems to work quite well :)

$recorder = 1;
$pdf_mode = 1;
$bibtex_use = 2;
$pdflatex = "pdflatex --shell-escape %O %S";
# $pdf_previewer = "start open -a preview %O %S";

add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');

sub run_makeglossaries {
    if ( $silent ) {
        system "makeglossaries -q '$_[0]'";
    }
    else {
        system "makeglossaries '$_[0]'";
    };
}


# Custom dependency and function(s) for epstopdf package
# epstopdf =< 1.4:
# add_cus_dep( 'eps', 'pdf', 0, 'cus_dep_delete_dest' );

# epstopdf >= 1.5:
# load it as \usepackage[update,prepend]{epstopdf}
# detects an outdated pdf-image, and triggers a pdflatex-run
add_cus_dep( 'eps', 'pdf', 0, 'cus_dep_require_primary_run' );

push @generated_exts, 'glo', 'gls', 'glg';
push @generated_exts, 'acn', 'acr', 'alg';
$clean_ext .= ' %R.ist %R.xdy';
