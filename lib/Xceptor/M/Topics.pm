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
        level       => $vals{level},
    });
    $txn->commit if $project && $topic;
    return $topic;
}

sub update {
    my ($class, %vals) = @_;
    if ( $vals{project} ) {
        my $project_name = delete $vals{project};
        my $project = Xceptor::M::Projects->fetch(name => $project_name);
        $vals{project_id} = $project->{id};
    }
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
    my $project_name = delete $vals{project};
    my $project = Xceptor::M::Projects->fetch(name => $project_name);
    $class->fetch(%vals, project_id => $project->{id}) || $class->create(%vals, project => $project_name);
}

sub search {
    my $class = shift;
    c->db->search('topics', @_);
}

sub recent {
    my ($class, $num) = @_;
    $num ||= 50;
    my %project_name = Xceptor::M::Projects->name_map;
    map { 
        $_->{project_name} = $project_name{$_->{project_id}}; 
        $_;
    } ( c->db->search('topics',{},{order_by => 'updated_at DESC', limit => $num})->all );
}
1;
