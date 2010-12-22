#!/usr/bin/perl 
$| = 1;
$DEBUG=1;
print STDERR "Starting rewrite engine\n" if $DEBUG;
my $cfg = { 'basedir'=> "/software/data/factory" };
while (<>) {
    my $output="";
    chomp();
    print STDERR "input: $_\n" if $DEBUG;
    if( $_ eq '' ){
        $output = "data_idx/$_\n";
    }elsif( ! -f "$cfg->{'basedir'}/data_idx/$_" ){
        print STDERR "$cfg->{'basedir'}/data_idx/$_ does not exist...\n" if $DEBUG;
        $output = "data_idx/$_\n";
    }else{
        print STDERR "$cfg->{'basedir'}/data_idx/$_ found!\n" if $DEBUG;
        open(KEYFILE, "$cfg->{'basedir'}/data_idx/$_") || die "cannot open file for reading @!";
        my $line=<KEYFILE>;
        close(KEYFILE);
        if($line=~m/^(([0-9a-f]{4,4})([0-9a-f]{4,4})([0-9a-f]{4,4})([0-9a-f]+))/){
            $output = "data_cas/$2/$3/$4/$1\n";
        }else{
            #s|^.*|mediacas/incoming/test/test2.jpg|;
            $output = "data_idx/$_\n";
        }
    }
    print STDERR "mod_rewrite: $output";
    print "$output";
}
