use strict;
use warnings;
use lib './lib/';
use Monitoring qw(read_log list_files_folder);
use Alert qw(init_smtp send_email close_smtp);
use Database qw(init_bdd insert_bdd select_bdd update_bdd delete_bdd disconnect_bdd);
use KPI qw(count_logs freq_logs);
use YAML::XS 'LoadFile';
use feature 'say';

my $config = LoadFile('config.yaml');

list_files_folder("C:\\Users\\cecil\\Desktop\\cours\\perl\\logs\\");
my @tab = read_log();
my $str_error = "";
my $str_warning = "";
my $element = 0;
my $db = init_bdd($config->{mysql_user},$config->{mysql_pswd});
foreach (@tab) {
	my $log_ref = $tab[$element];
    my %log = %{$log_ref};  
    $element = $element + 1;
    if ($log{event} ne "INFO") {
        if ($log{event} eq "WARNING"){
            $str_warning = $str_warning . "$log{date}  $log{event}  $log{message}\n";
            insert_bdd($db, $log{message}, $log{date}, $log{event})
        }elsif($log{event} eq "ERROR"){
            $str_error = $str_error . "$log{date}  $log{event}  $log{message}\n";
            insert_bdd($db, $log{message}, $log{date}, $log{event})
        }
    }
}
    my $smtp = init_smtp();
    if ($str_warning ne ""){
        send_email($smtp,'technicien@quackcode-technologies.com',$str_warning,"");
    }if ($str_error ne ""){
        send_email($smtp,'technicien@quackcode-technologies.com',$str_error,'administrateur@quackcode-technologies.com');
    }

    close_smtp($smtp);
    select_bdd($db, 'state', 'WARNING');
    my @nb_total = count_logs($db, '');
    my @nb_warning = count_logs($db, 'WARNING');
    my @nb_error = count_logs($db, 'ERROR');
    my $freq_error = freq_logs(@nb_total[0],@nb_error[0]);
    my $freq_warning = freq_logs(@nb_total[0],@nb_warning[0]);
    print "total erreur/warning: @nb_total , total warning:@nb_warning[0], total erreur:@nb_error[0]\n";
    print "frequence erreur : $freq_error , frequence warning :$freq_warning\n";
    update_bdd($db, 'test', '12-08-2001', 'WARNING',1);
    delete_bdd($db,1);
    disconnect_bdd($db)


