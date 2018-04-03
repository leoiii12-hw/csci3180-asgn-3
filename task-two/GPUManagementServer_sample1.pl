use strict;
use warnings;

package GPUManagementServer;
use Server;

my $server = Server->new(2);
$server->show();
$server->submit_task("lin", 6);
$server->execute_one_time();
$server->show();
$server->submit_task("liz", 4);
$server->execute_one_time();
$server->show();
$server->submit_task("liz", 5);
$server->execute_one_time();
$server->show();
$server->kill_task("liz", 1);
$server->execute_one_time();
$server->show();
$server->submit_task("lin", 4);
for my $i (0..5) {
	$server->execute_one_time();
	$server->show();	
}

