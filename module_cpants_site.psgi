use Plack::Builder;
use Module::CPANTS::Site;

builder {
    Module::CPANTS::Site->psgi_app;
};
