package Monitoring;
use strict;
use warnings;
use Exporter qw(import);
 
our @EXPORT_OK = qw(read_log list_files_folder);

sub list_files_folder {
    my $dir_path = $_[0]; 
    opendir my $dir,  $dir_path or die "Cannot open directory: $!";
    print readdir $dir;
    my @files = readdir $dir;
    closedir $dir;
}
sub read_log {
    my %logs = ();
    my $element = 0;
    my $filename = 'C:\Users\cecil\Desktop\cours\perl\logs\sample_logs.txt';
    my $event = '';
    my $message = '';
    my $date = '';
    my @tab = ();
    open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
 
        while (my $row = <$fh>) {
            chomp $row;
            if( $row =~ m/INFO/ ) {
                $event = "INFO";
            }elsif($row =~ m/ERROR/){
                $event = "ERROR";
            }else{
                $event = "WARNING";
            }
            $date=substr($row,0,21);
            $message=substr($row,21);
            $message =~ s/INFO: //;
            $message =~ s/ERROR: //;
            $message =~ s/WARNING: //;
            my %log = ( 
                'date' => $date,
	            'event' => $event, 
	            'message' => $message,  
            ); 
            $element = $element + 1;
            push(@tab, \%log);
        }
    return @tab;
}
 
 
1;