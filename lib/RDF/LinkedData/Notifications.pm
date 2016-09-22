use 5.010001;
use strict;
use warnings;

package RDF::LinkedData::Notifications;

our $AUTHORITY = 'cpan:KJETILK';
our $VERSION   = '0.001';

use Moo;
use namespace::autoclean;
use Types::Standard qw(InstanceOf Str Bool Maybe Int HashRef);

use RDF::Trine qw[iri literal blank statement variable];
use RDF::Trine::Serializer;
use RDF::Trine::Namespace;
use Plack::Response;
use RDF::Helper::Properties;
use URI::NamespaceMap;
use URI;
use HTTP::Headers;

has store => (is => 'rw', isa => HashRef | Str );


=item C<< model >>

Returns the RDF::Trine::Model object.

=cut

has model => (is => 'ro', isa => InstanceOf['RDF::Trine::Model'], lazy => 1, builder => '_build_model', 
				  handles => { current_etag => 'etag' });

sub _build_model {
	my $self = shift;
	return $self->_load_model($self->store);
}

sub _load_model {
	my ($self, $store_config) = @_;
	# First, set the base if none is configured
	my $i = 0;
	if (ref($store_config) eq 'HASH') {
		foreach my $source (@{$store_config->{sources}}) {
			unless ($source->{base_uri}) {
				${$store_config->{sources}}[$i]->{base_uri} = $self->base_uri;
			}
			$i++;
		}
	}
	my $store = RDF::Trine::Store->new( $store_config );
	return RDF::Trine::Model->new( $store );
}


=item C<< base_uri >>

Returns or sets the base URI for this handler.

=cut

has base_uri => (is => 'rw', isa => Str, default => '' );


=item C<< request ( [ $request ] ) >>

Returns the L<Plack::Request> object if it exists or sets it if a L<Plack::Request> object is given as parameter.

=cut

has request => ( is => 'rw', isa => InstanceOf['Plack::Request']);

sub discover {

1;

__END__

=pod

=encoding utf-8

=head1 NAME

RDF::LinkedData::Notifications - Experimental implementation of the Linked Data Notifications

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=RDF-LinkedData-Notifications>.

=head1 SEE ALSO

=head1 AUTHOR

Kjetil Kjernsmo E<lt>kjetilk@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2016 by Kjetil Kjernsmo.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.


=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

