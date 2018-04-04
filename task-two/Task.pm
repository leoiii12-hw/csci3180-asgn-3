use strict;
use warnings;

package Task;

our $new_pid = 0;

sub new {
    my $class = $_[0];
    my $name = $_[1];
    my $time = $_[2];

    my $object = bless { "pid" => $new_pid, "name" => $name, "time" => $time }, $class;

    $new_pid = $new_pid + 1;

    return $object;
}

sub pid {
    my $self = $_[0];

    return $self->{"pid"};
}

sub name {
    my $self = $_[0];

    return $self->{"name"};
}

sub time {
    my $self = $_[0];

    return $self->{"time"};
}


return 1;