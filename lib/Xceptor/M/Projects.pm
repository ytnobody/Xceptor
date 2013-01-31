package Xceptor::M::Projects;
use strict;
use warnings;
use utf8;
use Xceptor::Context::Declare;
use Time::Piece;

sub create {
    my ($class, %vals) = @_;
    $vals{updated_at} = localtime->strftime('%Y-%m-%d %H:%M:%S');
    c->db->insert('projects', \%vals);
}

sub fetch {
    my ($class, %vals) = @_;
    c->db->single('projects', \%vals);
}

sub fetch_or_create {
    my ($class, %vals) = @_;
    $class->fetch(%vals) || $class->create(%vals);
}

sub search {
    my $class = shift;
    c->db->search('projects', @_);
}

sub name_map {
    my $class = shift;
    map { ( $_->{id} => $_->{name} ) } ( c->db->search_by_sql('SELECT id, name FROM projects')->all );
}

1;
