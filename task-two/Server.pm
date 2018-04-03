use strict;
use warnings;
 
package Server;
use Gpu;
use Task;
sub new {
}
sub task_info {
	return "task(user: ".$task->name().", pid: ".$task->pid().", time: ".$task->time().")";
}
sub task_attr {
	return $task->name(), $task->pid(), $task->time();
}
sub gpu_info {
	return "gpu(id: ".$gpu->id().")";
}
sub submit_task {
}
sub deal_waitq {
}
sub kill_task {
}
sub execute_one_time {
}
sub show {
}


return 1;