require 5.008;

# do we have threads or forks??
my $module;
BEGIN {
    $module = "Thread::Queue::Any";

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
}

# set up stuff
use ExtUtils::MakeMaker;

# set version and dependency info
eval "use Devel::Required";

# set up
WriteMakefile (
 NAME           => $module,
 AUTHOR		=> 'Elizabeth Mattijsen (liz@dijkmat.nl)',
 ABSTRACT	=> 'thread-safe queues for any data-structure',
 VERSION_FROM	=> 'lib/Thread/Queue/Any.pm',
 PREREQ_PM	=> {
                    'Thread::Queue' => 0,
                    'Storable' => 0,
                   },
);
