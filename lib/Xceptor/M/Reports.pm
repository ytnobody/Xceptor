package Xceptor::M::Reports;
use strict;
use warnings;
use utf8;
use Xceptor::Context::Declare;
use Xceptor::M::Topics;

sub create {
    my ($class, %vals) = @_;
    my $txn = c->db->txn_scope;
    my $title = delete $vals{title};
    my $project = delete $vals{project};
    my $topic = Xceptor::M::Topics->fetch_or_create(project => $project, title => $title);
    my $report = c->db->insert('reports', {
        reported_by => $vals{reported_by},
        body => $vals{body},
        topic_id => $topic->{id},
    });
    $txn->commit if $topic && $report;
    return $report;
}

sub fetch {
    my ($class, %vals) = @_;
    c->db->single('reports', \%vals);
}

sub search {
    my $class = shift;
   c->db->search('reports', @_);
}

1;
