package Shrtr::Schema::Result::Click;

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

Shrtr::Schema::Result::Click

=cut

__PACKAGE__->table("click");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 url

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 ts

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 referrer

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 user_agent

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 ip_address

  data_type: 'varchar'
  is_nullable: 1
  size: 15

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "url",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "ts",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "referrer",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "user_agent",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "ip_address",
  { data_type => "varchar", is_nullable => 1, size => 15 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 url

Type: belongs_to

Related object: L<Shrtr::Schema::Result::Url>

=cut

__PACKAGE__->belongs_to(
  "url",
  "Shrtr::Schema::Result::Url",
  { id => "url" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2012-04-08 16:55:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QKX3HxrPBWEZWIqX7fmKqQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
