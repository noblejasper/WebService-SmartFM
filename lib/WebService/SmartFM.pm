package WebService::SmartFM;

=head1 NAME

WebService::SmartFM - Perl interface to the http://smart.fm/ API

=head1 VERSION

This document describes WebService::SmartFM version 0.0.1

=head1 SYNOPSIS

    use WebServices::SmartFM;
    my $api = WebService::SmartFM->new(
        api_key => 'd6bu49h84yj85z2mgnbh5t4j',
    );
    my $user_profile = $api->get('user_profile', 'noblejasper');

=head1 METHODS

=over 4

=cut

use warnings;
use strict;
use Carp;
use 5.008_001;

use version; our $VERSION = qv('0.0.4');

use XML::Parser;
use WebService::Simple;

=item new

    my $api = WebService::SmartFM->new(
        api_key => 'd6bu49h84yj85z2mgnbh5t4j',
    );

=cut

sub new {
    my ( $self, %args ) = @_;

    Carp::croak "You must set api_key" unless($args{api_key});
    return bless {
        'smart_fm' => WebService::Simple->new(
            base_url => 'http://api.smart.fm/',
            param    => { api_key => $args{api_key}, },
        ),
    }, $self;
}

my $KEYS = {
    'user_profile' => { sprintf => 'users/%s', hash_key =>'user' },
    'user_study_lists'  => { sprintf => 'users/%s/lists',          hash_key =>'channel' },
    'user_study_items'  => { sprintf => 'users/%s/items',          hash_key =>'items'   },
    'user_following'    => { sprintf => 'users/%s/friends',        hash_key =>'user'    },
    'user_followers'    => { sprintf => 'users/%s/followers',      hash_key =>'user'    },
    'recent_sentences'  => { sprintf => '/sentences',             bared    => 1        },

    # these is no test m(_ _)m
    'search lists'      => { sprintf => '/lists/matching/%s',     hash_key =>'channel' },
    'search_items'      => { sprintf => '/items/matching/%s',     hash_key =>'items'   },
    'items_in_list'     => { sprintf => '/lists/%s/items',        hash_key =>'channel' },
    'search_sentences'  => { sprintf => '/sentences/matching/%s', bared    => 1        },
    'sentences_in_list' => { sprintf => '/lists/%s/sentences',    bared    => 1        },
    'recent_lists'      => { sprintf => '/lists',                 hash_key =>'channel' },
    'recent_items'      => { sprintf => '/items',                 hash_key =>'items'   },
    'sessions'          => { sprintf => '/sessions',              bared    => 1        },

    # why... request to http://api.smart.fm/users/noblejasper/study_results?api_key=xxx failed
    # 'user_study_results' => { sprintf => 'users/%s/study_results', hash_key =>'' },
};

=item get

get data method

    $api->get('get data type', 'key value')

=cut

sub get {
    my ( $self, $key_name, $value ) = @_;
    my $key = $KEYS->{$key_name};
    $value ||= '';
    Carp::croak 'Undefines key name is ' . $key_name unless( $key );
    return $self->_get_bared( sprintf( $key->{sprintf}, $value ) )
        if ( defined $key->{bared} && $key->{bared} );
    return $self->_get(
        sprintf( $key->{sprintf}, $value || '' ),
        defined $key->{hash_key} ? $key->{hash_key} : '',
    );
}
sub _get {
    my ( $self, $path, $hash_key ) = @_;
    my $data = $self->_smart_fm->get( $path );

    return $hash_key
        ? $data->parse_response->{$hash_key}
        : $data->parse_response;
}

sub _get_bared {
    my ( $self, $path ) = @_;
    return $self->_smart_fm->get( $path );
}

sub _smart_fm {
    my $self = shift;

    $self->{smart_fm} = WebService::Simple->new(
        base_url => 'http://api.smart.fm/',
    ) unless ( $self->{smart_fm} );
    return $self->{smart_fm};
}

1; # Magic true value required at end of module
__END__

=back

=head1 DEPENDENCIES

L<WebService::Simple>

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

CODE is here http://github.com/noblejasper/WebService-SmartFM

Please report any bugs or feature requests to
C<bug-webservice-smartfm@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

<noblejasper>  C<< <<nobjas@gmail.com>> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2009, <noblejasper> C<< <<nobjas@gmail.com>> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
