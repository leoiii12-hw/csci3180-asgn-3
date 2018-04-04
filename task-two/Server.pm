use strict;
use warnings;

package Server;

use Gpu;
use Task;

our $task = undef;
our $gpu = undef;

sub new {
    my $class = $_[0];
    my $gpu_num = $_[1];

    my @gpus = ();
    for my $i (1 .. $gpu_num) {
        my $gpu = Gpu->new();
        push @gpus, $gpu;
    }

    my @waitq = ();

    my @tasks = ();

    my $object = bless { "gpus" => \@gpus, "waitq" => \@waitq, "tasks" => \@tasks }, $class;

    return $object;
}

sub submit_task {
    my $self = $_[0];
    my $name = $_[1];
    my $time = $_[2];

    local $task = Task->new($name, $time);
    print($self->task_info());
    print(" => ");

    my $idle_gpu = undef;

    my @gpus = @{$self->{"gpus"}};
    for my $i (0 .. $#gpus) {
        my $gpu = $gpus[$i];

        if ($gpu->state() == 0) {
            $idle_gpu = $gpu;
            last;
        }
    }

    if (defined($idle_gpu)) {
        $idle_gpu->assign_task($task);

        local $gpu = $idle_gpu;
        print($self->gpu_info());
    }
    else {
        my @waitq = @{$self->{"waitq"}};
        push @waitq, $task;
        $self->{"waitq"} = \@waitq;

        print("waiting queue");
    }

    print("\n");
}

sub kill_task {
    my $self = $_[0];
    my $name = $_[1];
    my $pid = $_[2];

    print("user " . $name . " kill ");

    # tasks in gpus
    my @gpus = @{$self->{"gpus"}};
    for my $i (0 .. $#gpus) {
        my $gpu = $gpus[$i];
        my $gpu_task = $gpu->task();

        if ($gpu_task->pid() == $pid && $gpu_task->name() eq $name) {
            local $task = $gpu->task();
            print($self->task_info());
            print("\n");

            $gpu->release();
            $self->deal_waitq();

            return;
        }
    }

    # tasks in waitq
    my @waitq = @{$self->{"waitq"}};
    for my $i (0 .. $#waitq) {
        my $checking_task = $waitq[$i];

        if ($checking_task->pid() == $pid && $checking_task->name() eq $name) {
            splice(@waitq, $i, 1);

            local $task = $checking_task;
            print($self->task_info());
            print("\n");

            $self->{"waitq"} = \@waitq;

            return;
        }
    }

    print("task(pid: " . $pid . ") fail\n");
}

sub deal_waitq {
    my $self = $_[0];

    my @waitq = @{$self->{"waitq"}};

    my $num_of_tasks = @waitq;
    if ($num_of_tasks == 0) {
        return;
    }

    my @gpus = @{$self->{"gpus"}};
    for my $i (0 .. $#gpus) {
        my $checking_gpu = $gpus[$i];

        if ($checking_gpu->state() == 0) {

            my $num_of_tasks = @waitq;
            if ($num_of_tasks > 0) {
                local $task = shift @waitq;
                print($self->task_info());
                print(" => ");

                local $gpu = $checking_gpu;
                print($self->gpu_info());

                print("\n");

                $checking_gpu->assign_task($task);
            }
        }
    }

    $self->{"waitq"} = \@waitq;
}

sub execute_one_time {
    my $self = $_[0];

    print("execute_one_time..\n");

    my @gpus = @{$self->{"gpus"}};
    for my $i (0 .. $#gpus) {
        my $gpu = $gpus[$i];

        $gpu->execute_one_time();
    }

    $self->deal_waitq();
}

sub show {
    my $self = $_[0];

    print("==============Server Message================\n");
    print("gpu-id  state  user  pid  tot_time  cur_time\n");

    # gpus
    my @gpus = @{$self->{"gpus"}};
    for my $i (0 .. $#gpus) {
        my $gpu = $gpus[$i];

        print($gpu->message());
        print("\n");
    }

    # waitq
    my @waitq = @{$self->{"waitq"}};
    for my $i (0 .. $#waitq) {
        my $task = $waitq[$i];

        print("        wait   " . $task->name() . "    " . $task->pid() . "      " . $task->time());
        print("\n");
    }

    print("============================================\n\n");

}

sub task_info {
    return "task(user: " . $task->name() . ", pid: " . $task->pid() . ", time: " . $task->time() . ")";
}

sub task_attr {
    return $task->name(), $task->pid(), $task->time();
}

sub gpu_info {
    return "gpu(id: " . $gpu->id() . ")";
}

return 1;