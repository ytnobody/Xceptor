package Xceptor::API;
use strict;
use warnings;
use Nephia;
use Xceptor::M::Projects;
use Xceptor::M::Topics;
use Xceptor::M::Reports;

get '/api/projects' => sub {
    my $limit = req->param('limit') || 50;
    my $page = req->param('page') || 0;
    my $offset = $limit * $page;
    return +{
        projects => [ Xceptor::M::Projects->search({},{order_by => 'id ASC', limit => $limit, offset => $offset}) ],
    };
};

get '/api/topics/{project:.+}' => sub {
    my $projecs = Xceptor::M::Projects->fetch(name => param->{project}) or res { 404 };
    my $limit = req->param('limit') || 50;
    my $page = req->param('page') || 0;
    my $offset = $limit * $page;
    return +{ 
        topics => [ Xceptor::M::Topics->search({},{order_by => 'updated_at DESC', limit => $limit, offset => $offset}) ],
    };
};

get '/api/reports/{project:.+}/{id:.+}' => sub {
    my $project = Xceptor::M::Projects->fetch(name => param->{project}) or return res { 404 };
    my $topic = Xceptor::M::Topics->fetch(project_id => $project->{id}, id => param->{id}) or return res { 404 };
    my $limit = req->param('limit') || 50;
    my $page = req->param('page') || 0;
    my $offset = $limit * $page;
    return +{
        reports => [ Xceptor::M::Reports->search({topic_id => $topic->{id}},{order_by => 'created_at DESC', limit => $limit, offset => $offset})->all ],
    };
};

get '/api/active_topics' => sub {
    return +{
        topics => [ Xceptor::M::Topics->recent ],
    };
};

post '/api/report/{project:.+}' => sub {
    return res { 404 } unless req->param('title');
    my %data = (
        project     => param->{project},
        title       => req->param('title') || undef,
        body        => req->param('body') || undef,
        reported_by => req->param('reported_by') || undef,
    );
    my $report = Xceptor::M::Reports->create(%data);
    return +{
        report => $report,
    };
};

post '/api/topic/update/{project:.+}/{id:.+}' => sub {
    my $project = Xceptor::M::Projects->fetch(name => param->{project}) or return req { 404 };
    my $topic = Xceptor::M::Topics->fetch(id => param->{id}, project_id => $project->{id}) or return req { 404 };
    if (req->param('note') || req->param('level')) {
        my %set = ();
        $set{note} = req->param('note') if req->param('note');
        $set{level} = req->param('level') if req->param('level');
        Xceptor::M::Topics->update(id => $topic->{id}, %set);
        $topic = Xceptor::M::Topics->fetch(id => param->{id}, project_id => $project->{id});
    }
    return +{
        topic => $topic,
    };
};

1;
