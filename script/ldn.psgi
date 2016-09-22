#!/usr/bin/env perl

use strict;
use warnings;
use Plack::Request;
use Plack::Response;
use Plack::Builder;
use Config::JFDI;
use Carp qw(confess);
use HTTP::Headers;
use RDF::LinkedData::Notifications;


=head1 NAME

ldn.psgi - A simple Plack server for Linked Data Notifications

=head1 INSTRUCTIONS

See L<Plack::App::RDF::LinkedData> for instructions on how to use this.

=cut



my $config;
BEGIN {
  #	unless ($config = Config::JFDI->open(
#                                        name => "RDF::LinkedData"
  #                                       )) {
  if ($ENV{'PERLRDF_STORE'}) {
	 $config->{store} = $ENV{'PERLRDF_STORE'};
	 $config->{base_uri} = 'http://localhost';
	 $config->{inbox_path} = '/inbox/';
  } else {
	 confess "Couldn't find config";
  }
}

#my $linkeddata = Plack::App::RDF::LinkedData->new();

my $ldn = RDF::LinkedData::Notifications->new(base_uri => $config->{base_uri},
															 inbox_path => $config->{inbox_path},
															 store => $config->{store});
#$linkeddata->configure($config);

#my $rdf_linkeddata = $linkeddata->to_app;

my $ldn_app = sub {
  my $env = shift;
  $ldn->request(Plack::Request->new($env));
  return $ldn->discover->finalize;
};

builder {
	enable "Head";
	$ldn_app;
};


__END__


=head1 AUTHOR

Kjetil Kjernsmo C<< <kjetilk@cpan.org> >>

=head1 COPYRIGHT

Copyright (c) 2016 Kjetil Kjernsmo. This program is free software; you
can redistribute it and/or modify it under the same terms as Perl
itself.

=cut
