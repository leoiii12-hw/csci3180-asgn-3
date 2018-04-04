#/∗
#∗ CSCI3180 Principles of Programming Languages
#∗
#∗ --- Declaration ---
#∗
#∗ I declare that the assignment here submitted is original except for source
#∗ material explicitly acknowledged. I also acknowledge that I am aware of
#∗ University policy and regulations on honesty in academic work, and of the
#∗ disciplinary guidelines and procedures applicable to breaches of such policy
#∗ and regulations, as contained in the website
#∗ http://www.cuhk.edu.hk/policy/academichonesty/
#∗
#∗ Assignment 3
#∗ Name : Choi Man Kin
#∗ Student ID : 1155077469
#∗ Email Addr : mkchoi6@cse.cuhk.edu.hk
#∗/

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