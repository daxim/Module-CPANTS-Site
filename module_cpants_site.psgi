use strict;
use warnings;

use Module::CPANTS::Site;

my $app = Module::CPANTS::Site->apply_default_middlewares(Module::CPANTS::Site->psgi_app);
$app;

