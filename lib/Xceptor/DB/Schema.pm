package Xceptor::DB::Schema;
use strict;
use warnings;
use Teng::Schema::Declare;

table {
    name 'projects';
    pk 'id';
    columns qw/ id name created_at updated_at /;
};

table {
    name 'topics';
    pk 'id';
    columns qw/ id project_id title level created_at updated_at /;
};

table {
    name 'reports';
    pk 'id';
    columns qw/ id topic_id reported_by body created_at /;
};

1;
