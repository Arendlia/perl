package Alert;
use strict;
use warnings;
use Exporter qw(import);
use Net::SMTP;
use Cwd;
use Data::Dumper;
use File::Slurp;
use YAML::XS 'LoadFile';
use feature 'say';

my $config = LoadFile('config.yaml');
 
our @EXPORT_OK = qw(init_smtp send_email close_smtp);

sub init_smtp {
    my $smtp = Net::SMTP->new($config->{smtp}, 'Hello'=>$config->{smtp}, 'Debug' =>1, 'Port'=>$config->{port}) or die 'Impossible de se connecter au serveur : ' . $!;
    return $smtp;
}

sub send_email {
    my $smtp = $_[0]; 
    my $to = $_[1]; 
    my $message = $_[2];
    my $cc = $_[3]; 
    $smtp->auth(  $config->{smtp_auth}, $config->{smtp_psswd} );
    $smtp->mail('cecilia.ruin@gmail.com') or die 'Un problème est survenu avec la méthode mail() !';
    $smtp->to($to) or die 'Un problème est survenu avec la méthode to() !';
    if ($cc ne ""){
         $smtp->cc($cc) or die 'Un problème est survenu avec la méthode cc() !';
    }
    $smtp->data() or die 'Un problème est survenu avec la méthode data() !';
    $smtp->datasend($message) or die 'Un problème est survenu avec la méthode datasend() !';
    $smtp->dataend() or die 'Un problème est survenu avec la méthode dataend() !';
}

sub close_smtp {
    my $smtp = $_[0]; 
    $smtp->quit() or die 'Un problème est survenu avec la méthode quit() !';
}
