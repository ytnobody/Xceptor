use strict;
use warnings;
use utf8;
use t::Util;
use Test::More;
use Test::Exception;
use Xceptor::M::Topics;
use Xceptor::M::Projects;

subtest 'create' => sub {
    my $topic = Xceptor::M::Topics->create(project => 'myapp', title => 'test' );
    isa_ok $topic, 'HASH', 'topics row as hashref';
    is $topic->{project_id}, 1, 'project_id is 1';
    is $topic->{id}, 1, 'topic_id is 1';
    is $topic->{title}, 'test', 'title is "test"';
    is $topic->{level}, undef, 'level is NULL => '.$topic->{level} ;
    like $topic->{updated_at}, qr/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}\s[0-9]{2}:[0-9]{2}:[0-9]{2}$/, 'updated_at as datetime format';
    my $project = Xceptor::M::Projects->fetch(name => 'myapp');
    isa_ok $project, 'HASH', 'project row as hashref';
    is $project->{id}, 1, 'id is 1';
    is $project->{name}, 'myapp', 'name is "myapp"';
    throws_ok { Xceptor::M::Topics->create(project => 'myapp', title => 'test') } qr/Duplicate/, 'Deny duplicate entry';
};

subtest 'fetch' => sub {
    my $topic = Xceptor::M::Topics->fetch(id => 1);
    isa_ok $topic, 'HASH';
    is $topic->{project_id}, 1;
    is $topic->{id}, 1;
    is $topic->{title}, 'test';
    like $topic->{updated_at}, qr/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}\s[0-9]{2}:[0-9]{2}:[0-9]{2}$/;
};

subtest 'fetch_or_create' => sub {
    my $topic = Xceptor::M::Topics->fetch_or_create(project => 'myapp', title => 'test');
    isa_ok $topic, 'HASH';
    is $topic->{id}, 1;
    $topic = Xceptor::M::Topics->fetch_or_create(project => 'foobar', title => 'test');
    isa_ok $topic, 'HASH';
    is $topic->{id}, 2;
    is $topic->{project_id}, 2;
    $topic = Xceptor::M::Topics->fetch_or_create(project => 'myapp', title => 'dummy');
    isa_ok $topic, 'HASH';
    is $topic->{id}, 3;
    is $topic->{project_id}, 1;
};

subtest 'update' => sub {
    my $topic = Xceptor::M::Topics->fetch(id => 1);
    my $old_update = $topic->{updated_at};
    sleep 2;
    Xceptor::M::Topics->update(id => 1, title => 'testtest');
    $topic = Xceptor::M::Topics->fetch(id => 1);
    isnt $topic->{updated_at}, $old_update, $topic->{updated_at}. ' != '. $old_update;
    is $topic->{title}, 'testtest';
    throws_ok { Xceptor::M::Topics->update(id => 1, title => 'test', project => 'foobar') } qr/Duplicate/, 'Deny update when duplicates';
};

TODO: {
    local $TODO = 'データ考える';
    subtest 'search' => sub {};
    subtest 'recent' => sub {};
};

done_testing;
