package Database;
use strict;
use warnings;
use Exporter qw(import);
use DBI; 
use YAML::XS 'LoadFile';
use feature 'say';

my $config = LoadFile('config.yaml');
our @EXPORT_OK = qw(init_bdd insert_bdd select_bdd update_bdd delete_bdd disconnect_bdd);

sub init_bdd {
    my $user = $_[0]; 
    my $psswd = $_[1];
    # connect to MySQL database 
    my $dbh = DBI->connect ("DBI:mysql:$config->{mysql_database}", 
                        $user, 
                        $psswd)  
                        or die "Can't connect to database: $DBI::errstr\n"; 
  
    print "connected to the database\n"; 
    return $dbh;
}

sub insert_bdd {
    my $dbh = $_[0];
    # define the variables to be inserted 
    # into the table 
    my $message = $_[1]; 
    my $date = $_[2]; 
    my $state = $_[3]; 
    my $sth = $dbh->prepare("INSERT INTO logs(message, date, state) 
                        VALUES(?, ?, ?)"); 
    # insert these values into the emp table. 
    $sth->execute($message, $date, $state); 
  
    print "Successfully inserted values into the table\n"; 
}

sub select_bdd {
    my $dbh = $_[0];
    my $champ = $_[1];
    my $target = $_[2];
    my $sth ="";
    # now, select all the rows from the table.
    if ($champ eq "state") {
        $sth = $dbh->prepare("SELECT * FROM logs WHERE state=? "); 
    }elsif ($champ eq "id") {
        $sth = $dbh->prepare("SELECT * FROM logs WHERE id=? "); 
    }elsif ($champ eq "date") {
        $sth = $dbh->prepare("SELECT * FROM logs WHERE date=? "); 
    }
    
  
        # execute the query 
        $sth->execute($target); 
        
        # Retrieve the results of a row of data and print 
        print "\tQuery results:\n================================================\n"; 
        
        # fetch the contents of the table  
        # row by row using fetchrow_array() function 
        while (my @row = $sth->fetchrow_array())  
        { 
            print "@row\n"; 
        } 
        
        # if the function cannot be execute, show a warning. 
        warn "Problem in retrieving results", $sth->errstr( ), "\n"
        if $sth->err(); 
        
        print "\n"; 
}

sub update_bdd {
    my $dbh = $_[0];
    # define the variables to be updated 
    # into the table 
    my $message = $_[1]; 
    my $date = $_[2]; 
    my $state = $_[3]; 
    my $id = $_[4]; 
    my $sth = $dbh->prepare("UPDATE logs 
                        SET message = ?, date = ?, state=? WHERE id = ?"); 
    # insert these values into the logs table. 
    $sth->execute($message, $date, $state, $id); 
  
    print "Successfully updated values into the table\n"; 
}

sub delete_bdd {
    my $dbh = $_[0];
    # define the variables to be deleted 
    # into the table 
    my $id = $_[1]; 
    my $sth = $dbh->prepare("DELETE FROM logs WHERE id = ?"); 
    # delete these values into the logs table. 
    $sth->execute($id); 
  
    print "Successfully deleted values into the table\n"; 
}
sub disconnect_bdd {
    my $dbh = $_[0];
    $dbh->disconnect;
}

1;
