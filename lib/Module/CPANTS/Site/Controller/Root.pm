package Module::CPANTS::Site::Controller::Root;

use strict;
use warnings;

use base qw( Catalyst::Controller );
use File::Spec::Functions qw(catfile);

__PACKAGE__->config->{ namespace } = '';

sub default : Private {
    my ( $self, $c ) = @_;
    $c->res->status( '404' );
    $c->res->body( 'Not Found' );
}

sub index : Private {
    my ( $self, $c ) = @_;
    $c->stash->{ template } = 'index';
}

sub auto : Private {
    my ($self, $c) = @_;
    $c->stash->{show_experimental} = $c->session->{show_experimental};
    return 1;
}

sub static_html : Regex('^([a-z_0-9]+)\.html$') {
    my ( $self, $c ) = @_;
    my $file = $c->req->captures->[ 0 ];

    $c->detach( 'index' ) if $file eq 'index';

    my @path = ( qw( templates static ), $file );
    $c->detach( 'default' ) unless -e $c->path_to( @path );

    $c->stash->{ template } = join( '/', @path[ 1, 2 ] );
}

sub toggle_experimental : Local {
    my ($self, $c) = @_;

    my $old = $c->session->{show_experimental} || undef;
    if ($old) {
        $c->session->{show_experimental}=undef;
    }
    else {
        $c->session->{show_experimental}=1;
    }
    
    $c->res->redirect('/show_experimental');
    $c->detach;
    
}
sub show_experimental : Local {
    my ($self, $c) = @_;
    $c->response->headers->header('Cache-Control'=>'no-cache');
}

sub end : ActionClass('RenderView') {
    my ( $self, $c ) = @_;
    
    my $kw = $c->model( 'Kwalitee' );
    my $rs = $c->model( 'DBIC::Run' )->search(
        {},
        {
            order_by => 'id desc',
            rows     => 1,
        }
    );
    
    $c->stash->{ VERSION } = Module::CPANTS::Site->VERSION;
    $c->stash->{ run     } = $rs->first;
    $c->stash->{ mck     } = $kw;
    $c->stash->{ perlversion } = $];

    $c->stash->{cpants_is_analysing}=1 if (-e catfile($c->config->{home},'cpants_is_analysing'));
}

1;

__END__

=head1 NAME

Module::CPANTS::Site::Controller::Root - Catalyst Controller

=head1 SYNOPSIS

See L<Module::CPANTS::Site>

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS


=head1 AUTHOR

Thomas Klausner, <domm@cpan.org>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
