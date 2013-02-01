use strict;
use warnings;
use utf8;
use t::Util;
use Test::More;
use Test::Exception;
use Xceptor::M::Reports;
use Xceptor::M::Topics;
use Xceptor::M::Projects;

subtest 'create' => sub {
    my $report = Xceptor::M::Reports->create(project => 'myapp', title => 'test', body => 'This is a test', reported_by => 'ytnobody');
    isa_ok $report, 'HASH';
    is $report->{id}, 1;
    is $report->{topic_id}, 1;
    is $report->{body}, 'This is a test';
    is $report->{reported_by}, 'ytnobody';
    my $topic = Xceptor::M::Topics->fetch(id => $report->{topic_id});
    isa_ok $topic, 'HASH';
    is $topic->{project_id}, 1;
    is $topic->{id}, $report->{topic_id};
    is $topic->{title}, 'test';
    is $topic->{level}, undef;
    like $topic->{updated_at}, qr/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}\s[0-9]{2}:[0-9]{2}:[0-9]{2}$/;
    my $project = Xceptor::M::Projects->fetch(name => 'myapp');
    isa_ok $project, 'HASH';
    is $project->{id}, 1;
    is $project->{name}, 'myapp';
    $report = Xceptor::M::Reports->create(project => 'myapp', title => 'test', body => 'This is a test too!');
    is $report->{id}, 2;
    is $report->{topic_id}, 1;
    is $report->{body}, 'This is a test too!';
    is $report->{reported_by}, undef;
    $report = Xceptor::M::Reports->create(project => 'yourapp', title => 'test', body => 'this test', reported_by => 'oreore');
    is $report->{id}, 3;
    is $report->{topic_id}, 2;
    is $report->{body}, 'this test';
    is $report->{reported_by}, 'oreore';
    throws_ok { Xceptor::M::Topics->create(project => 'myapp', title => 'test') } qr/Duplicate/, 'Deny duplicate entry';
};

subtest 'fetch' => sub {
    my $report = Xceptor::M::Reports->fetch(id => 1);
    isa_ok $report, 'HASH';
    is $report->{topic_id}, 1;
    is $report->{id}, 1;
    is $report->{body}, 'This is a test';
};

TODO: {
    local $TODO = 'データ考える';
    subtest 'search' => sub {};
};

done_testing;
