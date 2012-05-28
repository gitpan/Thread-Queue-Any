require 5.008;

# do we have threads or forks??
my $module;
BEGIN {
    $module=  "Thread::Queue::Any";

    require Config;
    Config->import;

    if ( !$Config{useithreads} ) {

        eval { require forks };
        if ($@) {
            print <<"TEXT";
$module requires a version of perl that has threads enabled or
which has the forks.pm module installed.
TEXT
            exit 0;
        }
    }
} #BEGIN

# set up stuff
use ExtUtils::MakeMaker;
use File::Copy qw( cp );

# set version and dependency info in blead only
eval "use Devel::Required pod => [ qw(
  lib_xblead/Thread/Queue/Any.pm
) ]";

# initializations
my @lib_tree= qw( Thread Thread/Queue );
my $postfix=  $] < 5.014 ? 'maint' : 'xblead';

# clean up lib
if ( -d 'lib' ) {
    unlink glob( "lib/$lib_tree[-1]/*" );
    unlink glob( 't/*' );
}

# make new lib
else {
    mkdir "lib";
    mkdir "lib/$_" foreach @lib_tree;
    mkdir "t";
}

# put files into place
cp "lib_$postfix/$lib_tree[-1]/$_", "lib/$lib_tree[-1]/$_"
  foreach map { m#(/[^/]+)$# } glob( "lib_$postfix/$lib_tree[-1]/*" );
cp "t_$postfix/$_", "t/$_"
  foreach map { m#(/[^/]+)$# } glob( "t_$postfix/*" );

# set up
WriteMakefile (
 NAME         => $module,
 AUTHOR       => 'Elizabeth Mattijsen (liz@dijkmat.nl)',
 ABSTRACT     => 'thread-safe queues for any data-structure',
 VERSION_FROM => 'lib/Thread/Queue/Any.pm',
 LICENSE      => 'perl',

 PREREQ_PM    => {
                    'Thread::Queue' => 0,
                    'Storable' => 0,
                   },

 clean        => { FILES => 'lib t' },
);
