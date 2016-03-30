use strict;
use warnings;
package RT::Extension::Addressbook;

our $VERSION = '0.01';
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

# ABSTRACT: An extension to Best Practical Request Tracker (https://www.bestpractical.com/rt/) which creates a dropdown for adding multiple recipients in a reply form.

=head1 RT VERSION

Works with RT > 4.4.0

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

may need root permissions

=item Edit F</opt/rt4/etc/RT_SiteConfig.pm>

    Plugin('RT::Extension::Addressbook');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=item Create DB table

    CREATE TABLE Addressbooks (
        id INT NOT NULL AUTO_INCREMENT,
        queue_id INT NOT NULL,
        name VARCHAR(512) NOT NULL,
        email VARCHAR(512) NOT NULL,
        PRIMARY KEY(id),
        FOREIGN KEY(queue_id) REFERENCES Queues(id)
    );
    INSERT INTO Addressbooks
        (name, email, queue_id)
    VALUES
        ('Mark Hofstetter', 'mark@hofstetter.at', 1),
        ('David Schmidt', 'davewood@gmx.at', 1);


=back

=head1 CONFIGURATION

You can override the defaults (see etc/Addressbook_Config.pm) in your etc/RT_SiteConfig.pm

=head1 AUTHOR

Mark Hofstetter, University of Vienna E<lt>mark@hofstetter.atE<gt>.

=head1 CONTRIBUTORS

David Schmidt, University of Vienna E<lt>davewood@gmx.atE<gt>.

=head1 BUGS

All bugs should be reported via the web at

    L<https://github.com/MarkHofstetter/RT-Extension-Addressbook/issues>.

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2015 by Mark Hofstetter

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

my $config    = RT->Config->Get('Addressbook');
my $table     = $config->{table};
my $email_col = $config->{email_col};
my $sql       = "SELECT $email_col FROM $table WHERE queue_id = ? ORDER BY $email_col ASC";

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
