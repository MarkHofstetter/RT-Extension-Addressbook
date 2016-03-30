use strict;
use warnings;
package RT::Extension::Addressbook;

my $config           = RT->Config->Get('Addressbook');
my $table            = $config->{table};
my $email_col        = $config->{email_col};
my $use_queue_col    = $config->{use_queue_col};
my $queue_col        = $config->{queue_col};
my $use_disabled_col = $config->{use_disabled_col};
my $disabled_col     = $config->{disabled_col};

my @where_parts = ();
push( @where_parts, "$queue_col = ?" )    if ( $use_queue_col == 1 );
push( @where_parts, "$disabled_col = 0" ) if ( $use_disabled_col == 1 );
my $where = @where_parts
            ? 'WHERE ' . join( ' AND ', @where_parts )
            : '';

my $sql = "SELECT $email_col FROM $table $where ORDER BY $email_col ASC";

sub get_addresses {
    my ($ticket) = @_;
    my $queue_id = $ticket->Queue;
    my $dbh      = RT->DatabaseHandle->dbh;
    $dbh->{FetchHashKeyName} = 'NAME_lc';
    my $sth = $dbh->prepare($sql);
    $sth->execute($queue_id) or die $sth->errstr;
    my @rows = map { $_->[0] } @{ $sth->fetchall_arrayref };
    return \@rows;
}

RT->AddStyleSheets('jquery.multiselect.css');
RT->AddStyleSheets('jquery.multiselect.filter.css');
RT->AddJavaScript('jquery.multiselect.min.js');
RT->AddJavaScript('jquery.multiselect.filter.min.js');

1;
