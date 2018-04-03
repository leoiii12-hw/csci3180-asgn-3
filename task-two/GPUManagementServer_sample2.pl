use strict;
use warnings;

package GPUManagementServer;
use Server;

my $server = Server->new(3);
$server->show();
$server->submit_task("liz", 6);
$server->execute_one_time();
$server->show();
$server->submit_task("lin", 4);
$server->submit_task("lin", 5);
$server->execute_one_time();
$server->show();
$server->submit_task("liz", 5);
$server->execute_one_time();
$server->show();
$server->kill_task("liz", 1);
$server->kill_task("liz", 3);
$server->execute_one_time();
$server->show();
$server->submit_task("lin", 3);
for my $i (0..3) {
	$server->execute_one_time();
	$server->show();	
}

