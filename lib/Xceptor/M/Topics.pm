package Xceptor::M::Topics;
use strict;
use warnings;
use utf8;
use Xceptor::Context::Declare;
use Xceptor::M::Projects;
use Time::Piece;

sub create {
    my ($class, %vals) = @_;
    my $txn = c->db->txn_scope;
    my $project_name = delete $vals{project};
    my $project = Xceptor::M::Projects->fetch_or_create(name => $project_name);
    my $topic = c->db->insert('topics', {
        project_id  => $project->{id},
        title       => $vals{title}, 
        updated_at  => localtime->strftime('%Y-%m-%d %H:%M:%S'),
    });
    $txn->commit if $project && $topic;
    return $topic;
}

sub update {
    my ($class, %vals) = @_;
    $vals{updated_at} = localtime->strftime('%Y-%m-%d %H:%M:%S');
    my $id = delete $vals{id};
    c->db->update('topics', \%vals, {id => $id});
}

sub fetch {
    my ($class, %vals) = @_;
    c->db->single('topics', \%vals);
}

sub fetch_or_create {
    my ($class, %vals) = @_;
    my $project = delete $vals{project};
    $class->fetch(%vals) || $class->create(%vals, project => $project);
}

sub search {
    my $class = shift;
    c->db->search('topics', @_);
}
1;
