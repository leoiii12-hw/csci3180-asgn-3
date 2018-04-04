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

package Gpu;

use Task;

our $new_id = 0;

sub new {
    my $class = $_[0];

    my $object = bless { "id" => $new_id, "state" => 0 }, $class;

    $new_id = $new_id + 1;

    return $object;
}

sub id {
    my $self = $_[0];

    return $self->{"id"};
}

sub state {
    my $self = $_[0];

    return $self->{"state"};
}

sub task {
    my $self = $_[0];

    return $self->{"task"};
}

sub message {
    my $self = $_[0];

    my $id = $self->{"id"};
    my $state = $self->{"state"};

    if ($state == 0) {
        return "  " . $id . "     " . "idle";
    }

    my $task = $self->{"task"};

    my $user = $task->name();
    my $pid = $task->pid();
    my $cur_time = $self->{"time"};
    my $tol_name = $task->time();

    return "  " . $id . "     " . "busy   " . $user . "    " . $pid . "      " . $tol_name . "         " . $cur_time;
}

sub assign_task {
    my $self = $_[0];
    my $task = $_[1];

    $self->{"state"} = 1;
    $self->{"time"} = 0;
    $self->{"task"} = $task;
}

sub release {
    my $self = $_[0];

    $self->{"state"} = 0;
    $self->{"time"} = 0;
    $self->{"task"} = undef;
}

sub execute_one_time {
    my $self = $_[0];
    my $task = $self->task();

    if (!defined($task)) {
        return;
    }

    my $cur_time = $self->{"time"};
    my $tot_time = $task->time();

    if ($cur_time < $tot_time) {
        $self->{"time"} = $cur_time + 1;

        if ($self->{"time"} == $tot_time) {
            print("task in gpu(id: " . $self->id() . ") finished\n");
            $self->release();
        }
    }
}

return 1;
