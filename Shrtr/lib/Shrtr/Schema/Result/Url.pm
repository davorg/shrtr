package Shrtr::Schema::Result::Url;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Shrtr::Schema::Result::Url

=cut

__PACKAGE__->table("url");

=head1 ACCESSORS

=head2 code

  data_type: 'char'
  is_nullable: 0
  size: 10

=head2 url

  data_type: 'text'
  is_nullable: 1

=head2 clicks

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "code",
  { data_type => "char", is_nullable => 0, size => 10 },
  "url",
  { data_type => "text", is_nullable => 1 },
  "clicks",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("code");

=head1 RELATIONS

=head2 clicks

Type: has_many

Related object: L<Shrtr::Schema::Result::Click>

=cut

__PACKAGE__->has_many(
  "clicks",
  "Shrtr::Schema::Result::Click",
  { "foreign.code" => "self.code" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-04-07 18:07:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:l7R0kmpTDN1yZj4gR4dfWA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
