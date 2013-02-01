use strict;
use warnings;
use t::Util;
use Test::More;
use Test::TCP;
use Xceptor::Agent;
use Xceptor::M::Topics;
use Xceptor::M::Projects;

my $server = Test::TCP->new(
    code => sub {
        my $port = shift;
        exec 'plackup', '-p' => $port;
    },
);

my $agent = Xceptor::Agent->new(
    base_url => 'http://127.0.0.1:'.$server->port,
    project => 'xceptor-agent',
);

my $report = $agent->report(
    title => 'test report',
    body  => 'xceptor-agent test',
);

isa_ok $report, 'HASH';
is $report->{id}, '1';
is $report->{body}, 'xceptor-agent test';
is $report->{topic_id}, 1;

my $topic = Xceptor::M::Topics->fetch(id => 1);
isa_ok $topic, 'HASH';
is $topic->{project_id}, 1;
is $topic->{title}, 'test report';

my $project = Xceptor::M::Projects->fetch(id => 1);
isa_ok $project, 'HASH';
is $project->{id}, 1;
is $project->{name}, 'xceptor-agent';

done_testing;
