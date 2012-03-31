package Module::CPANTS::Site::Controller::JSON;

use base qw/Catalyst::Controller/;

sub end : Private {
    my ($self,$c) = @_;
    $c->detach($c->view('JSON'));
}

1;