#!/usr/bin/env perl

use strict;
use warnings;
use Plack::Request;
use Plack::Response;
use Plack::Builder;
use Config::JFDI;
use Carp qw(confess);
use HTTP::Headers;

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
	 $config->{base_uri} = 'http://localhost/';
  } else {
	 confess "Couldn't find config";
  }
}

#my $linkeddata = Plack::App::RDF::LinkedData->new();

#$linkeddata->configure($config);

#my $rdf_linkeddata = $linkeddata->to_app;

my $ldn_app = sub {
  my $env = shift;
  my $res = Plack::Response->new(200);
  $res->headers({Link => 'foo', "Content-type" => "text/plain" });
  $res->body('foo');
  return $res->finalize;
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
