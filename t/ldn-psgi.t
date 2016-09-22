=pod

=encoding utf-8

=head1 PURPOSE

Test that RDF::LinkedData::Notifications compiles.

=head1 AUTHOR

Kjetil Kjernsmo E<lt>kjetilk@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2016 by Kjetil Kjernsmo.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.


=cut

use strict;
use warnings;
use Test::More;
use Test::RDF;
use Test::WWW::Mechanize::PSGI;
use Module::Load::Conditional qw[can_load];


my $tester = do "script/ldn.psgi";

BAIL_OUT("The application is not running") unless ($tester);

use Log::Any::Adapter;

Log::Any::Adapter->set($ENV{LOG_ADAPTER} || 'Stderr') if $ENV{TEST_VERBOSE};

{
    note "Get /test-static";
    my $mech = Test::WWW::Mechanize::PSGI->new(app => $tester, requests_redirectable => []);
    my $res = $mech->get("/test-static");
    is($mech->status, 200, "Returns 200");
    like($res->header('Link'), qr|<http://localhost/inbox/>;\srel=\"http://www.w3.org/ns/ldp\#inbox\"|, "LDN inbox URL is OK");
	 is($mech->content, '<> <http://www.w3.org/ns/ldp#inbox> <http://localhost/inbox/> .', 'Body is OK');
}

{
    note "Head /test-static";
    my $mech = Test::WWW::Mechanize::PSGI->new(app => $tester, requests_redirectable => []);
    my $res = $mech->head("/test-static");
    is($mech->status, 200, "Returns 200");
    like($res->header('Link'), qr|<http://localhost/inbox/>;\srel=\"http://www.w3.org/ns/ldp\#inbox\"|, "LDN inbox URL is OK");
}

done_testing;

