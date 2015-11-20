use strict;
use warnings;
package RT::Extension::Addressbook;

our $VERSION = '0.01';

=head1 NAME

RT-Extension-Addressbook - [One line description of module's purpose here]

=head1 DESCRIPTION

[Why would someone install this extension? What does it do? What problem
does it solve?]

=head1 RT VERSION

Works with RT [What versions of RT is this known to work with?]

[Make sure to use requires_rt and rt_too_new in Makefile.PL]

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

If you are using RT 4.2 or greater, add this line:

    Plugin('RT::Extension::Addressbook');

For RT 4.0, add this line:

    Set(@Plugins, qw(RT::Extension::Addressbook));

or add C<RT::Extension::Addressbook> to your existing C<@Plugins> line.

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=head1 BUGS

All bugs should be reported via email to

    L<bug-RT-Extension-Addressbook@rt.cpan.org|mailto:bug-RT-Extension-Addressbook@rt.cpan.org>

or via the web at

    L<rt.cpan.org|http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-Addressbook>.

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2015 by Mark Hofstetter

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

sub get_emailaddresses {
  my $dbh = RT->DatabaseHandle->dbh;
  $dbh->{FetchHashKeyName} = 'NAME_lc';
  my $sth = $dbh->prepare('select * from addressbook');  
  $sth->execute;
  return $sth->fetchall_hashref('id')
}

RT->AddStyleSheets('jquery.multiselect.css');
RT->AddStyleSheets('jquery.multiselect.filter.css');
RT->AddJavaScript('jquery.multiselect.min.js');
RT->AddJavaScript('jquery.multiselect.filter.min.js');


1;
