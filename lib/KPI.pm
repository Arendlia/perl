package KPI;
use strict;
use warnings;
use Exporter qw(import);
use DBI; 

our @EXPORT_OK = qw(count_logs freq_logs);


sub count_logs {
    my $dbh = $_[0];
    my $target = $_[1];
    my $sth ="";
    # now, select all the rows from the table.

        if($target eq ""){
            $sth = $dbh->prepare("SELECT count(id) FROM logs");
            # execute the query 
            $sth->execute(); 
        }else{
            $sth = $dbh->prepare("SELECT count(id) FROM logs WHERE state=? "); 
            # execute the query 
            $sth->execute($target); 
        }
        
    
  
        
        
        # Retrieve the results of a row of data and print 
        print "\tQuery results:\n================================================\n"; 
        
        # fetch the contents of the table  
        # row by row using fetchrow_array() function 
        while (my @row = $sth->fetchrow_array())  
        { 
            print "@row\n"; 
            return (@row)
        } 
        
        # if the function cannot be execute, show a warning. 
        warn "Problem in retrieving results", $sth->errstr( ), "\n"
        if $sth->err(); 
        
        print "\n"; 
}

sub freq_logs {
    my $total = $_[0];
    my $analyse = $_[1];
    my $result = $analyse / $total;
    return $result
}