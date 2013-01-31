use strict;
use warnings;
use t::Util;
use Test::More;
use Xceptor::M::Projects;

subtest 'create' => sub {
    my $project = Xceptor::M::Projects->create(name => 'myapp');
    isa_ok $project, 'HASH';
    is $project->{name}, 'myapp';
    is $project->{id}, 1;
    like $project->{updated_at}, qr/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}\s[0-9]{2}:[0-9]{2}:[0-9]{2}$/;
};

subtest 'fetch' => sub {
    my $project = Xceptor::M::Projects->fetch(id => 1);
    isa_ok $project, 'HASH';
    is $project->{name}, 'myapp';
    is $project->{id}, 1;
};

subtest 'fetch_or_create' => sub {
    my $project = Xceptor::M::Projects->fetch_or_create(name => 'myapp');
    isa_ok $project, 'HASH';
    is $project->{name}, 'myapp';
    is $project->{id}, 1;
    $project = Xceptor::M::Projects->fetch_or_create(name => 'holyshit');
    isa_ok $project, 'HASH';
    is $project->{name}, 'holyshit';
    is $project->{id}, 2;
};

subtest 'search' => sub {
    my @projects = Xceptor::M::Projects->search({name => 'holyshit'});
    is scalar @projects, 1;
    is $projects[0]->{id}, 2;
    @projects = Xceptor::M::Projects->search({},{order_by => 'id DESC'});
    is scalar @projects, 2;
    is join(',',map{$_->{id}} @projects), '2,1';
};

subtest 'name_map' => sub {
    my %projname = Xceptor::M::Projects->name_map;
    is $projname{'1'} => 'myapp';
    is $projname{'2'} => 'holyshit';
};

done_testing;
